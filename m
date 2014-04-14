Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbaDNOhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:37:11 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:15077 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaDNOhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:37:07 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-bc-534bf28fca28
Message-id: <534BF28E.7040906@samsung.com>
Date: Mon, 14 Apr 2014 16:37:02 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org, kishon@ti.com,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        t.figa@samsung.com, k.debski@samsung.com, jg1.han@samsung.com
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
 <1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1396967803-28868-2-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsVy+t/xK7r9n7yDDc4fUbY4eL/eYv6Rc6wW
	bVcOsls0L17PZnF54SVWix+vL7BZ9C64ymZx4WkPm8Wmx9dYLRa2LWGxuLxrDpvFjPP7mCwW
	LWtltlg/4zWLA5/H/rlr2D02L6n36NuyitHj+I3tTB6fN8kFsEZx2aSk5mSWpRbp2yVwZWy6
	t5e14JNgRXf/IaYGxv18XYycHBICJhKXjk5nh7DFJC7cW8/WxcjFISSwlFFi9cf1jBDOJ0aJ
	ud/awKp4BbQkJs86zQxiswioSiw/vpARxGYTMJToPdoHZosKREjcazzMClEvKPFj8j0WEFtE
	QFti+9xJrCBDmQUuMUm82LcGbJCwgLPE5RlLwBYICbQzSvRt4gSxOQU8JWYdnMkEYjML6Ejs
	b53GBmHLS2xe85Z5AqPALCQ7ZiEpm4WkbAEj8ypG0dTS5ILipPRcI73ixNzi0rx0veT83E2M
	kFj5uoNx6TGrQ4wCHIxKPLwT3nkHC7EmlhVX5h5ilOBgVhLhdd0KFOJNSaysSi3Kjy8qzUkt
	PsTIxMEp1cB41se/qvUrK4/+ml/GtxLmyvlYRbyz6XmR+bohZaqeLqdgxrsu9lsX6ye++Zcn
	XMKz6PK5hc5CC31LLHb6xaimnFLYUFd51mYL99pGayUliQs3+1e6z1opypudfetV2ZPWGXNV
	Ej5nc3IdbQxica7+EnI+9UK7puC7q8+tZy+MvHnzk2Nup5oSS3FGoqEWc1FxIgCgveoTcwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/14 16:36, Vivek Gautam wrote:
> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> index 28f9edb..6d99ba9 100644
> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> @@ -74,3 +74,45 @@ phy-consumer@12340000 {
>  
>  Refer to DT bindings documentation of particular PHY consumer devices for more
>  information about required PHYs and the way of specification.
> +
> +Samsung Exynos5 SoC series USB DRD PHY controller
> +--------------------------------------------------
> +
> +Required properties:
> +- compatible : Should be set to one of the following supported values:
> +	- "samsung,exynos5250-usbdrd-phy" - for exynos5250 SoC,
> +	- "samsung,exynos5420-usbdrd-phy" - for exynos5420 SoC.
> +- reg : Register offset and length of USB DRD PHY register set;
> +- clocks: Clock IDs array as required by the controller
> +- clock-names: names of clocks correseponding to IDs in the clock property;
> +	       Required clocks:
> +	- phy: main PHY clock (same as USB DRD controller i.e. DWC3 IP clock),
> +	       used for register access.
> +	- ref: PHY's reference clock (usually crystal clock), associated by
> +	       phy name, used to determine bit values for clock settings
> +	       register.
> +	Additional clock required for Exynos5420:
> +	- usb30_sclk_100m: Additional special clock used for PHY operation
> +			   depicted as 'sclk_usbphy30' in CMU of Exynos5420.
> +- samsung,syscon-phandle: phandle for syscon interface, which is used to
> +			  control pmu registers for power isolation.

Why to append "-phandle" to the property's name ? If this is for PMU
perhaps make it more explicit and name it: samsung,pmu-syscon or
samsung,pmureg ?

> +- samsung,pmu-offset: phy power control register offset to pmu-system-controller
> +		      base.
> +- #phy-cells : from the generic PHY bindings, must be 1;
> +
> +For "samsung,exynos5250-usbdrd-phy" and "samsung,exynos5420-usbdrd-phy"
> +compatible PHYs, the second cell in the PHY specifier identifies the
> +PHY id, which is interpreted as follows:
> +  0 - UTMI+ type phy,
> +  1 - PIPE3 type phy,

-- 
Thanks,
Sylwester
