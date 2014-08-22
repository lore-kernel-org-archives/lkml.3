Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaHVBwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 21:52:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:38267 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227AbaHVBwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 21:52:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,377,1406617200"; 
   d="scan'208";a="580186027"
Date: Fri, 22 Aug 2014 09:52:23 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [ext4] 71d4f7d0321: -49.6% xfstests.generic.274.seconds
Message-ID: <20140822015223.GA11430@localhost>
References: <20140821143006.GA19943@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140821143006.GA19943@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 10:30:06PM +0800, Fengguang Wu wrote:
> Hi Ted,
> 
> We noticed increased xfstests 274's test speed and the first good
> commit is 71d4f7d032149b935a26eb3ff85c6c837f3714e1 ("ext4: remove
> metadata reservation checks").
> 
> test case: snb-drag/xfstests/4HDD-ext4-generic-slow2
> snb-drag is a Sandy Bridge PC with 6G memory.
> 
> d5e03cbb0c88cd1  71d4f7d032149b935a26eb3ff 
> ---------------  ------------------------- 
>         51 ± 2%     -49.6%         25 ± 1%  TOTAL xfstests.generic.274.seconds
>        817 ± 1%      -3.0%        792 ± 1%  TOTAL time.elapsed_time
> 
>                           xfstests.generic.274.seconds
> 
>   60 ++---------------------------------------------------------------------+
>      |                                                                      |
>   55 ++         .*..*..             *..               *..                   |
>      |       .*.       .          ..                ..                      |
>   50 *+.*..*.           *..*..*..*     *..*..*..*..*     *                  |
>      |                                                                      |
>   45 ++                                                                     |
>      |                                                                      |
>   40 ++                                                                     |
>      |                                                                      |
>   35 ++                                                                     |
>      |                                                                      |
>   30 ++                                                                     |
>      |                                                                      |
>   25 O+-O--O--O--O--O---O--O--O--O--O--O--O--O--O--O--O--O---O--O--O--O--O--O
> 
> 
> 	[*] bisect-good sample
> 	[O] bisect-bad  sample

This is sweet, got another improvement:

testbox/testcase/testparams: snb-drag/xfstests/4HDD-ext4-generic-mid

d5e03cbb0c88cd1  71d4f7d032149b935a26eb3ff  
---------------  -------------------------  
        45 ± 4%     -50.2%         22 ± 7%  xfstests.generic.256.seconds
   7044859 ± 2%      -7.0%    6553446 ± 0%  time.minor_page_faults
     36156 ± 2%      -7.0%      33638 ± 0%  time.involuntary_context_switches
    171551 ± 1%      -4.8%     163312 ± 0%  time.voluntary_context_switches
       436 ± 1%      -5.7%        411 ± 0%  time.elapsed_time

                           time.voluntary_context_switches

  176000 ++-----------------------------------------------------------------+
         |                   *        *..         *..                       |
  174000 ++       *..      .. :      :   *..*    :   *                      |
  172000 ++     ..     .*.*   :      :       +   :    +                     |
         *..*..*     *.        :    :         + :      +  .*                |
  170000 ++                    :  .*           *        *.                  |                                                                   
  168000 ++                     *.                                          |
         |                                                                  |
  166000 ++                                                                 |
  164000 ++                     O                                  O        |
         |                   O     O  O     O     O  O  O       O     O  O  O
  162000 ++ O        O  O O                                O O              |
  160000 O+                              O     O                            |
         |     O  O                                                         |
  158000 ++-----------------------------------------------------------------+


                          xfstests.generic.256.seconds

  60 ++-----------------------------*---------------------------------------+
     |                             : :                                      |
  55 ++                            : :                                      |
  50 ++                           :   :                                     |
     | .*..                     .*    :     .*..                            |
  45 *+    *..  .*..*...*..*..*.       : .*.      .*..  .*                  |
     |        *.                       *.       *.    *.                    |
  40 ++                                                                     |
     |                                                                      |
  35 ++                                                                     |
  30 ++                                                                     |
     |                                                                      |
  25 ++                                                  O         O        |
     O  O     O  O      O  O           O     O     O         O  O     O  O  |
  20 ++----O--------O---------O--O--O-----O-----O-----O---------------------O

Thanks,
Fengguang
