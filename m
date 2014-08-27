Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936189AbaH1DTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 23:19:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:44266 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932578AbaH1DTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 23:19:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,415,1406617200"; 
   d="scan'208";a="590929438"
Date: Thu, 28 Aug 2014 03:18:16 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>, Ben Segall <bsegall@google.com>,
        Jason Low <jason.low2@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, fengguang.wu@intel.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com
Subject: [PATCH RESULT] sched: Rewrite per entity runnable load average
 tracking v5
Message-ID: <20140827191816.GI2480@intel.com>
References: <1409094682.29189.23.camel@j-VirtualBox>
 <CAPM31RJcYakzwo9mByoadw6DGcg5SfYDOdX79NPo08hBP5PGjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPM31RJcYakzwo9mByoadw6DGcg5SfYDOdX79NPo08hBP5PGjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

We finished a round of tests for AIM7 workload for the patch v5 by LKP, the
result is as follows:

Hostname: brickland3
Model: Brickland Ivy Bridge-E
CPU: 120
Memory: 512G

      v3.16-rc7         rewrite-v5          testbox/testcase/testparams
---------------  -------------------------  ---------------------------
     %stddev        %change               %stddev
            \          |                 /
     26317 ± 3%     +34.7%      35437 ± 1%  brickland3/aim7/2000-fork_test
     43481 ± 0%      +0.5%      43712 ± 0%  brickland3/aim7/3000-brk_test
     80810 ± 0%      -0.2%      80625 ± 1%  brickland3/aim7/3000-sieve
    489830 ± 1%     +14.7%     561691 ± 1%  brickland3/aim7/8000-disk_src
   1672643 ±12%     -13.0%    1455960 ± 6%  brickland3/aim7/8000-disk_wrt
   1193986 ± 0%      -1.5%    1175841 ± 0%  brickland3/aim7/8000-mem_rtns_1
    875113 ±13%     +21.9%    1067191 ±13%  brickland3/aim7/8000-misc_rtns_1
   1188420 ± 1%      -3.2%    1150624 ± 0%  brickland3/aim7/8000-sort_rtns_1
    807986 ± 0%      -0.7%     802275 ± 0%  brickland3/aim7/8000-string_rtns
   6378589 ± 5%      -0.1%    6373359 ± 4%  TOTAL aim7.jobs-per-min

---------------  -------------------------  
       339 ± 7%     -22.9%        262 ± 0%  brickland3/aim7/2000-fork_test
       463 ± 0%      +0.4%        465 ± 0%  brickland3/aim7/3000-brk_test
       337 ± 9%      -3.1%        327 ± 6%  brickland3/aim7/3000-disk_rd
       534 ± 0%      +0.9%        539 ± 0%  brickland3/aim7/3000-sieve
       391 ± 0%     -10.7%        349 ± 1%  brickland3/aim7/8000-disk_src
       301 ± 4%     +10.0%        331 ± 5%  brickland3/aim7/8000-disk_wrt
       405 ± 1%      +6.0%        429 ± 0%  brickland3/aim7/8000-mem_rtns_1
       227 ±25%      -0.8%        225 ±12%  brickland3/aim7/8000-misc_rtns_1
       395 ± 1%      +5.1%        415 ± 0%  brickland3/aim7/8000-sort_rtns_1
       419 ± 0%      +4.6%        438 ± 0%  brickland3/aim7/8000-string_rtns
      3815 ± 3%      -0.8%       3784 ± 2%  TOTAL turbostat.Pkg_W

---------------  -------------------------  
     90.79 ± 1%     -15.1%      77.04 ± 0%  brickland3/aim7/2000-fork_test
     62.42 ± 0%      -0.0%      62.41 ± 0%  brickland3/aim7/3000-brk_test
     61.69 ± 2%      -1.3%      60.92 ± 2%  brickland3/aim7/3000-disk_rd
    137.13 ± 0%      +0.2%     137.39 ± 0%  brickland3/aim7/3000-sieve
     66.03 ± 1%      +0.6%      66.41 ± 0%  brickland3/aim7/8000-disk_src
     53.94 ± 2%      +6.1%      57.21 ± 0%  brickland3/aim7/8000-disk_wrt
     54.43 ± 0%      +4.8%      57.02 ± 0%  brickland3/aim7/8000-mem_rtns_1
     58.71 ± 2%      +0.0%      58.72 ± 1%  brickland3/aim7/8000-misc_rtns_1
     53.78 ± 1%      +4.8%      56.36 ± 0%  brickland3/aim7/8000-sort_rtns_1
     56.47 ± 2%      +2.5%      57.89 ± 0%  brickland3/aim7/8000-string_rtns
    695.38 ± 1%      -0.6%     691.37 ± 1%  TOTAL turbostat.RAM_W

---------------  -------------------------  
     23.40 ±22%     -16.2%      19.60 ± 1%  brickland3/aim7/2000-fork_test
     97.28 ± 0%      -0.0%      97.25 ± 0%  brickland3/aim7/3000-brk_test
     35.09 ±24%      -8.7%      32.05 ±21%  brickland3/aim7/3000-disk_rd
     94.92 ± 0%      -0.0%      94.88 ± 0%  brickland3/aim7/3000-sieve
     41.04 ± 2%     -26.8%      30.06 ± 3%  brickland3/aim7/8000-disk_src
     36.54 ±11%     -10.2%      32.82 ±12%  brickland3/aim7/8000-disk_wrt
     61.39 ± 2%      -7.4%      56.87 ± 1%  brickland3/aim7/8000-mem_rtns_1
     62.57 ± 4%     -11.1%      55.64 ± 3%  brickland3/aim7/8000-sort_rtns_1
     76.06 ± 2%      -3.4%      73.51 ± 0%  brickland3/aim7/8000-string_rtns
    528.30 ± 4%      -6.7%     492.67 ± 3%  TOTAL turbostat.%c0

For performance, I think the overall is flat. For power, we can see some
benefits. In perticular, the stddev indicates the variation is smaller than
v3.16-rc7 (all subtests are done at least for 5 times).

To Jason, the format or specific metric is not directly comparable with your
tests. If you can specify how to get the same look as your tests, we are happy
to try.

Thanks,
Yuyang
