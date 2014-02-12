Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaBLBUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 20:20:13 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:46534 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaBLBUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 20:20:10 -0500
Date: Tue, 11 Feb 2014 18:20:06 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Liviu Dudau <liviu@dudau.co.uk>
Subject: Re: [PATCH] pci: Makefile: Cleanup per-arch list of object files
Message-ID: <20140212012006.GJ21057@google.com>
References: <1391449116-22276-1-git-send-email-Liviu.Dudau@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391449116-22276-1-git-send-email-Liviu.Dudau@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 05:38:36PM +0000, Liviu Dudau wrote:
> setup-bus.o is now included unconditionally as of commit
> 7dc30303342562685392c8c7aa5194e98fd27625. Remove it from
> the per-arch list of object files.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

Applied to pci/misc for v3.15, thanks!

Bjorn

> ---
>  drivers/pci/Makefile | 22 ++++++++--------------
>  1 file changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
> index 17d2b07..e2501ac 100644
> --- a/drivers/pci/Makefile
> +++ b/drivers/pci/Makefile
> @@ -33,21 +33,15 @@ obj-$(CONFIG_PCI_IOV) += iov.o
>  #
>  # Some architectures use the generic PCI setup functions
>  #
> -obj-$(CONFIG_X86) += setup-bus.o
> -obj-$(CONFIG_ALPHA) += setup-bus.o setup-irq.o
> -obj-$(CONFIG_ARM) += setup-bus.o setup-irq.o
> -obj-$(CONFIG_UNICORE32) += setup-bus.o setup-irq.o
> -obj-$(CONFIG_PARISC) += setup-bus.o
> -obj-$(CONFIG_SUPERH) += setup-bus.o setup-irq.o
> -obj-$(CONFIG_PPC) += setup-bus.o
> -obj-$(CONFIG_FRV) += setup-bus.o
> -obj-$(CONFIG_MIPS) += setup-bus.o setup-irq.o
> +obj-$(CONFIG_ALPHA) += setup-irq.o
> +obj-$(CONFIG_ARM) += setup-irq.o
> +obj-$(CONFIG_UNICORE32) += setup-irq.o
> +obj-$(CONFIG_SUPERH) += setup-irq.o
> +obj-$(CONFIG_MIPS) += setup-irq.o
>  obj-$(CONFIG_X86_VISWS) += setup-irq.o
> -obj-$(CONFIG_MN10300) += setup-bus.o
> -obj-$(CONFIG_MICROBLAZE) += setup-bus.o
> -obj-$(CONFIG_TILE) += setup-bus.o setup-irq.o
> -obj-$(CONFIG_SPARC_LEON) += setup-bus.o setup-irq.o
> -obj-$(CONFIG_M68K) += setup-bus.o setup-irq.o
> +obj-$(CONFIG_TILE) += setup-irq.o
> +obj-$(CONFIG_SPARC_LEON) += setup-irq.o
> +obj-$(CONFIG_M68K) += setup-irq.o
>  
>  #
>  # ACPI Related PCI FW Functions
> -- 
> 1.8.5.3
> 
