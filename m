Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab3FKW3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 18:29:43 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43546 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab3FKW3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 18:29:41 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH 2/4] watchdog: at91sam9_wdt: update device tree doc
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Wim Van Sebroeck <wim@iguana.be>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
In-Reply-To: <1370947890-954-3-git-send-email-b.brezillon@overkiz.com>
References: <1370947890-954-1-git-send-email-b.brezillon@overkiz.com> <1370947890-954-3-git-send-email-b.brezillon@overkiz.com>
Date: Tue, 11 Jun 2013 23:29:36 +0100
Message-Id: <20130611222936.C23523E0D8D@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jun 2013 12:51:27 +0200, Boris BREZILLON <b.brezillon@overkiz.com> wrote:
> Add new at91sam9 watchdog properties to the documentation.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Looks reasonable,

Acked-by: Grant Likely <grant.likely@linaro.org>

> ---
>  .../devicetree/bindings/watchdog/atmel-wdt.txt     |   30 ++++++++++++++++++--
>  1 file changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
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
> +	seconds. This value should be less than 4 times the max-heartbeat-sec
> +	value. It is used to compute the WDD field.
> +- atmel,watchdog-type : Should be "hardware" or "software". Hardware watchdog
> +	use the at91 watchdog reset. Software watchdog use the watcdog interrup
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

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
