Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaIHJmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:42:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36090 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbaIHJjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:39:40 -0400
Message-ID: <540D793E.9050301@ti.com>
Date: Mon, 8 Sep 2014 15:09:10 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, <maxime.coquelin@st.com>,
        <patrice.chotard@st.com>
CC: <lee.jones@linaro.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] phy: phy-stih41x-usb: Add usb phy support for
 STiH41x SoCs.
References: <1410168638-11072-1-git-send-email-peter.griffin@linaro.org> <1410168638-11072-2-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1410168638-11072-2-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 08 September 2014 03:00 PM, Peter Griffin wrote:
> This driver adds support for USB (1.1 and 2.0) phy for STiH415 and
> STiH416 System-On-Chips from STMicroelectronics.
> 
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/phy/Kconfig           |   8 ++
>  drivers/phy/Makefile          |   1 +
>  drivers/phy/phy-stih41x-usb.c | 192 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 201 insertions(+)
>  create mode 100644 drivers/phy/phy-stih41x-usb.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 0dd7427..26f8a86 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -230,4 +230,12 @@ config PHY_XGENE
>  	help
>  	  This option enables support for APM X-Gene SoC multi-purpose PHY.
>  
> +config PHY_STIH41X_USB
> +	tristate "STMicroelectronics USB2 PHY driver for STiH41x series"
> +	depends on ARCH_STI
> +	select GENERIC_PHY
> +	help
> +	  Enable this to support the USB transceiver that is part of
> +	  STMicroelectronics STiH41x SoC series.
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 95c69ed..d02f365 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -28,3 +28,4 @@ obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)	+= phy-qcom-ipq806x-sata.o
>  obj-$(CONFIG_PHY_ST_SPEAR1310_MIPHY)	+= phy-spear1310-miphy.o
>  obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+= phy-spear1340-miphy.o
>  obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
> +obj-$(CONFIG_PHY_STIH41X_USB)		+= phy-stih41x-usb.o
> diff --git a/drivers/phy/phy-stih41x-usb.c b/drivers/phy/phy-stih41x-usb.c
> new file mode 100644
> index 0000000..7d0a5d4
> --- /dev/null
> +++ b/drivers/phy/phy-stih41x-usb.c
> @@ -0,0 +1,192 @@

.
.
<skip>
.
.

> +
> +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> +	if (IS_ERR(phy_provider))
> +		return PTR_ERR(phy_provider);
> +
> +	phy = devm_phy_create(dev, NULL, &stih41x_usb_phy_ops, NULL);
> +
> +	if (IS_ERR(phy)) {
> +		dev_err(dev, "failed to create Display Port PHY\n");
> +		return PTR_ERR(phy);
> +	}
> +
> +	phy_dev->dev = dev;
> +
> +	phy_set_drvdata(phy, phy_dev);
> +
> +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> +	if (IS_ERR(phy_provider))
> +		return PTR_ERR(phy_provider);

registering phy provider multiple times..

Thanks
Kishon
