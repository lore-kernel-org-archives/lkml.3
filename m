Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaGaP7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:59:48 -0400
Received: from top.free-electrons.com ([176.31.233.9]:36699 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751255AbaGaP7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:59:46 -0400
Date: Thu, 31 Jul 2014 17:59:06 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: =?utf-8?B?SmnFmcOt?= Prchal <jiri.prchal@aksignal.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, nicolas.ferre@atmel.com,
        voice.shen@atmel.com, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] ARM: at91: spi: request all csgpio in spi probe
Message-ID: <20140731155906.GH3214@piout.net>
References: <b033d16ec31d26a895726ee72ec89b43943dfbae.1406547656.git.jiri.prchal@aksignal.cz>
 <20140728122103.GR9532@piout.net>
 <53D64ADA.1000102@aksignal.cz>
 <20140728223859.GA3214@piout.net>
 <20140729100017.31f0b1be@bbrezillon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140729100017.31f0b1be@bbrezillon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/2014 at 10:00:17 +0200, Boris Brezillon wrote :
> Hi Alexandre,
> 
> > While this solves the particular issue Jiří is seeing, this will not
> > solve the case where PA14 (CS0) is not used by the spi driver at all. It
> > will remained muxed as CS0 and toggle when the spi master needs to
> > access CS0 until another driver muxes it to something else. I still
> > believe we should explicitly ask pinctrl to mux them as gpios.
> > 
> 
> Do we really care about this case ?
> After all, if a given pin needs a specific muxing during kernel boot
> (i.e. a pin connected to a gpio-led that needs to stay in its previous
> state or a pin connected to the reset line of a device that needs to
> stay up and running during kernel boot) the bootloader/bootstrap should
> have muxed this pin appropriately before booting the kernel.
> 

Yeah, you are right.


> What do you mean by "we should explicitly ask pinctrl to mux them as
> gpios" ?
> Do you mean configuring all the pins as GPIOs when the pin controller is
> probed, or just adding a new pinctrl state configuring the pin as an
> output GPIO and reference it in the pinctrl-0 property of the spi
> controller.
> 
> If the former, you'll break devices that needs their pins to stay in
> the state they were during the bootloader/boostrap phase.
> The latter won't work if the pin you request as GPIO is later requested
> by another device (which, if I'm correct, is exactly the case you're
> trying to solve).
> 

Again you are right, let's not care about that use case. I still feel
that the pinctrl-0 property has to be filled correctly.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
