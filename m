Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbaFQMld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 08:41:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65450 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbaFQMla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 08:41:30 -0400
X-AuditID: cbfee61a-b7fef6d00000200b-87-53a03777c16e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, linux-ide@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        sboyd@codeaurora.org
Subject: Re: [PATCH v3 1/2] phy: qcom: Add driver for QCOM IPQ806x SATA PHY
Date: Tue, 17 Jun 2014 14:39:14 +0200
Message-id: <25056551.7rd4nhvM6K@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1402948477-12347-1-git-send-email-galak@codeaurora.org>
References: <1402948477-12347-1-git-send-email-galak@codeaurora.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jAd1y8wXBBpObzCzmHznHatH/ZiGr
	xYWnPWwWmx5fY7WYuP8su8WxHY+YLC7vmsNm8eNMN4sDh8flvl4mj81L6j2O39jO5PF5k1wA
	SxSXTUpqTmZZapG+XQJXxqul0xgLbgtVLPhykbmBcQ5/FyMHh4SAiUR/q1IXIyeQKSZx4d56
	ti5GLg4hgUWMEh19zUwQTguTxKSlH9hAqtgErCQmtq9iBLFFBFQlls/dzAJSxCxwj1Fi7ZwW
	FpCEsIC3xMr+d6wgNgtQ0fYNvWA2r4CWxNSnnewgtqiAp8SO7SvBhnIKuEo8PNjBDGILCbhI
	/Ftymg2iXlDix+R7YDOZBeQl9u2fygph60jsb53GNoFRYBaSsllIymYhKVvAyLyKUTS1ILmg
	OCk911CvODG3uDQvXS85P3cTIzjIn0ntYFzZYHGIUYCDUYmH96Hs/GAh1sSy4srcQ4wSHMxK
	Irwl4guChXhTEiurUovy44tKc1KLDzFKc7AoifMeaLUOFBJITyxJzU5NLUgtgskycXBKNTCu
	PzvjXfHD79//Pf+2aW5FnOltwWlKUlmSfx4xpRyMWRZxY41Xbm7XUxEf7TclF9QZDiwruD2p
	VHnyj2jvPlkbgUa/WQrmHZ8lAjo+ZP7bv+C3JF9D24VVh2ctdDKNP9W43V215NekyfMNe89+
	kk64rLF+8uNlGoI1LyzPv13ydBbDioqyMvMsJZbijERDLeai4kQAAie+q24CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday, June 16, 2014 02:54:37 PM Kumar Gala wrote:
> 
> Add a PHY driver for uses with AHCI based SATA controller driver on the
> IPQ806x family of SoCs.
> 
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> ---
> v3:
> * Added Kconfig HAS_IOMEM dep
> * re-ordered probe function so phy_provider_register is last
>  
> v2:
> * dropped unused dev pointer in struct qcom_ipq806x_sata_phy
> * remove unnecessary reg initializaiton
> * Removed unneeded error message
> * Added remove function to disable the clock
> 
>  drivers/phy/Kconfig                 |   7 ++
>  drivers/phy/Makefile                |   1 +
>  drivers/phy/phy-qcom-ipq806x-sata.c | 211 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 219 insertions(+)
>  create mode 100644 drivers/phy/phy-qcom-ipq806x-sata.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 16a2f06..b7b6bce 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -178,4 +178,11 @@ config PHY_XGENE
>  	help
>  	  This option enables support for APM X-Gene SoC multi-purpose PHY.
>  
> +config PHY_QCOM_IPQ806X_SATA
> +	tristate "Qualcomm IPQ806x SATA SerDes/PHY driver"
> +	depends on ARCH_QCOM
> +	depends on HAS_IOMEM
> +	depends on OF
> +	select GENERIC_PHY
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index b4f1d57..d950317 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -20,3 +20,4 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
>  phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
>  obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
> +obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)	+= phy-qcom-ipq806x-sata.o
> diff --git a/drivers/phy/phy-qcom-ipq806x-sata.c b/drivers/phy/phy-qcom-ipq806x-sata.c
> new file mode 100644
> index 0000000..e931aee
> --- /dev/null
> +++ b/drivers/phy/phy-qcom-ipq806x-sata.c

[...]

> +static inline void qcom_ipq806x_sata_delay_us(unsigned int delay)
> +{
> +	/* sleep for max. 50us more to combine processor wakeups */
> +	usleep_range(delay, delay + 50);
> +}

This is used only once in the driver so there is no need to make it
into static inline helper.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

