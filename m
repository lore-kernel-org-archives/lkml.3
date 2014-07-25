Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbaGYIyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 04:54:43 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54078 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753086AbaGYIyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 04:54:40 -0400
Date: Fri, 25 Jul 2014 10:54:36 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: =?utf-8?B?SmnFmcOt?= Prchal <jiri.prchal@aksignal.cz>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        devicetree@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, Bo Shen <voice.shen@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: sets NPCS0 (PA14) back to GPIO
Message-ID: <20140725085436.GF9532@piout.net>
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>
 <53D10C50.50305@aksignal.cz>
 <20140724162645.4e19c26c@bbrezillon>
 <53D12103.3020103@aksignal.cz>
 <20140724175848.44f5da10@bbrezillon>
 <53D1F5D0.1080006@aksignal.cz>
 <20140725083053.GD9532@piout.net>
 <53D2174B.4020403@aksignal.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D2174B.4020403@aksignal.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/07/2014 at 10:37:31 +0200, Jiří Prchal wrote :
> 
> 
> Dne 25.7.2014 v 10:30 Alexandre Belloni napsal(a):
> >Hi,
> >
> >On 25/07/2014 at 08:14:40 +0200, Jiří Prchal wrote :
> >>I'm using custom board. My spi node:
> >>			spi0: spi@f0000000 {
> >
> >You should override the pinctrl here as you are using gpios for the cs.
> >				pinctrl-0 = <&pinctrl_spi0_custom>;
> >
> >>				status = "okay";
> >>				cs-gpios = <&pioA 23 0
> >>					    &pioA 22 0
> >>					    &pioC 29 0
> >>					    &pioA 14 0>;
> >>
> >
> >		pinctrl@fffff400 {
> >				spi0 {
> >					 pinctrl_spi0_custom: spi0-custom {
> >							 atmel,pins =
> >									 <AT91_PIOA 23 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>,
> >									 <AT91_PIOA 22 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>,
> >									 <AT91_PIOC 29 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>,
> >									 <AT91_PIOA 14 AT91_PERIPH_GPIO AT91_PINCTRL_NONE>;
> >					 };
> >				};
> >		};
> >
> Of course, it's the way, but in all other drivers, for example LEDS,
> it's not needed. And in other way, if I will not use PA14 at all,
> the pin will goes down every spi transfer.

You must not assumed that the pins are muxed to their default state
which is gpio and you should set the pinctrl accordingly for each
device.

If you don't use PA14 at all, then you don't really care about its
state...


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
