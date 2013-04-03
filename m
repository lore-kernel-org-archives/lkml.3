Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761635Ab3DCC5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:57:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:64790 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760710Ab3DCC5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:57:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,397,1363158000"; 
   d="scan'208";a="311502115"
Message-ID: <515B9A7A.6030807@intel.com>
Date: Wed, 03 Apr 2013 10:56:58 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org,
        len.brown@intel.com, rafael.j.wysocki@intel.com, jkosina@suse.cz,
        clark.williams@gmail.com, tony.luck@intel.com, keescook@chromium.org,
        mgorman@suse.de, riel@redhat.com
Subject: Re: [patch v3 0/8] sched: use runnable avg in load balance
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com> <515A877B.3020908@linux.vnet.ibm.com> <515A9859.6000606@intel.com> <515B97FF.2040409@linux.vnet.ibm.com>
In-Reply-To: <515B97FF.2040409@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 10:46 AM, Michael Wang wrote:
> | 15 GB   |      16 | 45110 |   | 48091 |
> | 15 GB   |      24 | 41415 |   | 47415 |
> | 15 GB   |      32 | 35988 |   | 45749 |	+27.12%
> 
> Very nice improvement, I'd like to test it with the wake-affine throttle
> patch later, let's see what will happen ;-)
> 
> Any idea on why the last one caused the regression?

you can change the burst threshold: sysctl_sched_migration_cost, to see
what's happen with different value. create a similar knob and tune it.
+
+	if (cpu_rq(this_cpu)->avg_idle < sysctl_sched_migration_cost)
+		burst_this = 1;
+	if (cpu_rq(prev_cpu)->avg_idle < sysctl_sched_migration_cost)
+		burst_prev = 1;
+


BTW, what's the job thread behaviour of pgbench, guess it has lots of
wakeup. what's the work and sleep ratio of pgbench?
-- 
Thanks Alex
