Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab3HSB0j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 21:26:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:56535 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155Ab3HSB0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 21:26:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,909,1367996400"; 
   d="scan'208";a="364617443"
Message-ID: <5211744C.7030801@intel.com>
Date: Mon, 19 Aug 2013 09:26:36 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, eranian@google.com,
        ak@linux.intel.com
Subject: Re: [PATCH 1/2] perf, x86: use INTEL_UEVENT_EXTRA_REG to define MSR_OFFCORE_RSP_X
References: <1374138144-17278-1-git-send-email-zheng.z.yan@intel.com>
In-Reply-To: <1374138144-17278-1-git-send-email-zheng.z.yan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping

On 07/18/2013 05:02 PM, Yan, Zheng wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> Silvermont (22nm Atom) has two offcore response configuration MSRs,
> unlike other Intel CPU, its event code for MSR_OFFCORE_RSP_1 is 0x02b7.
> To avoid complicating intel_fixup_er(), use INTEL_UEVENT_EXTRA_REG to
> define MSR_OFFCORE_RSP_X. So intel_fixup_er() can find the event code
> for OFFCORE_RSP_N by x86_pmu.extra_regs[N].event.
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index fbc9210..d312edf 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -81,7 +81,8 @@ static struct event_constraint intel_nehalem_event_constraints[] __read_mostly =
>  
>  static struct extra_reg intel_nehalem_extra_regs[] __read_mostly =
>  {
> -	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
> +	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
> +	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
>  	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x100b),
>  	EVENT_EXTRA_END
>  };
> @@ -143,8 +144,9 @@ static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
>  
>  static struct extra_reg intel_westmere_extra_regs[] __read_mostly =
>  {
> -	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
> -	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0xffff, RSP_1),
> +	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
> +	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0xffff, RSP_0),
> +	INTEL_UEVENT_EXTRA_REG(0x01bb, MSR_OFFCORE_RSP_1, 0xffff, RSP_1),
>  	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x100b),
>  	EVENT_EXTRA_END
>  };
> @@ -163,15 +165,17 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
>  };
>  
>  static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
> -	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
> -	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
> +	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
> +	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
> +	INTEL_UEVENT_EXTRA_REG(0x01bb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
>  	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
>  	EVENT_EXTRA_END
>  };
>  
>  static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
> -	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
> -	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
> +	/* must define OFFCORE_RSP_X first, see intel_fixup_er() */
> +	INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
> +	INTEL_UEVENT_EXTRA_REG(0x01bb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
>  	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
>  	EVENT_EXTRA_END
>  };
> @@ -1301,11 +1305,11 @@ static void intel_fixup_er(struct perf_event *event, int idx)
>  
>  	if (idx == EXTRA_REG_RSP_0) {
>  		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
> -		event->hw.config |= 0x01b7;
> +		event->hw.config |= x86_pmu.extra_regs[EXTRA_REG_RSP_0].event;
>  		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_0;
>  	} else if (idx == EXTRA_REG_RSP_1) {
>  		event->hw.config &= ~INTEL_ARCH_EVENT_MASK;
> -		event->hw.config |= 0x01bb;
> +		event->hw.config |= x86_pmu.extra_regs[EXTRA_REG_RSP_1].event;
>  		event->hw.extra_reg.reg = MSR_OFFCORE_RSP_1;
>  	}
>  }
> 

