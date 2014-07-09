Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaGIOUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 10:20:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58143 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaGIOUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 10:20:36 -0400
Message-ID: <53BD4FAF.8060502@ti.com>
Date: Wed, 9 Jul 2014 10:20:31 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC: <prabhakar.csengg@gmail.com>, Sekhar Nori <nsekhar@ti.com>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH 1/2] net: davinci_mdio: reuse for keystone2 arch
References: <1404911451-9921-1-git-send-email-grygorii.strashko@ti.com> <1404911451-9921-2-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1404911451-9921-2-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014 09:10 AM, Grygorii Strashko wrote:
> The similar MDIO HW blocks is used by keystone 2 SoCs as
> in Davinci SoCs:
> - one in Gigabit Ethernet (GbE) Switch Subsystem
>   See http://www.ti.com/lit/ug/sprugv9d/sprugv9d.pdf
> - one in 10 Gigabit Ethernet Subsystem
>   See http://www.ti.com/lit/ug/spruhj5/spruhj5.pdf
> 
> Hence, reuse Davinci MDIO driver for Keystone 2 and
> enable TI networking for Keystone 2 devices
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
Looks good to me.
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

>  .../devicetree/bindings/net/davinci-mdio.txt       |    8 ++++----
>  drivers/net/ethernet/ti/Kconfig                    |    4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/davinci-mdio.txt b/Documentation/devicetree/bindings/net/davinci-mdio.txt
> index 72efaaf..d2e68e7 100644
> --- a/Documentation/devicetree/bindings/net/davinci-mdio.txt
> +++ b/Documentation/devicetree/bindings/net/davinci-mdio.txt
> @@ -1,8 +1,8 @@
> -TI SoC Davinci MDIO Controller Device Tree Bindings
> +TI SoC Davinci/Keystone2 MDIO Controller Device Tree Bindings
>  ---------------------------------------------------
>  
>  Required properties:
> -- compatible		: Should be "ti,davinci_mdio"
> +- compatible		: Should be "ti,davinci_mdio" or "ti,keystone-mdio"
>  - reg			: physical base address and size of the davinci mdio
>  			  registers map
>  - bus_freq		: Mdio Bus frequency
> @@ -19,7 +19,7 @@ file.
>  Examples:
>  
>  	mdio: davinci_mdio@4A101000 {
> -		compatible = "ti,cpsw";
> +		compatible = "ti,davinci_mdio";
>  		reg = <0x4A101000 0x1000>;
>  		bus_freq = <1000000>;
>  	};
> @@ -27,7 +27,7 @@ Examples:
>  (or)
>  
>  	mdio: davinci_mdio@4A101000 {
> -		compatible = "ti,cpsw";
> +		compatible = "ti,davinci_mdio";
>  		ti,hwmods = "davinci_mdio";
>  		bus_freq = <1000000>;
>  	};
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index 53150c2..1769700 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -5,7 +5,7 @@
>  config NET_VENDOR_TI
>  	bool "Texas Instruments (TI) devices"
>  	default y
> -	depends on PCI || EISA || AR7 || (ARM && (ARCH_DAVINCI || ARCH_OMAP3 || SOC_AM33XX))
> +	depends on PCI || EISA || AR7 || (ARM && (ARCH_DAVINCI || ARCH_OMAP3 || SOC_AM33XX || ARCH_KEYSTONE))
>  	---help---
>  	  If you have a network (Ethernet) card belonging to this class, say Y
>  	  and read the Ethernet-HOWTO, available from
> @@ -32,7 +32,7 @@ config TI_DAVINCI_EMAC
>  
>  config TI_DAVINCI_MDIO
>  	tristate "TI DaVinci MDIO Support"
> -	depends on ARM && ( ARCH_DAVINCI || ARCH_OMAP3 || SOC_AM33XX )
> +	depends on ARM && ( ARCH_DAVINCI || ARCH_OMAP3 || SOC_AM33XX || ARCH_KEYSTONE )
>  	select PHYLIB
>  	---help---
>  	  This driver supports TI's DaVinci MDIO module.
> 

