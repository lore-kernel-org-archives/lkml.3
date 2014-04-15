Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaDOAZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:25:34 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:45196 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaDOAZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:25:32 -0400
Date: Mon, 14 Apr 2014 18:25:29 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers/pci/pcie/portdrv_pci.c: coding style fixes
Message-ID: <20140415002529.GF16058@google.com>
References: <20140413094934.423504a748c16f48bdd7fd70@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413094934.423504a748c16f48bdd7fd70@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 09:49:34AM +0200, Fabian Frederick wrote:
> Move __initdata before equal sign
> printk(KERN_WARNING converted to pr_warn
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/pci/pcie/portdrv_pci.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> index 0d8fdc4..14eb431 100644
> --- a/drivers/pci/pcie/portdrv_pci.c
> +++ b/drivers/pci/pcie/portdrv_pci.c
> @@ -402,7 +402,7 @@ static int __init dmi_pcie_pme_disable_msi(const struct dmi_system_id *d)
>  	return 0;
>  }
>  
> -static struct dmi_system_id __initdata pcie_portdrv_dmi_table[] = {
> +static struct dmi_system_id pcie_portdrv_dmi_table[] __initdata = {
>  	/*
>  	 * Boxes that should not use MSI for PCIe PME signaling.
>  	 */
> @@ -429,7 +429,7 @@ static int __init pcie_portdrv_init(void)
>  
>  	retval = pcie_port_bus_register();
>  	if (retval) {
> -		printk(KERN_WARNING "PCIE: bus_register error: %d\n", retval);
> +		pr_warn("PCIE: bus_register error: %d\n", retval);

Hi Fabian,

Can you do similar printk conversions for everything in drivers/pci,
so we do it all at once?  I think there are a few left that could be
converted to dev_info() or similar, so watch for those, too.

Bjorn

>  		goto out;
>  	}
>  	retval = pci_register_driver(&pcie_portdriver);
> -- 
> 1.8.3.2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
