Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbaLHPOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:14:35 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:51005 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbaLHPOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:14:33 -0500
Message-ID: <5485C03D.1020309@ti.com>
Date: Mon, 8 Dec 2014 10:14:05 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: <kernel-janitors@vger.kernel.org>, <linux@rasmusvillemoes.dk>,
        <joe@perches.com>, Bjorn Helgaas <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/20] PCI: keystone: fix misspelling of current function
 in string
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr> <1417980062-25151-3-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1417980062-25151-3-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2014 02:20 PM, Julia Lawall wrote:
> Replace a misspelled function name by %s and then __func__.
>
> The function name contains pcie, not pci as in the string.
>
> This was done using Coccinelle, including the use of Levenshtein distance,
> as proposed by Rasmus Villemoes.
>
> Signed-off-by: Julia Lawall<Julia.Lawall@lip6.fr>
>
> ---
> The semantic patch is difficult to summarize, but is available in the cover
> letter of this patch series.
>
>   drivers/pci/host/pci-keystone.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
> index 78f79e3..e2f600e 100644
> --- a/drivers/pci/host/pci-keystone.c
> +++ b/drivers/pci/host/pci-keystone.c
> @@ -119,7 +119,7 @@ static void ks_pcie_msi_irq_handler(unsigned int irq, struct irq_desc *desc)
>   	struct pcie_port *pp =&ks_pcie->pp;
>   	struct irq_chip *chip = irq_desc_get_chip(desc);
>
> -	dev_dbg(pp->dev, "ks_pci_msi_irq_handler, irq %d\n", irq);
> +	dev_dbg(pp->dev, "%s, irq %d\n", __func__, irq);
>
>   	/*
>   	 * The chained irq handler installation would have replaced normal
>

Acked-By: Murali Karicheri <m-karicheri2@ti.com>

-- 
Murali Karicheri
Linux Kernel, Texas Instruments
