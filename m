Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab3GBGNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:13:22 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47013 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab3GBGNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:13:21 -0400
Message-ID: <51D26F61.7080308@ti.com>
Date: Tue, 2 Jul 2013 11:42:49 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
CC: <khilman@linaro.org>, <tony@atomide.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <benoit.cousson@gmail.com>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <vaibhav.bedia@ti.com>, <sudhakar.raj@ti.com>
Subject: Re: [PATCH 4/4] ARM: dts: AM33XX: update rtc node compatibility
References: <1372412109-986-1-git-send-email-gururaja.hebbar@ti.com> <1372412109-986-5-git-send-email-gururaja.hebbar@ti.com>
In-Reply-To: <1372412109-986-5-git-send-email-gururaja.hebbar@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing to Benoit's gmail id since he apparently wont access TI mail
anymore.

On 6/28/2013 3:05 PM, Hebbar Gururaja wrote:
> Since AM33xx  RTC IP has RTC_IRQWAKEEN to support Alarm Wake-up.
> 
> Update the rtc compatible property to "ti,am3352-rtc" to enable handling
> of this feature inside rtc-omap driver.
> 
> Signed-off-by: Hebbar Gururaja <gururaja.hebbar@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Kevin Hilman <khilman@linaro.org>
> Cc: b-cousson@ti.com
> ---
> :100644 100644 77aa1b0... dde180a... M	arch/arm/boot/dts/am33xx.dtsi
>  arch/arm/boot/dts/am33xx.dtsi |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 77aa1b0..dde180a 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -297,7 +297,7 @@
>  		};
>  
>  		rtc@44e3e000 {
> -			compatible = "ti,da830-rtc";
> +			compatible = "ti,am3352-rtc";

compatible is a list so you can instead do:
	
	compatible = "ti,am3352-rtc", "ti,da830-rtc";

That way the dts works irrespective of driver updates. When driver
supports enhanced features of hardware, they are available to the user
else the basic functionality still works.

Thanks,
Sekhar
