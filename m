Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaDEAVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 20:21:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:61940 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaDEAVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 20:21:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,798,1389772800"; 
   d="scan'208";a="507336610"
Date: Fri, 4 Apr 2014 21:59:08 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [mm] e04ddfd12aa: +9.4% ebizzy.throughput
Message-ID: <20140404135908.GB22386@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davidlohr,

FYI, there are noticeable ebizzy throughput increases on commit
e04ddfd12aa03471eff7daf3bc2435c7cea8e21f ("mm: per-thread vma caching")

test case: lkp-st02/micro/ebizzy/200%-100-10

700141f349f2b05  e04ddfd12aa03471eff7daf3b  
---------------  -------------------------  
     23726 ~ 0%      +9.4%      25955 ~ 0%  TOTAL ebizzy.throughput
      1525 ~ 0%      +9.3%       1667 ~ 0%  TOTAL ebizzy.throughput.per_thread.max
      1428 ~ 0%      +9.1%       1558 ~ 0%  TOTAL ebizzy.throughput.per_thread.min
     14.42 ~ 0%      +8.1%      15.59 ~ 0%  TOTAL ebizzy.time.user
     65.29 ~ 0%      -1.8%      64.12 ~ 0%  TOTAL ebizzy.time.sys
      4290 ~17%     -28.4%       3073 ~22%  TOTAL slabinfo.buffer_head.active_objs
      4313 ~17%     -28.8%       3073 ~22%  TOTAL slabinfo.buffer_head.num_objs
    165372 ~ 0%      +9.2%     180527 ~ 0%  TOTAL vmstat.system.in
      1443 ~ 0%      +8.1%       1560 ~ 0%  TOTAL time.user_time
      6529 ~ 0%      -1.8%       6413 ~ 0%  TOTAL time.system_time

Legend:
	~XX%    - stddev percent
	[+-]XX% - change percent


                                  ebizzy.throughput

   26500 ++O-----------O---O------------------------------------------------+
         O   O O O O     O   O O O     O O                                  |
   26000 ++          O             O O      O     O                         |
         |                                 O  O O                           |
         |                                                                  |
   25500 ++                                                                 |
         |                                                                  |
   25000 ++                                                                 |
         |                                                                  |
   24500 ++                                                                 |
         |                                                                  |
         *.*.*.   .*. .*.*.*.   .*.*.       *.*.*.*.                        |
   24000 ++    *.*   *       *.*     *.*.*.*        *.*.*.*.*.*.            |
         |                                                      *.*.*.*.*.*.*
   23500 ++-----------------------------------------------------------------+


	[*] bisect-good sample
	[O] bisect-bad  sample

Thanks,
Fengguang
