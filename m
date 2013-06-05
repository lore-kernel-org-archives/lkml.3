Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3FEIIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 04:08:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233Ab3FEIIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 04:08:22 -0400
Date: Wed, 5 Jun 2013 10:08:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule,
 round 2
In-Reply-To: <51AEA2A8.90605@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1306051007540.6750@pobox.suse.cz>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz> <20130509125040.GF27333@pd.tnic> <20130509125859.GG27333@pd.tnic> <20130515184528.GO4442@linux.vnet.ibm.com> <20130515224358.GF11783@pd.tnic> <20130515235512.GT4442@linux.vnet.ibm.com>
 <20130517135641.GF23035@pd.tnic> <alpine.LNX.2.00.1306042319360.6750@pobox.suse.cz> <51AEA2A8.90605@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Jun 2013, Michael Wang wrote:

> > Just to not let this thread sleep -- I am seeing this as well, even with 
> > current Linus' tree (git HEAD == aa4f608).
> 
> Have you tried this:
> 
> diff --git a/drivers/cpufreq/cpufreq_governor.c
> b/drivers/cpufreq/cpufreq_governor.c
> index 443442d..449be88 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -26,6 +26,7 @@
>  #include <linux/tick.h>
>  #include <linux/types.h>
>  #include <linux/workqueue.h>
> +#include <linux/cpu.h>
> 
>  #include "cpufreq_governor.h"
> 
> @@ -180,8 +181,10 @@ void gov_queue_work(struct dbs_data *dbs_data,
> struct cpufreq_policy *policy,
>         if (!all_cpus) {
>                 __gov_queue_work(smp_processor_id(), dbs_data, delay);
>         } else {
> +               get_online_cpus();
>                 for_each_cpu(i, policy->cpus)
>                         __gov_queue_work(i, dbs_data, delay);
> +               put_online_cpus();
>         }
>  }
>  EXPORT_SYMBOL_GPL(gov_queue_work);
> 
> Does it works?

Yes, the warning is gone with this patch.

	Tested-by: Jiri Kosina <jkosina@suse.cz>

Thanks,

-- 
Jiri Kosina
SUSE Labs
