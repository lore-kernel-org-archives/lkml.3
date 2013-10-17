Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab3JQN5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:57:20 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59186 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab3JQN5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:57:18 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-a0-525fecbcef0f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Roger Quadros <rogerq@ti.com>
Cc: tj@kernel.org, sergei.shtylyov@cogentembedded.com, kishon@ti.com,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Balaji T K <balajitk@ti.com>
Subject: Re: [PATCH v2 1/2] ata: ahci_platform: Manage SATA PHY
Date: Thu, 17 Oct 2013 15:57:12 +0200
Message-id: <1896416.QtZRH9T0D7@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1381923773-10596-2-git-send-email-rogerq@ti.com>
References: <1381923773-10596-1-git-send-email-rogerq@ti.com>
 <1381923773-10596-2-git-send-email-rogerq@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQd09b+KDDBZPULKYOnk7m8WFpz1s
	Fsd2PGKyuLxrDptFzyMtizOrbrFb/Fp+lNGB3ePB1P9MHptWdbJ5HL+xncnj8ya5AJYoLpuU
	1JzMstQifbsErox7v14wFdxVqeh4toOpgfGJTBcjJ4eEgInEyU87GCFsMYkL99azdTFycQgJ
	TGeU2LHsHwuE08Ikcf3+XGaQKjYBK4mJ7avAOkQEFCXurYToYBaYzyixad0uFpCEsIC9xKPP
	M4ESHBwsAqoSpy7zgoR5BTQlbnavZAOxRQU8JXZsh7A5BewkGq7PYwKxhQQKJVpndLBC1AtK
	/Jh8D2wks4C8xL79U1khbB2J/a3T2CYwCsxCUjYLSdksJGULGJlXMYqmFiQXFCel5xrqFSfm
	Fpfmpesl5+duYgSH9jOpHYwrGywOMQpwMCrx8M5cHhckxJpYVlyZe4hRgoNZSYTX5X58kBBv
	SmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGhWaCdypL/JVs
	13F+zv8nqN17+dgMTudlJiW6Ip0sS7ewH/lySGPLPZ31EzZ9bU2tOrfWMr7wKKPM6fln5+9f
	nfs479Z07l/S7guPy0X+VYpWm+30f+Kc7Uo/tL2PJdf3OqrbdR40STj5jWupyNRjDxkfOdYu
	YThdV9N/NOFKtJKz8aWKBYw6SizFGYmGWsxFxYkAMHsi1GkCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday, October 16, 2013 02:42:52 PM Roger Quadros wrote:
> From: Balaji T K <balajitk@ti.com>
> 
> Some platforms have a PHY hooked up to the
> SATA controller. The PHY needs to be initialized
> and powered up for SATA to work. We do that
> using the PHY framework.
> 
> [Roger Q] Cleaned up.
> 
> CC: Tejun Heo <tj@kernel.org>
> Signed-off-by: Balaji T K <balajitk@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  .../devicetree/bindings/ata/ahci-platform.txt      |    3 +-
>  drivers/ata/ahci.h                                 |    2 ++
>  drivers/ata/ahci_platform.c                        |   29 +++++++++++++++++++-
>  3 files changed, 32 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> index 89de156..c8a6cea 100644
> --- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
> +++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> @@ -4,7 +4,8 @@ SATA nodes are defined to describe on-chip Serial ATA controllers.
>  Each SATA controller should have its own node.
>  
>  Required properties:
> -- compatible        : compatible list, contains "snps,spear-ahci"
> +- compatible        : compatible list, contains "snps,spear-ahci",
> +			snps,exynos5440-ahci or "snps,dwc-ahci"

minor nit:
s/snps,exynos5440-ahci/"snps,exynos5440-ahci"/

