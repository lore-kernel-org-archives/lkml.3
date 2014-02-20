Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713AbaBTNH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:07:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:16093 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019AbaBTNH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:07:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,512,1389772800"; 
   d="scan'208";a="478438201"
Date: Thu, 20 Feb 2014 21:06:46 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: [x86] 339a3922f6: +4.3% aim7 jobs-per-min
Message-ID: <20140220130646.GA22815@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maarten,

We are glad to find that your commit 339a3922f68dcb7d93001f07b7e914d5cf6c066d
("decrease useless padding") increased aim disk_src performance by 4.3%:

74833276be6802b  339a3922f68dcb7d93001f07b  
---------------  -------------------------  
    511685 ~ 0%      +4.3%     533571 ~ 0%  TOTAL aim7.2000.jobs-per-min
     77.30 ~ 0%      -9.9%      69.66 ~ 0%  TOTAL time.system_time
      1.95 ~ 2%      +7.0%       2.09 ~ 2%  TOTAL iostat.sda.rrqm/s
     23.57 ~ 0%      -4.1%      22.60 ~ 0%  TOTAL time.elapsed_time
       425 ~ 0%      -3.1%        412 ~ 0%  TOTAL time.percent_of_cpu_this_job_got
      7.59 ~ 0%      -2.9%       7.37 ~ 0%  TOTAL boottime.dhcp
     15.24 ~ 0%      -1.9%      14.94 ~ 0%  TOTAL boottime.boot

                                 time.system_time

   82 ++--------------------------------------------------------------------+
      |                                                                     |
   80 ++                                 ..*..                              |
      |                   .*..        .*.          .*..                     |
   78 ++.*..*..*..*..*..*.    *..  .*.        *..*.    *..*..        .*..*  |
      *.                         *.                          *..*..*.       |
   76 ++                                                                    |
      |                                                                     |
   74 ++                                                                    |
      |                                                                     |
   72 ++                                                                    |
      |                                                                     |
   70 O+ O  O  O  O  O  O  O  O     O  O   O  O  O  O  O           O  O  O  |
      |                                                   O  O  O           O
   68 ++-------------------------O------------------------------------------+


                                  time.elapsed_time

     24 ++------------------------------------------------------------------+
        |                                  *..                              |
   23.8 ++                                +   *..                           |
        *..*..  .*..     .*..*..*..  .*..*       *..*..*..*..        .*..   |
   23.6 ++    *.    *..*.          *.                        *..*..*.    *  |
   23.4 ++                                                                  |
        |                                                                   |
   23.2 ++                                                                  |
        |                                                                   |
     23 ++                                                                  |
        |                                                                   |
   22.8 ++          O              O     O    O              O              |
   22.6 O+ O  O  O     O  O  O  O     O    O     O  O  O        O  O  O  O  O
        |                                                 O                 |
   22.4 ++------------------------------------------------------------------+


                                aim7.2000.jobs-per-min

   540000 ++----------------------------------------------------------------+
          |                                                                 |
   535000 O+ O  O             O        O    O     O  O  O  O     O O  O  O  |
   530000 ++       O O  O  O     O  O     O    O              O             O
          |                                                                 |
   525000 ++                                                                |
          |                                                                 |
   520000 ++                                                                |
          |                                                                 |
   515000 ++                                                    .*.         |
   510000 *+.*..*..*.*..*..*..*..*..*..                      .*.   *..  .*  |
          |                            *..*.     .*..*..*..*.         *.    |
   505000 ++                                *..*.                           |
          |                                                                 |
   500000 ++----------------------------------------------------------------+

