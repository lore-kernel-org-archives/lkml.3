Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184AbaGYKuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 06:50:39 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:60864 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760014AbaGYKui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 06:50:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Jul 2014 12:50:55 +0200
From: Stefan Agner <stefan@agner.ch>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] can: flexcan: add vf610 support for FlexCAN
In-Reply-To: <1b8a8ca03b4a160027a79b722f697e25@agner.ch>
References: <cover.1405428166.git.stefan@agner.ch>
 <ff2ea1726b13dc2ffa3519ce9244f3633cf1420d.1405428166.git.stefan@agner.ch>
 <53C5398F.2000005@pengutronix.de>
 <1b8a8ca03b4a160027a79b722f697e25@agner.ch>
Message-ID: <601adb6fe47279c115c1cc607365a00e@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-07-16 08:43, schrieb Stefan Agner:
> Am 2014-07-15 16:24, schrieb Marc Kleine-Budde:
> <snip>
>>> @@ -150,18 +171,20 @@
>>>   * FLEXCAN hardware feature flags
>>>   *
>>>   * Below is some version info we got:
>>> - *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT
>>> - *                                Filter?   connected?
>>> - *   MX25  FlexCAN2  03.00.00.00     no         no
>>> - *   MX28  FlexCAN2  03.00.04.00    yes        yes
>>> - *   MX35  FlexCAN2  03.00.00.00     no         no
>>> - *   MX53  FlexCAN2  03.00.00.00    yes         no
>>> - *   MX6s  FlexCAN3  10.00.12.00    yes        yes
>>> + *    SOC   Version   IP-Version  Glitch-  [TR]WRN_INT  Memory err
>>> + *                                Filter?   connected?  detection
>>> + *   MX25  FlexCAN2  03.00.00.00     no         no         no
>>> + *   MX28  FlexCAN2  03.00.04.00    yes        yes         no
>>> + *   MX35  FlexCAN2  03.00.00.00     no         no         no
>>> + *   MX53  FlexCAN2  03.00.00.00    yes         no         no
>>> + *   MX6s  FlexCAN3  10.00.12.00    yes        yes         no
>>> + *   VF610 FlexCAN3  ?               no         no        yes
>>                                         ^^         ^^
>>
>> Can you check the datasheet if the flexcan core has a "Glitch Filter
>> Width Register (FLEXCANx_GFWR)"
> 
> 
> There is no such register called GFWR/Glitch Filter or similar.
> 
>> Can you check if the core generates a warning interrupt with the current
>> setup, if you don't switch on bus error reporting? This means internally
>> the [TR]WRN_INT is connected and works as specified.
> 
> Ok, so I disabled TWRNMSK (Bit 11) in the control register and printed
> out the error and status register (ESR1), this is what I get:
> [  191.285295] flexcan_irq, esr=00040080
> [  191.288996] flexcan_irq, ctrl=17092051
> 
> Bit 17 (TWRNINT) is not set while TWRNMSK is disabled. Hence [TR]WRN_INT
> is not connected?

Ping. Anything open/to do from my side?

--
Stefan
