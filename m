Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaLPSIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:08:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:47326 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaLPSIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:08:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="429736263"
Date: Wed, 17 Dec 2014 01:33:16 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Jon Medhurst <tixy@linaro.org>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org
Subject: [tixy:tracking-armlt-gator 1/6]
 drivers/gator/gator_events_meminfo.c:371:26: sparse: incorrect type in
 initializer (different modifiers)
Message-ID: <201412170151.C4iMWfhE%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tree:   https://git.linaro.org/people/tixy/kernel tracking-armlt-gator
head:   9b552ac355654e1fdd504f4b84b57c971084d83e
commit: a7bdf015d9043286f35de13eb11f54f64f2af143 [1/6] gator: Version 5.20
reproduce:
  # apt-get install sparse
  git checkout a7bdf015d9043286f35de13eb11f54f64f2af143
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/gator/gator_events_meminfo.c:371:26: sparse: incorrect type in initializer (different modifiers)
   drivers/gator/gator_events_meminfo.c:371:26:    expected long long *buf
   drivers/gator/gator_events_meminfo.c:371:26:    got long long [noderef] *<noident>
--
>> drivers/gator/gator_events_net.c:48:1: sparse: symbol 'wq_get_stats' was not declared. Should it be static?
>> drivers/gator/gator_events_net.c:98:27: sparse: Using plain integer as NULL pointer
--
>> drivers/gator/gator_events_perf_pmu.c:140:60: sparse: Using plain integer as NULL pointer
>> drivers/gator/gator_events_perf_pmu.c:151:83: sparse: Using plain integer as NULL pointer
>> drivers/gator/gator_events_perf_pmu.c:151:95: sparse: Using plain integer as NULL pointer
>> drivers/gator/gator_events_perf_pmu.c:519:74: sparse: Using plain integer as NULL pointer
>> drivers/gator/gator_events_perf_pmu.c:519:92: sparse: Using plain integer as NULL pointer
>> drivers/gator/gator_events_perf_pmu.c:530:72: sparse: Using plain integer as NULL pointer
>> drivers/gator/gator_events_perf_pmu.c:530:90: sparse: Using plain integer as NULL pointer

Please review and possibly fold the followup patch.

vim +371 drivers/gator/gator_events_meminfo.c

   355	#endif
   356	#endif
   357	}
   358	
   359	#define get_mm_counter(mm, member) gator_get_mm_counter(mm, member)
   360	
   361	#endif
   362	
   363	static int gator_events_meminfo_read_proc(long long **buffer, struct task_struct *task)
   364	{
   365		struct mm_struct *mm;
   366		u64 share = 0;
   367		int i;
   368		long long value;
   369		int len = 0;
   370		int cpu = get_physical_cpu();
 > 371		long long *buf = per_cpu(proc_buffer, cpu);
   372	
   373		if (!proc_global_enabled)
   374			return 0;
   375	
   376		/* Collect the memory stats of the process instead of the thread */
   377		if (task->group_leader != NULL)
   378			task = task->group_leader;
   379	

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
