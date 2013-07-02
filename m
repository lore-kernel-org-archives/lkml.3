Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3GBGDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:03:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46070 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab3GBGD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:03:28 -0400
Message-ID: <51D26CFA.5090500@ti.com>
Date: Tue, 2 Jul 2013 11:32:34 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
CC: <khilman@linaro.org>, <tony@atomide.com>, <b-cousson@ti.com>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Alessandro Zummo <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 3/4] rtc: omap: add rtc wakeup support to alarm events
References: <1372412109-986-1-git-send-email-gururaja.hebbar@ti.com> <1372412109-986-4-git-send-email-gururaja.hebbar@ti.com>
In-Reply-To: <1372412109-986-4-git-send-email-gururaja.hebbar@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/28/2013 3:05 PM, Hebbar Gururaja wrote:
> On some platforms (like AM33xx), a special register (RTC_IRQWAKEEN)
> is available to enable Alarm Wakeup feature. This register needs to be
> properly handled for the rtcwake to work properly.
> 
> Platforms using such IP should set "ti,am3352-rtc" in rtc device dt
> compatibility node.
> 
> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: rtc-linux@googlegroups.com
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-doc@vger.kernel.org
> ---

[...]

> -#define	OMAP_RTC_DATA_DA830_IDX	1
> +#define	OMAP_RTC_DATA_DA830_IDX		1
> +#define	OMAP_RTC_DATA_AM335X_IDX	2
>  
>  static struct platform_device_id omap_rtc_devtype[] = {
>  	{
> @@ -309,6 +321,9 @@ static struct platform_device_id omap_rtc_devtype[] = {
>  	}, {
>  		.name	= "da830-rtc",
>  		.driver_data = OMAP_RTC_HAS_KICKER,
> +	}, {
> +		.name	= "am335x-rtc",

may be use am3352-rtc here just to keep the platform device name and of
compatible in sync.

> +		.driver_data = OMAP_RTC_HAS_KICKER | OMAP_RTC_HAS_IRQWAKEEN,
>  	},
>  	{},

It is better to use the index defined above in the static initialization
so they remain in sync.

	...
	[OMAP_RTC_DATA_DA830_IDX] = {
		.name	= "da830-rtc",
		.driver_data = OMAP_RTC_HAS_KICKER,
	},
	...

>  };
> @@ -318,6 +333,9 @@ static const struct of_device_id omap_rtc_of_match[] = {
>  	{	.compatible	= "ti,da830-rtc",
>  		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_DA830_IDX],
>  	},
> +	{	.compatible	= "ti,am3352-rtc",
> +		.data		= &omap_rtc_devtype[OMAP_RTC_DATA_AM335X_IDX],
> +	},
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, omap_rtc_of_match);

Apart from these minor issues, the patch looks good to me.

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
