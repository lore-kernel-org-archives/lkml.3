Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaAQNA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 08:00:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:16242 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaAQNA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 08:00:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="460486971"
Date: Fri, 17 Jan 2014 21:00:52 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [slub shrink] 0f6934bf16: +191.9% vmstat.system.cs
Message-ID: <20140117130051.GA2072@localhost>
References: <20140116030744.GA19349@localhost>
 <52D82F13.9070309@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D82F13.9070309@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

I retested the will-it-scale/read2 case with perf profile enabled, and
here are the new comparison results. It shows that there are increased
overheads in shmem_getpage_gfp(). If you'd like to collect more data,
feel free to tell me.

9a0bb2966efbf30  0f6934bf1695682e7ced973f6  
---------------  -------------------------  
     26460 ~95%    +136.3%      62514 ~ 1%   numa-vmstat.node2.numa_other
     62927 ~ 0%     -85.9%       8885 ~ 2%   numa-vmstat.node1.numa_other
   8363465 ~ 4%     +81.9%   15210930 ~ 2%   interrupts.RES
      3.96 ~ 6%     +42.8%       5.66 ~ 4%   perf-profile.cpu-cycles.find_lock_page.shmem_getpage_gfp.shmem_file_aio_read.do_sync_read.vfs_read
    209881 ~11%     +35.2%     283704 ~ 9%   numa-vmstat.node1.numa_local
   1795727 ~ 7%     +52.1%    2730750 ~17%   interrupts.LOC
         7 ~ 0%     -33.3%          4 ~10%   vmstat.procs.b
     18461 ~12%     -21.1%      14569 ~ 2%   numa-meminfo.node1.SUnreclaim
      4614 ~12%     -21.1%       3641 ~ 2%   numa-vmstat.node1.nr_slab_unreclaimable
       491 ~ 2%     -25.9%        363 ~ 6%   proc-vmstat.nr_tlb_remote_flush
     14595 ~ 8%     -17.1%      12093 ~16%   numa-meminfo.node2.AnonPages
      3648 ~ 8%     -17.1%       3025 ~16%   numa-vmstat.node2.nr_anon_pages
       277 ~12%     -14.4%        237 ~ 8%   numa-vmstat.node2.nr_page_table_pages
    202594 ~ 8%     -20.5%     161033 ~12%   softirqs.SCHED
      1104 ~11%     -14.0%        950 ~ 8%   numa-meminfo.node2.PageTables
      5201 ~ 7%     +21.0%       6292 ~ 3%   numa-vmstat.node0.nr_slab_unreclaimable
     20807 ~ 7%     +21.0%      25171 ~ 3%   numa-meminfo.node0.SUnreclaim
       975 ~ 8%     +16.7%       1138 ~ 5%   numa-meminfo.node1.PageTables
       245 ~ 7%     +16.5%        285 ~ 5%   numa-vmstat.node1.nr_page_table_pages
    109964 ~ 4%     -16.7%      91589 ~ 1%   numa-numastat.node0.local_node
     20433 ~ 4%     -16.3%      17104 ~ 2%   proc-vmstat.pgalloc_dma32
    112051 ~ 4%     -16.4%      93676 ~ 1%   numa-numastat.node0.numa_hit
    273320 ~ 8%     -14.4%     234064 ~ 3%   numa-vmstat.node2.numa_local
     31480 ~ 4%     +13.9%      35852 ~ 5%   numa-meminfo.node0.Slab
    917358 ~ 2%     +12.5%    1031687 ~ 2%   softirqs.TIMER
       513 ~ 0%     +37.7%        706 ~33%   numa-meminfo.node2.Mlocked
   8404395 ~13%    +256.9%   29992039 ~ 9%   time.voluntary_context_switches
    157154 ~17%    +201.7%     474102 ~ 8%   vmstat.system.cs
     36948 ~ 3%     +67.7%      61963 ~ 2%   vmstat.system.in
      2274 ~ 0%     +13.7%       2584 ~ 1%   time.system_time
       769 ~ 0%     +13.5%        873 ~ 1%   time.percent_of_cpu_this_job_got
      4359 ~ 2%     +13.6%       4951 ~ 3%   time.involuntary_context_switches
       104 ~ 3%     +10.2%        115 ~ 2%   time.user_time

Thanks,
Fengguang
