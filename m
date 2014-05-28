Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaE1MYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 08:24:30 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:57749 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068AbaE1MY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 08:24:28 -0400
Message-ID: <1401279867.22486.6.camel@x220>
Subject: Re: [PATCH] misc: atmel_pwm: only build for supported platforms
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Wed, 28 May 2014 14:24:27 +0200
In-Reply-To: <536CA80A.60201@atmel.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
	 <1399560990-1402858-1-git-send-email-arnd@arndb.de>
	 <1399560990-1402858-17-git-send-email-arnd@arndb.de>
	 <536CA80A.60201@atmel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2014 12:24:27.0211 (UTC) FILETIME=[C46781B0:01CF7A6F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-09 at 12:03 +0200, Nicolas Ferre wrote:
> On 08/05/2014 16:56, Arnd Bergmann :
> > There is architecture code in mach-at91 that depends on the
> > CONFIG_ATMEL_PWM symbol in order to call the soc-specific
> > at91_add_device_pwm function. While all of this is about code
> > that will be removed in the future, using DT probing and
> > the PWM framework, we currently get a build failure:
> > 
> > arch/arm/mach-at91/built-in.o: In function `at91_pwm_leds':
> > arch/arm/mach-at91/leds.c:88: undefined reference to `at91_add_device_pwm'
> > 
> > This patch ensures we only try to build this driver on
> > platforms on which it will build and work.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

It seems this one just landed in linux-next (in next-20140528).

> > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > index fe2230c..ce29342 100644
> > --- a/drivers/misc/Kconfig
> > +++ b/drivers/misc/Kconfig
> > @@ -53,7 +53,8 @@ config AD525X_DPOT_SPI
> >  
> >  config ATMEL_PWM
> >  	tristate "Atmel AT32/AT91 PWM support"
> > -	depends on HAVE_CLK && (AVR32 || ARCH_AT91 || COMPILE_TEST)
> > +	depends on HAVE_CLK
> > +	depends on AVR32 || AT91SAM9263 || AT91SAM9RL || AT91SAM9G45

Symbols AT91SAM9263, AT91SAM9RL, and AT91SAM9G45 do not seem to exist in
next-20140528. Should these perhaps be SOC_AT91SAM9263, SOC_AT91SAM9RL,
and SOC_AT91SAM9G45 and/or ARCH_AT91SAM9263, ARCH_AT91SAM9RL, and
ARCH_AT91SAM9G45?

> >  	help
> >  	  This option enables device driver support for the PWM channels
> >  	  on certain Atmel processors.  Pulse Width Modulation is used for
> > 


Paul Bolle

