Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaCHFcl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 00:32:41 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:62014 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaCHFa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 00:30:26 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v6 1/6] pci: Introduce pci_register_io_range() helper function.
To: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>, Tanmay Inamdar <tinamdar@apm.com>,
        LAKML <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1394020137-1830-2-git-send-email-Liviu.Dudau@arm.com>
References: <1394020137-1830-1-git-send-email-Liviu.Dudau@arm.com> < 1394020137-1830-2-git-send-email-Liviu.Dudau@arm.com>
Date: Fri, 07 Mar 2014 19:35:40 +0000
Message-Id: <20140307193540.72720C40DBA@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Mar 2014 11:48:52 +0000, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> Some architectures do not share x86 simple view of the I/O space and
> instead use a range of addresses that map to external devices. For PCI,
> these ranges can be expressed by OF bindings in a device tree file.
> 
> Introduce a pci_register_io_range() helper function that can be used
> by the architecture code to keep track of the io ranges described by the
> PCI bindings.
> 
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> Tested-by: Tanmay Inamdar <tinamdar@apm.com>

Acked-by: Grant Likely <grant.likely@linaro.org>

> ---
>  drivers/of/address.c       | 5 +++++
>  include/linux/of_address.h | 1 +
>  2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index 1a54f1f..d1bb30f 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -619,6 +619,11 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
>  }
>  EXPORT_SYMBOL(of_get_address);
>  
> +int __weak pci_register_io_range(phys_addr_t addr, resource_size_t size)
> +{
> +	return 0;
> +}
> +
>  unsigned long __weak pci_address_to_pio(phys_addr_t address)
>  {
>  	if (address > IO_SPACE_LIMIT)
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 5f6ed6b..40c418d 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -56,6 +56,7 @@ extern void __iomem *of_iomap(struct device_node *device, int index);
>  extern const __be32 *of_get_address(struct device_node *dev, int index,
>  			   u64 *size, unsigned int *flags);
>  
> +extern int pci_register_io_range(phys_addr_t addr, resource_size_t size);
>  extern unsigned long pci_address_to_pio(phys_addr_t addr);
>  
>  extern int of_pci_range_parser_init(struct of_pci_range_parser *parser,
> -- 
> 1.9.0
> 
> 
> _______________________________________________
> linaro-kernel mailing list
> linaro-kernel@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-kernel

