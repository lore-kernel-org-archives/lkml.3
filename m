Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaJVPh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:37:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56465 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbaJVPhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:37:22 -0400
Message-ID: <5447CF27.2040506@zytor.com>
Date: Wed, 22 Oct 2014 08:37:11 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>, tglx@linutronix.de,
        mingo@redhat.com, konrad.wilk@oracle.com, david.vrabel@citrix.com
CC: tianyu.lan@intel.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2] xen/smp: Use die_complete completion when taking CPU
 down
References: <1413478046-4987-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1413478046-4987-1-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 09:47 AM, Boris Ostrovsky wrote:
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index 8cd27e0..a78c509 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -149,7 +149,11 @@ static inline void arch_send_call_function_ipi_mask(const struct cpumask *mask)
>  	smp_ops.send_call_func_ipi(mask);
>  }
>  
> +#ifdef CONFIG_HOTPLUG_CPU
>  void cpu_disable_common(void);
> +void cpu_die_common(unsigned int cpu);
> +void play_dead_common(void);
> +#endif

We generally don't #ifdef prototypes unless they are inlines or macros
in the unconfiged case.

	-hpa

