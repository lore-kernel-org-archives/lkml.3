Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965708AbaGPTWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:22:47 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33472 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321AbaGPTWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:22:42 -0400
MIME-Version: 1.0
In-Reply-To: <1405512783-20307-2-git-send-email-grygorii.strashko@ti.com>
References: <1405512783-20307-1-git-send-email-grygorii.strashko@ti.com> <1405512783-20307-2-git-send-email-grygorii.strashko@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 16 Jul 2014 20:22:10 +0100
Message-ID: <CA+V-a8sJXtXSzhSc9+6oq_yhommNnnUp=Y903hfyVcjsfe6Jcw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] net: davinci_mdio: reuse for keystone2 arch
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        netdev <netdev@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Rob Herring <robh+dt@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>,
        Mugunthan V N <mugunthanvnm@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 1:13 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
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
> Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Reviewed-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Thanks,
--Prabhakar Lad

> ---
>  .../devicetree/bindings/net/davinci-mdio.txt       |    8 ++++----
>  drivers/net/ethernet/ti/Kconfig                    |    4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/net/davinci-mdio.txt b/Documentation/devicetree/bindings/net/davinci-mdio.txt
> index 72efaaf..0369e25 100644
> --- a/Documentation/devicetree/bindings/net/davinci-mdio.txt
> +++ b/Documentation/devicetree/bindings/net/davinci-mdio.txt
> @@ -1,8 +1,8 @@
> -TI SoC Davinci MDIO Controller Device Tree Bindings
> +TI SoC Davinci/Keystone2 MDIO Controller Device Tree Bindings
>  ---------------------------------------------------
>
>  Required properties:
> -- compatible           : Should be "ti,davinci_mdio"
> +- compatible           : Should be "ti,davinci_mdio" or "ti,keystone_mdio"
>  - reg                  : physical base address and size of the davinci mdio
>                           registers map
>  - bus_freq             : Mdio Bus frequency
> @@ -19,7 +19,7 @@ file.
>  Examples:
>
>         mdio: davinci_mdio@4A101000 {
> -               compatible = "ti,cpsw";
> +               compatible = "ti,davinci_mdio";
>                 reg = <0x4A101000 0x1000>;
>                 bus_freq = <1000000>;
>         };
> @@ -27,7 +27,7 @@ Examples:
>  (or)
>
>         mdio: davinci_mdio@4A101000 {
> -               compatible = "ti,cpsw";
> +               compatible = "ti,davinci_mdio";
>                 ti,hwmods = "davinci_mdio";
>                 bus_freq = <1000000>;
>         };
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index 53150c2..1769700 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -5,7 +5,7 @@
>  config NET_VENDOR_TI
>         bool "Texas Instruments (TI) devices"
>         default y
> -       depends on PCI || EISA || AR7 || (ARM && (ARCH_DAVINCI || ARCH_OMAP3 || SOC_AM33XX))
> +       depends on PCI || EISA || AR7 || (ARM && (ARCH_DAVINCI || ARCH_OMAP3 || SOC_AM33XX || ARCH_KEYSTONE))
>         ---help---
>           If you have a network (Ethernet) card belonging to this class, say Y
>           and read the Ethernet-HOWTO, available from
> @@ -32,7 +32,7 @@ config TI_DAVINCI_EMAC
>
>  config TI_DAVINCI_MDIO
>         tristate "TI DaVinci MDIO Support"
> -       depends on ARM && ( ARCH_DAVINCI || ARCH_OMAP3 || SOC_AM33XX )
> +       depends on ARM && ( ARCH_DAVINCI || ARCH_OMAP3 || SOC_AM33XX || ARCH_KEYSTONE )
>         select PHYLIB
>         ---help---
>           This driver supports TI's DaVinci MDIO module.
> --
> 1.7.9.5
>
