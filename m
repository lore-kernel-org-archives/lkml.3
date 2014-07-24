Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbaGXO0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 10:26:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48903 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758953AbaGXO0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 10:26:49 -0400
Date: Thu, 24 Jul 2014 16:26:45 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: jiri.prchal@aksignal.cz
Cc: Bo Shen <voice.shen@atmel.com>, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: sets NPCS0 (PA14) back to GPIO
Message-ID: <20140724162645.4e19c26c@bbrezillon>
In-Reply-To: <53D10C50.50305@aksignal.cz>
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>
	<53D10C50.50305@aksignal.cz>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jiří,

First of all, please try to use git format-patch when submitting a
patch to any kernel mailing list.

On Thu, 24 Jul 2014 15:38:24 +0200
Jiří Prchal <jiri.prchal@aksignal.cz> wrote:

> After ROMBOOT tries boot from flash on SPI0 NPCS0, this NPCS0 (PA14) remains set to PERIPH_A.
> Because of that, this pin is unusable to something else.
> This patch sets it back to GPIO.

The policy is to leave pins in an unknown state till some peripheral
need them.

What are you trying to use this pin for ?
If you just want to use it as a chip select for an spi device, take a
look at [1].

Here the gpio is requested by the spi core when defining the cs-gpios
property. The gpio controller then request the listed pins to the pin
controller (pinctrl driver).

You can explicitly define a new pinctrl state (by defining a new
pinctrl_spi0_cs0 subnode in your dts file) and reference it in the
spi0 node, though this is not mandatory.

Best Regards,

Boris

[1]http://lxr.free-electrons.com/source/arch/arm/boot/dts/at91sam9x5ek.dtsi#L85

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
