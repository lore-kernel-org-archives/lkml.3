Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbaBUPz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 10:55:59 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9612 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145AbaBUPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 10:55:58 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f796d000005a13-9f-5307770b9534
Content-transfer-encoding: 8BIT
Message-id: <53077707.9060409@samsung.com>
Date: Fri, 21 Feb 2014 16:55:51 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH] phy: restrict Samsung S5P/Exynos drivers to the respective
 architectures
References: <1392991526-20895-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-reply-to: <1392991526-20895-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xq7rc5ezBBl8WqVocvF9v0bx4PZvF
	5YWXWC1WTd3JYnHhaQ+bxdmmN+wWmx5fY7W4vGsOm8X6Ga9ZLG5PnMzowOWxf+4ado/NS+o9
	+v8aePRtWcXocfzGdiaPz5vkAtiiuGxSUnMyy1KL9O0SuDI6byxjLjjCXbHt0GL2BsalnF2M
	nBwSAiYS+5+sYYewxSQu3FvP1sXIxSEksJRRYuXOHSwgCV4BQYkfk+8B2RwczALyEkcuZYOE
	mQXUJSbNW8QMUf+JUeLpys2MEPVaEp8WXAKzWQRUJTbvPMYEYrMJGEr0Hu0Di4sKREi8OjsR
	bL6IgKfE7tZbYIuZBc4wSXzb18kMkhAWiJe49PMk2HVCAn4Smz9eBbM5BfwlVnc/Y5zAKDAL
	yX2zEO6bheS+BYzMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFC4uDLDsbFx6wOMQpwMCrx
	8DqksgcLsSaWFVfmHmKU4GBWEuFtjgYK8aYkVlalFuXHF5XmpBYfYmTi4JRqYMxofLrieNSd
	Fw/MVYPklurptKxjfBbeu+L4/oMHeJSUaldVZzzWsqlc2XnZKmyzdFzWmd+Pf3Jy2JpWvch6
	G1XVVh/XHnmI61N8nPjn2udFR1WOlZwLc5U4eHCJqNWew72p4Y4PbjlY/1MwSNKI5zJP9i67
	/p3p+YpF7bMTGAtmbl3zbHptihJLcUaioRZzUXEiAN1xPjRhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 21/02/14 15:05, Uwe Kleine-König wrote:
> Enabling these drivers on platforms not created by Samsung is useless
> unless you're doing compile tests. So don't offer the users to enable
> them without COMPILE_TEST for configs with S5P/Exynos disabled.

Thanks for the patch, I've already sent something similar to Kishon, but
I've messed up the mailing list address. A bit improved v2 I just posted
can be found here:

https://patchwork.kernel.org/patch/3698271/
https://patchwork.kernel.org/patch/3698251/

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/phy/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index c7a551c2d5f1..82a98f1a5ec2 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -18,6 +18,7 @@ config GENERIC_PHY
>  config PHY_EXYNOS_MIPI_VIDEO
>  	depends on HAS_IOMEM
>  	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
> +	depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
>  	help
>  	  Support for MIPI CSI-2 and MIPI DSI DPHY found on Samsung S5P
>  	  and EXYNOS SoCs.
> @@ -54,6 +55,7 @@ config TWL4030_USB
>  config PHY_EXYNOS_DP_VIDEO
>  	tristate "EXYNOS SoC series Display Port PHY driver"
>  	depends on OF
> +	depends on ARCH_EXYNOS || COMPILE_TEST
>  	select GENERIC_PHY
>  	help
>  	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
> 

Regards,
Sylwester
