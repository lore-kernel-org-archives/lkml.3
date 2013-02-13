Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965251Ab3BMW4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 17:56:23 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:37250 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760432Ab3BMW4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 17:56:21 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/4] of/pci: Add of_pci_get_bus() function
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1360570940-17086-4-git-send-email-thierry.reding@avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de> <1360570940-17086-4-git-send-email-thierry.reding@avionic-design.de>
Date: Wed, 13 Feb 2013 22:56:07 +0000
Message-Id: <20130213225607.B31223E3557@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2013 09:22:19 +0100, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> This function can be used to parse the number of a device's parent PCI
> bus from a standard 5-cell PCI resource.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

This patch should be deferred until there is another patch in the same
series that actually uses it.

g.

> ---
>  drivers/of/of_pci.c    | 21 +++++++++++++++++++++
>  include/linux/of_pci.h |  1 +
>  2 files changed, 22 insertions(+)
> 
> diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> index 4dd7b9b..d6e6de5 100644
> --- a/drivers/of/of_pci.c
> +++ b/drivers/of/of_pci.c
> @@ -43,6 +43,27 @@ struct device_node *of_pci_find_child_device(struct device_node *parent,
>  EXPORT_SYMBOL_GPL(of_pci_find_child_device);
>  
>  /**
> + * of_pci_get_bus() - Get bus number for a device node
> + * @np: device node
> + *
> + * Parses a standard 5-cell PCI resource and returns the 8-bit bus number of
> + * the device's parent PCI bus. On error a negative error code is returned.
> + */
> +int of_pci_get_bus(struct device_node *np)
> +{
> +	unsigned int size;
> +	const __be32 *reg;
> +
> +	reg = of_get_property(np, "reg", &size);
> +
> +	if (!reg || size < 5 * sizeof(__be32))
> +		return -EINVAL;
> +
> +	return (be32_to_cpup(reg) >> 16) & 0xff;
> +}
> +EXPORT_SYMBOL_GPL(of_pci_get_bus);
> +
> +/**
>   * of_pci_get_devfn() - Get device and function numbers for a device node
>   * @np: device node
>   *
> diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
> index 91ec484..9118321 100644
> --- a/include/linux/of_pci.h
> +++ b/include/linux/of_pci.h
> @@ -10,6 +10,7 @@ int of_irq_map_pci(const struct pci_dev *pdev, struct of_irq *out_irq);
>  struct device_node;
>  struct device_node *of_pci_find_child_device(struct device_node *parent,
>  					     unsigned int devfn);
> +int of_pci_get_bus(struct device_node *np);
>  int of_pci_get_devfn(struct device_node *np);
>  
>  #endif
> -- 
> 1.8.1.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
