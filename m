Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaCCOZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:25:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:11303 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbaCCOZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:25:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,577,1389772800"; 
   d="scan'208";a="484841032"
Date: Mon, 3 Mar 2014 22:21:51 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Chinner <dchinner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [xfs] f876e446: +1.2% fileio.requests_per_sec
Message-ID: <20140303142151.GA7935@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

We noticed the below changes on commit f876e44603ad091c840a5fae5b0753bbb421c037
("xfs: always do log forces via the workqueue"):

Basically there are +1.2% increased throughput with +29.5% increased
context switches.

test box: NHM
test case: fileio rndwr-sync

      v3.14-rc1  f876e44603ad091c840a5fae5  
---------------  -------------------------  
       192 ~ 0%      +1.2%        194 ~ 0%  TOTAL fileio.requests_per_sec
         2 ~25%     +47.4%          4 ~ 0%  TOTAL time.percent_of_cpu_this_job_got
      1907 ~16%     +29.5%       2471 ~ 0%  TOTAL vmstat.system.cs
    331131 ~ 0%     +10.9%     367298 ~ 0%  TOTAL time.voluntary_context_switches
      3255 ~ 0%   +2330.6%      79126 ~ 0%  TOTAL time.involuntary_context_switches
   3703982 ~ 0%      +1.2%    3747974 ~ 0%  TOTAL time.file_system_outputs
     35.04 ~20%      +9.8%      38.48 ~ 0%  TOTAL iostat.sda.wrqm/s

                             time.voluntary_context_switches
 
    380000 ++----------------------------------------------------------------+
    360000 O+ O  O  O O  O  O  O  O  O  O  O O  O  O  O  O  O  O  O O  O  O  O
           |                                                                 |
    340000 *+.*..*..*.*..*..*..*..*..*..*..*    *..*..*..*..*..*..*.*        |
    320000 ++                              :    :                            |
           |                               :   :                             |
    300000 ++                               :  :                             |
    280000 ++                               :  :                             |
    260000 ++                               :  :                             |
           |                                : :                              |
    240000 ++                               : :                              |
    220000 ++                                ::                              |
           |                                 :                               |
    200000 ++                                *                               |
    180000 ++----------------------------------------------------------------+
 
 
                           time.involuntary_context_switches
 
    80000 ++------------------------O--O--O--O-----O--O--O--O-O--O--O--O--O--O
          O  O  O  O  O  O O  O  O              O                            |
    70000 ++                                                                 |
    60000 ++                                                                 |
          |                                                                  |
    50000 ++                                                                 |
          |                                                                  |
    40000 ++                                                                 |
          |                                                                  |
    30000 ++                                                                 |
    20000 ++                                                                 |
          |                                                                  |
    10000 ++                                                                 |
          *..*..*..*..*..*.*..*..*..*..*..*..*..*..*..*..*..*.*..*..*        |
        0 ++-----------------------------------------------------------------+
 
Thanks,
Fengguang
