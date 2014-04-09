Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997AbaDILGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:06:35 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64927 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaDILGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:06:31 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-cf-534529b64224
Message-id: <534529B2.2020107@samsung.com>
Date: Wed, 09 Apr 2014 13:06:26 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org, kishon@ti.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, jg1.han@samsung.com,
        sylvester.nawrocki@gmail.com
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
 <1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xq7rbNF2DDf6v4LA4eL/eYv6Rc6wW
	bVcOsls0L17PZnF54SVWix+vL7BZ9C64ymZx4WkPm8Wmx9dYLRa2LWGxuLxrDpvFjPP7mCwW
	LWtltpj3eSeTA5/Hzll32T32z13D7rF5Sb1H35ZVjB7Hb2xn8vi8SS6ALYrLJiU1J7MstUjf
	LoErY9ZOqYLzchUd948wNzD+Ee9i5OSQEDCRuPLpMBOELSZx4d56ti5GLg4hgaWMEv0/Glkh
	nM+MEvdunGcGqeIV0JL4eug1K4jNIqAqsaD5GCOIzSagJvG54REbiM0PVLOm6ToLiC0qECFx
	r/EwK0SvoMSPyfdYQIaKCPxklHjX2AOWYBboY5Q4fcIWxBYWcJa4PGMJO4gtJNDOKNG3iRPE
	5hTwlJh1cCYTRL21xMpJ2xghbHmJzWveMk9gFJyFZMcsJGWzkJQtYGRexSiaWppcUJyUnmuo
	V5yYW1yal66XnJ+7iRESS192MC4+ZnWIUYCDUYmHV8HSJViINbGsuDL3EKMEB7OSCO9zNtdg
	Id6UxMqq1KL8+KLSnNTiQ4xMHJxSDYxGcRECS1kcVv1gSJMT5szevenH/Fnv6sQYFZd7W51W
	YPr65xSP1rIOFaap1YY1d5pLvS6Jms1dfWiX7l2BXR4f4xorr2484LLmyPPFxn2Lu6X//GP+
	ln9m2sxlbckTC5m6/q55K7i/pFY4WGVPtI3v60YhFaUvh3fPTneZv03sQ8GTVttbFflKLMUZ
	iYZazEXFiQBLLS5CgwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Please see my comments inline.

On 08.04.2014 16:36, Vivek Gautam wrote:
> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
> The new driver uses the generic PHY framework and will interact
> with DWC3 controller present on Exynos5 series of SoCs.
> Thereby, removing old phy-samsung-usb3 driver and related code
> used untill now which was based on usb/phy framework.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>   .../devicetree/bindings/phy/samsung-phy.txt        |   42 ++
>   drivers/phy/Kconfig                                |   11 +
>   drivers/phy/Makefile                               |    1 +
>   drivers/phy/phy-exynos5-usbdrd.c                   |  668 ++++++++++++++++++++
>   4 files changed, 722 insertions(+)
>   create mode 100644 drivers/phy/phy-exynos5-usbdrd.c

[snip]

> +	Additional clock required for Exynos5420:
> +	- usb30_sclk_100m: Additional special clock used for PHY operation
> +			   depicted as 'sclk_usbphy30' in CMU of Exynos5420.

Are you sure this isn't simply a gate for the ref clock, as it can be 
found on another SoC that is not upstream yet? I don't have 
documentation for Exynos 5420 so I can't tell, but I'd like to ask you 
to recheck this.

> +- samsung,syscon-phandle: phandle for syscon interface, which is used to
> +			  control pmu registers for power isolation.
> +- samsung,pmu-offset: phy power control register offset to pmu-system-controller
> +		      base.
> +- #phy-cells : from the generic PHY bindings, must be 1;
> +
> +For "samsung,exynos5250-usbdrd-phy" and "samsung,exynos5420-usbdrd-phy"
> +compatible PHYs, the second cell in the PHY specifier identifies the
> +PHY id, which is interpreted as follows:
> +  0 - UTMI+ type phy,
> +  1 - PIPE3 type phy,
> +
> +Example:
> +	usb3_phy: usbphy@12100000 {
> +		compatible = "samsung,exynos5250-usbdrd-phy";
> +		reg = <0x12100000 0x100>;
> +		clocks = <&clock 286>, <&clock 1>;
> +		clock-names = "phy", "usb3phy_refclk";

Binding description above doesn't mention "usb3phy_refclk" entry.

> +		samsung,syscon-phandle = <&pmu_syscon>;
> +		samsung,pmu-offset = <0x704>;
> +		#phy-cells = <1>;
> +	};

[snip]

> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
> new file mode 100644
> index 0000000..ff54a7c
> --- /dev/null
> +++ b/drivers/phy/phy-exynos5-usbdrd.c

[snip]

> +static int exynos5_usbdrd_phy_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *node = dev->of_node;
> +	struct exynos5_usbdrd_phy *phy_drd;
> +	struct phy_provider *phy_provider;
> +	struct resource *res;
> +	const struct of_device_id *match;
> +	const struct exynos5_usbdrd_phy_drvdata *drv_data;
> +	struct regmap *reg_pmu;
> +	u32 pmu_offset;
> +	int i;
> +
> +	/*
> +	 * Exynos systems are completely DT enabled,
> +	 * so lets not have any platform data support for this driver.
> +	 */
> +	if (!node) {
> +		dev_err(dev, "no device node found\n");

This error message is not very meaningful. I'd rather use something like 
"This driver can be only instantiated using Device Tree".

> +		return -ENODEV;
> +	}
> +
> +	match = of_match_node(exynos5_usbdrd_phy_of_match, pdev->dev.of_node);
> +	if (!match) {
> +		dev_err(dev, "of_match_node() failed\n");
> +		return -EINVAL;
> +	}
> +	drv_data = match->data;
> +
> +	phy_drd = devm_kzalloc(dev, sizeof(*phy_drd), GFP_KERNEL);
> +	if (!phy_drd)
> +		return -ENOMEM;
> +
> +	dev_set_drvdata(dev, phy_drd);
> +	phy_drd->dev = dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	phy_drd->reg_phy = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(phy_drd->reg_phy)) {
> +		dev_err(dev, "Failed to map register memory (phy)\n");

devm_ioremap_resource() already prints an error message.

Best regards,
Tomasz
