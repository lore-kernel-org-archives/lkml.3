Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3F1KPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:15:22 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33916 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab3F1KPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:15:16 -0400
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "khilman@linaro.org" <khilman@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "Cousson, Benoit" <b-cousson@ti.com>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 2/4] davinci: da8xx/omap-l1: Remove hard coding of rtc
 device	wakeup
Thread-Topic: [PATCH 2/4] davinci: da8xx/omap-l1: Remove hard coding of rtc
 device	wakeup
Thread-Index: AQHOc+J8amN9ft053kuaamPhBz/OlJlK59AA
Date: Fri, 28 Jun 2013 10:14:34 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3EA95D17@DBDE04.ent.ti.com>
References: <1372412109-986-1-git-send-email-gururaja.hebbar@ti.com>
 <1372412109-986-3-git-send-email-gururaja.hebbar@ti.com>
In-Reply-To: <1372412109-986-3-git-send-email-gururaja.hebbar@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jun 28, 2013 at 15:05:07, Hebbar, Gururaja wrote:
> Since now rtc-omap driver itself calls deice_init_wakeup(dev, true),
> duplicate call from the rtc device registration can be removed.
> 

Tested on da850-evm for rtc wake along with patch 1/2.
$rtcwake -s 2 -d /dev/rtc0 -m mem

Tested-by: Manjunathappa, Prakash <prakash.pm@ti.com>

> This is basically a partial revert of the prev commit
> 
> commit 75c99bb0006ee065b4e2995078d779418b0fab54
> Author: Sekhar Nori <nsekhar@ti.com>
> 
>     davinci: da8xx/omap-l1: mark RTC as a wakeup source
> 
> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> 
> ---
> :100644 100644 bf57252... 85a900c... M	arch/arm/mach-davinci/devices-da8xx.c
>  arch/arm/mach-davinci/devices-da8xx.c |    9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
> index bf57252..85a900c 100644
> --- a/arch/arm/mach-davinci/devices-da8xx.c
> +++ b/arch/arm/mach-davinci/devices-da8xx.c
> @@ -827,14 +827,7 @@ static struct platform_device da8xx_rtc_device = {
>  
>  int da8xx_register_rtc(void)
>  {
> -	int ret;
> -
> -	ret = platform_device_register(&da8xx_rtc_device);
> -	if (!ret)
> -		/* Atleast on DA850, RTC is a wakeup source */
> -		device_init_wakeup(&da8xx_rtc_device.dev, true);
> -
> -	return ret;
> +	return  platform_device_register(&da8xx_rtc_device);
>  }
>  
>  static void __iomem *da8xx_ddr2_ctlr_base;
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 

