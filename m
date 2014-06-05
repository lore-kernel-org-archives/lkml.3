Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaFEIPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 04:15:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:44243 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbaFEIPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 04:15:49 -0400
Date: Thu, 5 Jun 2014 10:15:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Michal Simek <monstr@monstr.eu>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, linux-pm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-pci@vger.kernel.org
Subject: Re: [RFC Patch 3/3] x86, irq: count legacy IRQs by legacy_pic->nr_legacy_irqs
 instead of NR_IRQS_LEGACY
In-Reply-To: <1401951877-23032-4-git-send-email-jiang.liu@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1406051014490.23174@nanos>
References: <1401951877-23032-1-git-send-email-jiang.liu@linux.intel.com> <1401951877-23032-4-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014, Jiang Liu wrote:

> Some platforms, such as Intel MID and mshypv, do not support legacy
> interrupt controllers. So count legacy IRQs by legacy_pic->nr_legacy_irqs
> instead of hard-coded NR_IRQS_LEGACY.

Nice patch set!
 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  arch/x86/include/asm/i8259.h   |    2 ++
>  arch/x86/kernel/acpi/boot.c    |   13 ++++++------
>  arch/x86/kernel/apic/io_apic.c |   43 +++++++++++++++++++++++-----------------
>  arch/x86/kernel/devicetree.c   |   12 +++++------
>  arch/x86/kernel/irqinit.c      |    6 +++---
>  arch/x86/pci/xen.c             |    6 +++---
>  6 files changed, 46 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
> index a20365953bf8..fdac75b8782a 100644
> --- a/arch/x86/include/asm/i8259.h
> +++ b/arch/x86/include/asm/i8259.h
> @@ -67,4 +67,6 @@ struct legacy_pic {
>  extern struct legacy_pic *legacy_pic;
>  extern struct legacy_pic null_legacy_pic;
>  
> +#define	nr_legacy_irqs()	(legacy_pic->nr_legacy_irqs)

That wants to be a static inline, please.

Thanks,

	tglx
