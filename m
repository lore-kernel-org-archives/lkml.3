Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3EaTP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:15:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54931 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3EaTPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:15:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: devicetree-discuss@lists.ozlabs.org
Cc: Jan Luebbe <jlu@pengutronix.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Rodolfo Giometti <giometti@enneenne.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] pps-gpio: add device-tree binding and support
Date: Fri, 31 May 2013 21:15:19 +0200
Message-ID: <1588516.WvWWFWzAui@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370026015-9584-1-git-send-email-jlu@pengutronix.de>
References: <1370026015-9584-1-git-send-email-jlu@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qbz21VfxO3eDl0eo9btwXK9Nyb2L2Dz24H1V5IC860S
 /SOr5xLCw1p03VytASPoO1zaalKwinpo++EvL1aOkdcoMEr7NK
 poangtMXZ4eXi/8meXiAaPrsq1cNdvxIcDLEnaBEGz8G0+Luko
 6BWg9pOt1LZJ+ngel7QOy9W1VI0F/82gCL0YoRSc2hxSUVv5OI
 gXojyqgxf63XOwKwbDB0gpH3U0h3SOeFxkppbYXmuDjTl62PHz
 C4cAVvPvyUJJlUdPtyftBT1hArwajLKVvu53UMwmw9BWFH6aCN
 NzViVCRad1//2w4cisvu01+DVxNas5BVl/xxNIyxlFOjNm0/tN
 Qkopns+v9NoKZeQHNVSU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 May 2013 20:46:55 Jan Luebbe wrote:
> 
> +#ifdef CONFIG_OF
> +static const struct of_device_id pps_gpio_dt_ids[] = {
> +       { .compatible = "pps-gpio", },
> +       { /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, pps_gpio_dt_ids);
> +
> +static struct pps_gpio_platform_data *
> +of_get_pps_gpio_pdata(struct platform_device *pdev)
> +{
> +       struct device_node *np = pdev->dev.of_node;
> +       struct pps_gpio_platform_data *pdata;
> +       int ret;
> +
> +       pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +       if (!pdata)
> +               return NULL;
> +
> +       ret = of_get_gpio(np, 0);
> +       if (ret < 0) {
> +               pr_err("failed to get GPIO from device tree\n");
> +               return NULL;
> +       }
> +
> +       pdata->gpio_pin = ret;
> +       pdata->gpio_label = PPS_GPIO_NAME;
> +
> +       if (of_get_property(np, "assert-falling-edge", NULL))
> +               pdata->assert_falling_edge = true;
> +
> +       return pdata;
> +}
> +#else
> +static struct pps_gpio_platform_data *
> +of_get_pps_gpio_pdata(struct platform_device *pdev)
> +{
> +       return NULL;
> +}
> +#endif

I don't think it's worth the effort of doing a dynamic
allocation if you just need to store two integers and a flag.
I would just put them all into pps_gpio_device_data, which also
gets rid of a couple of indirect pointer accesses and the #ifdef
above.

	Arnd
