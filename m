Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965306Ab3E2JIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 05:08:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:55153 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab3E2JIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 05:08:16 -0400
Date: Wed, 29 May 2013 11:08:05 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.a.cohen@intel.com
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:irq/core] irq/x86/io_apic: Fix number of pre-allocated
 irqs
In-Reply-To: <tip-8c956b1b935ec98decb470a6abff8c1f8b28e9f0@git.kernel.org>
Message-ID: <alpine.LFD.2.02.1305291104550.2995@ionos>
References: <1367364015-12521-1-git-send-email-david.a.cohen@intel.com> <tip-8c956b1b935ec98decb470a6abff8c1f8b28e9f0@git.kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 May 2013, tip-bot for David Cohen wrote:

> Commit-ID:  8c956b1b935ec98decb470a6abff8c1f8b28e9f0
> Gitweb:     http://git.kernel.org/tip/8c956b1b935ec98decb470a6abff8c1f8b28e9f0
> Author:     David Cohen <david.a.cohen@intel.com>
> AuthorDate: Tue, 30 Apr 2013 16:20:15 -0700
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 28 May 2013 12:01:29 +0200
> 
> irq/x86/io_apic: Fix number of pre-allocated irqs
> 
> arch_probe_nr_irqs() has a typo when returning number of
> preallocated irqs. Instead of returning the calculated value, it
> returns a constant number NR_IRQ_LEGACY.

That's not a typo. That's on purpose.

We don't want to allocate a gazillion of interrupt descriptors for
nothing. The only ones which must be pre-allocated are the legacy
ones.

> This patch makes sure the calculated value is returned intead.

And therefor defeats the whole purpose of sparse irqs.

I'll zap that commit.
 
> Signed-off-by: David Cohen <david.a.cohen@intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: joro@8bytes.org
> Link: http://lkml.kernel.org/r/1367364015-12521-1-git-send-email-david.a.cohen@intel.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/apic/io_apic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 9ed796c..7ef2bd9 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -3437,7 +3437,7 @@ int __init arch_probe_nr_irqs(void)
>  	if (nr < nr_irqs)
>  		nr_irqs = nr;
>  
> -	return NR_IRQS_LEGACY;
> +	return nr;
>  }
>  
>  int io_apic_set_pci_routing(struct device *dev, int irq,
> 
