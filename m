Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaDPHkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 03:40:33 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:63693 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaDPHkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 03:40:31 -0400
Date: Wed, 16 Apr 2014 09:40:27 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Wang, Biao" <biao.wang@intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Di" <di.zhang@intel.com>
Subject: Re: [PATCH] x86: apic: disarm apic timer in deadline mode when shut
 down clockevent
Message-ID: <20140416074027.GB5636@gmail.com>
References: <09CB0B4607EB8F4DB7E0BE3B06BFBD0501004D78@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09CB0B4607EB8F4DB7E0BE3B06BFBD0501004D78@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wang, Biao <biao.wang@intel.com> wrote:

> For tsc deadline mode, when we shut down clockevent we should disarm
> local-APIC timer like count-down mode.
> 
> Signed-off-by: wang, biao <biao.wang@intel.com>
> Signed-off-by: Zhang Di <di.zhang@intel.com>
> ---
>  arch/x86/kernel/apic/apic.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> index 7f26c9a..85889ba 100644
> --- a/arch/x86/kernel/apic/apic.c
> +++ b/arch/x86/kernel/apic/apic.c
> @@ -512,6 +512,10 @@ static void lapic_timer_setup(enum clock_event_mode mode,
>  		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
>  		apic_write(APIC_LVTT, v);
>  		apic_write(APIC_TMICT, 0);
> +
> +		/*disarm timer in deadline mode*/
> +		if (boot_cpu_has(X86_FEATURE_TSC_DEADLINE_TIMER))
> +			wrmsrl(MSR_IA32_TSC_DEADLINE, 0);
>  		break;

Please fix the changelog to conform to the standard changelog style:

 - first describe the symptoms of the bug - how does a user notice?

 - then describe how the code behaves today and how that is causing the bug

 - and then only describe how it's fixed.

The first item is the most important one - while developers 
(naturally) tend to concentrate on the least important point,
the last one.

Thanks,

        Ingo
