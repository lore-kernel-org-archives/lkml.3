Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaCCJ0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 04:26:39 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45017 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbaCCJ0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 04:26:34 -0500
Date: Mon, 3 Mar 2014 09:26:28 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the tip tree with the pci tree
Message-ID: <20140303092628.GX1692@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20140303170335.7a4dd42c6e4f4b9034144a25@canb.auug.org.au>
MIME-Version: 1.0
In-Reply-To: <20140303170335.7a4dd42c6e4f4b9034144a25@canb.auug.org.au>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 03 Mar 2014 09:26:29.0572 (UTC) FILETIME=[A8829840:01CF36C2]
X-MC-Unique: 114030309263200201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 06:03:35AM +0000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the tip tree got a conflict in
> drivers/pci/Makefile between commit 39656f29f665 ("PCI: Cleanup per-arch
> list of object files") from the pci tree and commit c5f9ee3d665a ("x86,
> platforms: Remove SGI Visual Workstation") from the tip tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks Stephen, that looks fine to me.

Best regards,
Liviu

> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/pci/Makefile
> index e2501ac6fe84,9d5ee4dcee7d..000000000000
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@@ -33,15 -33,20 +33,14 @@@ obj-$(CONFIG_PCI_IOV) += iov.
>   #
>   # Some architectures use the generic PCI setup functions
>   #
>  -obj-$(CONFIG_X86) += setup-bus.o
>  -obj-$(CONFIG_ALPHA) += setup-bus.o setup-irq.o
>  -obj-$(CONFIG_ARM) += setup-bus.o setup-irq.o
>  -obj-$(CONFIG_UNICORE32) += setup-bus.o setup-irq.o
>  -obj-$(CONFIG_PARISC) += setup-bus.o
>  -obj-$(CONFIG_SUPERH) += setup-bus.o setup-irq.o
>  -obj-$(CONFIG_PPC) += setup-bus.o
>  -obj-$(CONFIG_FRV) += setup-bus.o
>  -obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
>  -obj-$(CONFIG_MN10300) += setup-bus.o
>  -obj-$(CONFIG_MICROBLAZE) += setup-bus.o
>  -obj-$(CONFIG_TILE) += setup-bus.o setup-irq.o
>  -obj-$(CONFIG_SPARC_LEON) += setup-bus.o setup-irq.o
>  -obj-$(CONFIG_M68K) += setup-bus.o setup-irq.o
>  +obj-$(CONFIG_ALPHA) += setup-irq.o
>  +obj-$(CONFIG_ARM) += setup-irq.o
>  +obj-$(CONFIG_UNICORE32) += setup-irq.o
>  +obj-$(CONFIG_SUPERH) += setup-irq.o
>  +obj-$(CONFIG_MIPS) += setup-irq.o
> - obj-$(CONFIG_X86_VISWS) += setup-irq.o
>  +obj-$(CONFIG_TILE) += setup-irq.o
>  +obj-$(CONFIG_SPARC_LEON) += setup-irq.o
>  +obj-$(CONFIG_M68K) += setup-irq.o
>   
>   #
>   # ACPI Related PCI FW Functions



-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

