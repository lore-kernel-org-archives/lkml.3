Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab3FUBmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 21:42:42 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:19100 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596Ab3FUBmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 21:42:40 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFC PATCH 2/4] watchdog: at91sam9_wdt: update device tree doc
Thread-Topic: [RFC PATCH 2/4] watchdog: at91sam9_wdt: update device tree doc
Thread-Index: AQHOZpKOuCa2VZRu9keXv8Ve8+W5RJk/c4dA
Date: Fri, 21 Jun 2013 01:42:26 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641687DE052@penmbx01>
References: <1370947890-954-1-git-send-email-b.brezillon@overkiz.com>
 <1370947890-954-3-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1370947890-954-3-git-send-email-b.brezillon@overkiz.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5L1gnPV005460



> -----Original Message-----
> From: linux-arm-kernel [mailto:linux-arm-kernel-bounces@lists.infradead.org]
> On Behalf Of Boris BREZILLON
> Sent: 2013Äê6ÔÂ11ÈÕ 18:51
> To: Wim Van Sebroeck; Jean-Christophe Plagniol-Villard; Ferre, Nicolas
> Cc: linux-watchdog@vger.kernel.org; linux-doc@vger.kernel.org;
> devicetree-discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org; Rob
> Herring; Boris BREZILLON; Rob Landley; Grant Likely;
> linux-arm-kernel@lists.infradead.org
> Subject: [RFC PATCH 2/4] watchdog: at91sam9_wdt: update device tree doc
> 
> Add new at91sam9 watchdog properties to the documentation.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  .../devicetree/bindings/watchdog/atmel-wdt.txt     |   30
> ++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
> b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
> index fcdd48f..e043106 100644
> --- a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
> +++ b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
> @@ -9,11 +9,37 @@ Required properties:
> 
>  Optional properties:
>  - timeout-sec: contains the watchdog timeout in seconds.
> +- interrupts : Should contain WDT interrupt.
> +- atmel,max-heartbeat-sec : Should contain the maximum heartbeat value in
> +	seconds. This value should be less than 16. It is used to compute the
> +	WDV field.
> +- atmel,max-heartbeat-sec : Should contain the minimum heartbeat value in
Typo, should be,
- atmel,min-heartbeat-sec
> +	seconds. This value should be less than 4 times the max-heartbeat-sec
> +	value. It is used to compute the WDD field.
> +- atmel,watchdog-type : Should be "hardware" or "software". Hardware
> watchdog
> +	use the at91 watchdog reset. Software watchdog use the watcdog
> interrup
> +	to trigger a software reset.
> +- atmel,reset-type : Should be "proc" or "all".
> +	"all" : assert peripherals and processor reset signals
> +	"proc" : assert the processor reset signal
> +	This is valid only when using "hardware" watchdog.
> +- atmel,disable : Should be present if you want to disable the watchdog.
> +- atmel,idle-halt : Should be present if you want to stop the watchdog when
> +	entering idle state.
> +- atmel,dbg-halt : Should be present if you want to stop the watchdog when
> +	entering debug state.
> 
>  Example:
> -
>  	watchdog@fffffd40 {
>  		compatible = "atmel,at91sam9260-wdt";
>  		reg = <0xfffffd40 0x10>;
> -		timeout-sec = <10>;
> +		interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
> +		timeout-sec = <15>;
> +		atmel,watchdog-type = "hardware";
> +		atmel,reset-type = "all";
> +		atmel,dbg-halt;
> +		atmel,idle-halt;
> +		atmel,max-heartbeat-sec = <16>;
> +		atmel,min-heartbeat-sec = <0>;
> +		status = "okay";
>  	};
> --
> 1.7.9.5
> 
> 
Best Regards,
Wenyou Yang
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
