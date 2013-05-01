Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab3EAT1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:27:35 -0400
Received: from host171.canaca.com ([67.55.55.225]:55804 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3EAT13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:27:29 -0400
Message-ID: <c23b45b45b6a27055cdf18fe4dbc6309.squirrel@www.mungewell.org>
In-Reply-To: <51816271.3040400@infradead.org>
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>
    <51816271.3040400@infradead.org>
Date: Wed, 1 May 2013 15:27:22 -0400
Subject: Re: [PATCH -next] hid: fix hid-steelseries kconfig/build
From: simon@mungewell.org
To: "Randy Dunlap" <rdunlap@infradead.org>
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Jiri Kosina" <jkosina@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy and all,
Seems like you found a problem... but the relevant sections of
'hid-steelseries.c' already have
--
#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
...
#endif
--

Shouldn't this prevent the module having calls to register/unregister if
the LED_CLASS is not enabled?

Does forcing a 'depends on LED_CLASS' in Kconfig prevent the
hid-steelseries module being built on systems without LEDs, or is this
simply a way to ensure that the LED_CLASS module gets loaded first?

Simon.

> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix hid-steelseries build by making it depends on LEDS_CLASS.
> Build errors happen when LEDS_CLASS=m  and HID_STEELSERIES=y.
>
> drivers/built-in.o: In function `steelseries_srws1_remove':
> hid-steelseries.c:(.text+0x3b97a1): undefined reference to
> `led_classdev_unregister'
> drivers/built-in.o: In function `steelseries_srws1_probe':
> hid-steelseries.c:(.text+0x3b9c51): undefined reference to
> `led_classdev_register'
> hid-steelseries.c:(.text+0x3b9ce5): undefined reference to
> `led_classdev_register'
> hid-steelseries.c:(.text+0x3b9d4b): undefined reference to
> `led_classdev_unregister'
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
>  drivers/hid/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux-next-20130501.orig/drivers/hid/Kconfig
> +++ linux-next-20130501/drivers/hid/Kconfig
> @@ -610,6 +610,7 @@ config HID_SPEEDLINK
>  config HID_STEELSERIES
>  	tristate "Steelseries SRW-S1 steering wheel support"
>  	depends on HID
> +	depends on LEDS_CLASS
>  	---help---
>  	Support for Steelseries SRW-S1 steering wheel
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


