Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaILTDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:03:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35297 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaILTDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:03:46 -0400
Message-ID: <54134390.5030206@codeaurora.org>
Date: Fri, 12 Sep 2014 12:03:44 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>, Felipe Balbi <balbi@ti.com>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [PATCH v8 3/3] phy: Add Qualcomm DWC3 HS/SS PHY driver
References: <1410542986-24419-1-git-send-email-agross@codeaurora.org> <1410542986-24419-4-git-send-email-agross@codeaurora.org>
In-Reply-To: <1410542986-24419-4-git-send-email-agross@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yay nitpicks!

On 09/12/14 10:29, Andy Gross wrote:
> +
> +struct qcom_dwc3_usb_phy {
> +	void __iomem		*base;
> +	struct device		*dev;
> +	struct phy *phy;

Align with other members?

>
> +
> +static int wait_for_latch(void __iomem *addr)
> +{
> +	u32 retry = 10;

Why not just int?

> +
> +	while (true) {
> +		if (!readl(addr))
> +			break;
> +
> +		if (--retry == 0)
> +			return -ETIMEDOUT;
> +
> +		usleep_range(10, 20);
> +	}
> +
> +	return 0;
> +}
[...]
> +
> +static int qcom_dwc3_ss_phy_init(struct qcom_dwc3_usb_phy *phy_dwc3)
> +{
> +	u32 data = 0;
> +

Unnecessary initialization.

>
>
> +
> +static struct phy_ops qcom_dwc3_phy_ops = {

Can this be const?

> +	.init		= qcom_dwc3_phy_init,
> +	.exit		= qcom_dwc3_phy_exit,
> +	.power_on	= qcom_dwc3_phy_power_on,
> +	.power_off	= qcom_dwc3_phy_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
[...]
> +
> +static int qcom_dwc3_phy_probe(struct platform_device *pdev)
> +{
> +	struct qcom_dwc3_usb_phy	*phy_dwc3;
> +	struct phy_provider		*phy_provider;
> +	struct resource			*res;
> +	const struct of_device_id	*match;
> +
> +

Weird two newlines here.

> +	phy_dwc3 = devm_kzalloc(&pdev->dev, sizeof(*phy_dwc3), GFP_KERNEL);
> +	if (!phy_dwc3)
> +		return -ENOMEM;
> +
>

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

