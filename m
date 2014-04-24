Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbaDXV0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:26:18 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44956 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbaDXV0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:26:13 -0400
Date: Thu, 24 Apr 2014 15:26:10 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Rajat Jain <rajatxjain@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Subject: Re: [PATCH v2] pci: Allow hotplug service drivers to operate in
 polling mode
Message-ID: <20140424212610.GH29593@google.com>
References: <5339FF7B.4020904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5339FF7B.4020904@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 04:51:23PM -0700, Rajat Jain wrote:
> Today the PCIe port bus driver disables the Hot-plug service if the
> port device does not have the capability to generate interrupts.
> However, a user must be able to use the "pciehp_poll_mode" parameter
> to use the pciehp in polling method in such a case. Today it is not
> possible.
> 
> This patch allows a hotplug service driver to decide whether or not
> it would like to continue in absense of interrupts.
> 
> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
> Signed-off-by: Guenter Roeck <groeck@juniper.net>

Applied to pci/hotplug for v3.16, thanks!

> ---
> v2: Drop the extra debug msg in pciehp
>     (and just retain the changes in portdrv_core.c)
> 
>  drivers/pci/pcie/portdrv_core.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
> index 0b6e766..ba31deb 100644
> --- a/drivers/pci/pcie/portdrv_core.c
> +++ b/drivers/pci/pcie/portdrv_core.c
> @@ -377,10 +377,13 @@ int pcie_port_device_register(struct pci_dev *dev)
>  	/*
>  	 * Initialize service irqs. Don't use service devices that
>  	 * require interrupts if there is no way to generate them.
> +	 * However, some drivers may have a polling mode (e.g pciehp_poll_mode)
> +	 * that can be used in absense of irqs. Allow them to determine
> +	 * if that is to be used.
>  	 */
>  	status = init_service_irqs(dev, irqs, capabilities);
>  	if (status) {
> -		capabilities &= PCIE_PORT_SERVICE_VC;
> +		capabilities &= PCIE_PORT_SERVICE_VC | PCIE_PORT_SERVICE_HP;
>  		if (!capabilities)
>  			goto error_disable;
>  	}
> -- 
> 1.7.9.5
> 
