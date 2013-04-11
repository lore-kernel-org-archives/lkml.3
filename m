Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab3DKRG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:06:57 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:53956 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3DKRG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:06:56 -0400
X-AuditID: cbfec7f5-b7fd76d000007247-c9-5166edae4459
Message-id: <5166EDAD.4060808@samsung.com>
Date: Thu, 11 Apr 2013 19:06:53 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>
Subject: Re: [PATCH 2/2] mfd: wm8994: Add some OF properties
References: <1365698223-4684-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1365698223-4684-2-git-send-email-broonie@opensource.wolfsonmicro.com>
In-reply-to: <1365698223-4684-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t/xy7rr3qYFGpy8K2zxb/YpNosDsx+y
	WvQuuMpmcXnXHDaL092sFhdXfGFyYPOYdzLQ4/yMhYweLyf+ZvPo27KK0ePzJrkA1igum5TU
	nMyy1CJ9uwSujDOTbzAWzBaq2PPvDVsD41G+LkYODgkBE4mjfzS7GDmBTDGJC/fWs3UxcnEI
	CSxllNj//hgzhPOJUeLcxvNsIFW8AloSJ/rWgNksAqoSM04uBLPZBAwleo/2MYLYogIBEouX
	nGOHqBeU+DH5HgvIMhGgZb/vV4LMZBbYzijxfucWJpAaYQEbia03zkAtm8socXvaBhaQBKdA
	qMTVE9PAFjAL6Ejsb4Wx5SU2r3nLPIFRYBaSHbOQlM1CUraAkXkVo2hqaXJBcVJ6rpFecWJu
	cWleul5yfu4mRkhgf93BuPSY1SFGAQ5GJR7ekw2pgUKsiWXFlbmHGCU4mJVEeGP2pgUK8aYk
	VlalFuXHF5XmpBYfYmTi4JRqYHThEGl0dXqfNv1Hn/3W33cmbY5b39T4XO+KurWz37S7OQeF
	8ysSXynd0nw+Z+OLqT/WtjPMf9/48Ur0SauJLxj/Z729uXhCjcnVsh+++51f+uwuXe+eaT8n
	t7RrouDXmnfMslO/OVXIb73/qfma1Typi0/EGvbESK0ty+NMux/dwPziYoiixx0lluKMREMt
	5qLiRABxQKvHSgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 06:37 PM, Mark Brown wrote:
> Add properties for some of the more important bits of platform data and
> fill out the binding document.
> 
> Not all of the current platform data is suitable for the sort of fixed
> configuration that is done using DT, some of it should have runtime
> mechanisms added instead and some is unlikely to ever be used in practical
> systems.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Couple cosmetics remarks below, just in case you happen to resend the patch
for some other reason.

> ---
>  Documentation/devicetree/bindings/sound/wm8994.txt |   58 ++++++++++++++-
>  drivers/mfd/wm8994-core.c                          |   75 +++++++++++++++++++-
>  2 files changed, 130 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/sound/wm8994.txt b/Documentation/devicetree/bindings/sound/wm8994.txt
> index 7a7eb1e..bb731ab 100644
> --- a/Documentation/devicetree/bindings/sound/wm8994.txt
> +++ b/Documentation/devicetree/bindings/sound/wm8994.txt
> @@ -5,14 +5,70 @@ on the board).
>  
>  Required properties:
>  
> -  - compatible : "wlf,wm1811", "wlf,wm8994", "wlf,wm8958"
> +  - compatible : One of "wlf,wm1811", "wlf,wm8994" or "wlf,wm8958"

Missing dot.

> +Optional properties:

> +
> +  - wlf,ldoena-always-driven : If present LDOENA is always driven

Ditto.

>  Example:
>  
>  codec: wm8994@1a {
>  	compatible = "wlf,wm8994";
>  	reg = <0x1a>;
> +
> +	gpio-controller;
> +	#gpio-cells = <2>;
> +
> +        lineout1-se;
^^^^^^^^^^^^^

Could be tab instead of spaces.

> +#ifdef CONFIG_OF
> +static int wm8994_set_pdata_from_of(struct wm8994 *wm8994)
> +{
> +	struct device_node *np = wm8994->dev->of_node;
> +	struct wm8994_pdata *pdata = &wm8994->pdata;
> +	int i;
> +
> +	if (!np)
> +		return 0;
> +
> +	if (of_property_read_u32_array(np, "wlf,gpio-cfg", pdata->gpio_defaults,
> +				       ARRAY_SIZE(pdata->gpio_defaults)) >= 0) {
> +		for (i = 0; i < ARRAY_SIZE(pdata->gpio_defaults); i++) {
> +			if (wm8994->pdata.gpio_defaults[i] == 0)

Could be simplified to: if (pdata->gpio_defaults[i] == 0)

Thanks for the updated series.