>  - interrupts        : <interrupt mapping for SATA IRQ>
>  - reg               : <registers mapping>
>  
> diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
> index 1145637..94484cb 100644
> --- a/drivers/ata/ahci.h
> +++ b/drivers/ata/ahci.h
> @@ -37,6 +37,7 @@
>  
>  #include <linux/clk.h>
>  #include <linux/libata.h>
> +#include <linux/phy/phy.h>
>  
>  /* Enclosure Management Control */
>  #define EM_CTRL_MSG_TYPE              0x000f0000
> @@ -322,6 +323,7 @@ struct ahci_host_priv {
>  	u32			em_buf_sz;	/* EM buffer size in byte */
>  	u32			em_msg_type;	/* EM message type */
>  	struct clk		*clk;		/* Only for platforms supporting clk */
> +	struct phy		*phy;		/* If platforms use phy */

minor nit:
s/If platforms use phy/If platform uses PHY/

>  	void			*plat_data;	/* Other platform data */
>  };
>  
> diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
> index 2daaee0..5a0f1418 100644
> --- a/drivers/ata/ahci_platform.c
> +++ b/drivers/ata/ahci_platform.c
> @@ -141,6 +141,21 @@ static int ahci_probe(struct platform_device *pdev)
>  		}
>  	}
>  
> +	hpriv->phy = devm_phy_get(dev, "sata-phy");
> +	if (IS_ERR(hpriv->phy)) {
> +		dev_dbg(dev, "can't get sata-phy\n");
> +		/* return only if -EPROBE_DEFER */
> +		if (PTR_ERR(hpriv->phy) == -EPROBE_DEFER) {
> +			rc = -EPROBE_DEFER;
> +			goto disable_unprepare_clk;
> +		}
> +	}
> +
> +	if (!IS_ERR(hpriv->phy)) {
> +		phy_init(hpriv->phy);
> +		phy_power_on(hpriv->phy);
> +	}
> +
>  	/*
>  	 * Some platforms might need to prepare for mmio region access,
>  	 * which could be done in the following init call. So, the mmio
> @@ -150,7 +165,7 @@ static int ahci_probe(struct platform_device *pdev)
>  	if (pdata && pdata->init) {
>  		rc = pdata->init(dev, hpriv->mmio);
>  		if (rc)
> -			goto disable_unprepare_clk;
> +			goto disable_phy;
>  	}
>  
>  	ahci_save_initial_config(dev, hpriv,
> @@ -220,6 +235,12 @@ static int ahci_probe(struct platform_device *pdev)
>  pdata_exit:
>  	if (pdata && pdata->exit)
>  		pdata->exit(dev);
> +disable_phy:
> +	if (!IS_ERR(hpriv->phy)) {
> +		phy_power_off(hpriv->phy);
> +		phy_exit(hpriv->phy);
> +	}
> +
>  disable_unprepare_clk:
>  	if (!IS_ERR(hpriv->clk))
>  		clk_disable_unprepare(hpriv->clk);
> @@ -238,6 +259,11 @@ static void ahci_host_stop(struct ata_host *host)
>  	if (pdata && pdata->exit)
>  		pdata->exit(dev);
>  
> +	if (!IS_ERR(hpriv->phy)) {
> +		phy_power_off(hpriv->phy);
> +		phy_exit(hpriv->phy);
> +	}
> +
>  	if (!IS_ERR(hpriv->clk)) {
>  		clk_disable_unprepare(hpriv->clk);
>  		clk_put(hpriv->clk);
> @@ -328,6 +354,7 @@ static SIMPLE_DEV_PM_OPS(ahci_pm_ops, ahci_suspend, ahci_resume);

Shouldn't phy_power_off/on also be used in ahci_suspend() and ahci_resume()?

>  static const struct of_device_id ahci_of_match[] = {
>  	{ .compatible = "snps,spear-ahci", },
>  	{ .compatible = "snps,exynos5440-ahci", },
> +	{ .compatible = "snps,dwc-ahci", },

This change together with ahci-platform.txt one should be in a separate patch.

>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, ahci_of_match);

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

