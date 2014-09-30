Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988AbaI3ETb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:19:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbaI3ETa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:19:30 -0400
Message-ID: <542A2F4B.5060405@redhat.com>
Date: Mon, 29 Sep 2014 23:19:23 -0500
From: Wei Huang <wei@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH 1/1] perf/x86: Use KERN_INFO when checking PMU fails on
 virtual environment
References: <1411617314-24659-1-git-send-email-wei@redhat.com>
In-Reply-To: <1411617314-24659-1-git-send-email-wei@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, tglx and hpa,

Any comment on this patch? Thanks.

-Wei

On 09/24/2014 10:55 PM, Wei Huang wrote:
> PMU checking can fail due to various reasons. On native machine,
> this is mostly caused by faulty hardware and it is reasonable to
> use KERN_ERR in reporting. However, when kernel is running on
> virtualized environment, this checking can fail if virtual PMU is
> not supported (e.g. KVM on AMD host). It is annoying to see
> an error message on splash screen, even though we know such failure
> is benign on virtualized environment.
>
> This patch checks if kernel is running in virtualized environment.
> If so, it will use KERN_INFO in reporting. This patch was tested
> successfully on KVM.
>
> Signed-off-by: Wei Huang <wei@redhat.com>
> ---
>   arch/x86/kernel/cpu/perf_event.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 918d75f..16c7302 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -243,7 +243,8 @@ static bool check_hw_exists(void)
>
>   msr_fail:
>   	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
> -	printk(KERN_ERR "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
> +	printk(boot_cpu_has(X86_FEATURE_HYPERVISOR) ? KERN_INFO : KERN_ERR
> +	       "Failed to access perfctr msr (MSR %x is %Lx)\n", reg, val_new);
>
>   	return false;
>   }
>
