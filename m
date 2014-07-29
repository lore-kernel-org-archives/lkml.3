Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaG2H2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:28:45 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:39071 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaG2H2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:28:44 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Tue, 29 Jul 2014 09:29:13 +0200
From: Stefan Agner <stefan@agner.ch>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: shawn.guo@freescale.com, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] can: flexcan: add vf610 support for FlexCAN
In-Reply-To: <53D67A46.3060202@pengutronix.de>
References: <cover.1405428166.git.stefan@agner.ch>
 <ff2ea1726b13dc2ffa3519ce9244f3633cf1420d.1405428166.git.stefan@agner.ch>
 <53C5398F.2000005@pengutronix.de>
 <1b8a8ca03b4a160027a79b722f697e25@agner.ch>
 <601adb6fe47279c115c1cc607365a00e@agner.ch>
 <53D25C9D.5080803@pengutronix.de>
 <e88108c655e2c16dc9cf6c4194547e73@agner.ch>
 <53D67A46.3060202@pengutronix.de>
Message-ID: <b815c5c1f7faed334d1ed5370d51c180@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-07-28 18:28, schrieb Marc Kleine-Budde:
> On 07/28/2014 06:20 PM, Stefan Agner wrote:
>> I'm not sure whether you really want to keep the FLEXCAN_CTRL_ERR_STATE
>> commented out...
> 
> No, please remove this change and redo the test.
> 

Ok, removed that change and did the tests again:

== Wrong Bitrate test

[  146.485022] flexcan 40020000.flexcan can0: bitrate error 0.7%
[  148.401793] flexcan 40020000.flexcan can0: writing ctrl=0x17092001
[  148.408263] flexcan 40020000.flexcan can0: flexcan_set_bittiming:
mcr=0x5980000f ctrl=0x17092001
[  148.408298] flexcan 40020000.flexcan can0: flexcan_chip_start:
writing mcr=0x79a20208
[  148.408328] flexcan 40020000.flexcan can0: flexcan_chip_start:
writing ctrl=0x1709ac51
[  148.414373] flexcan 40020000.flexcan can0: flexcan_chip_start:
reading mcr=0x60a20208 ctrl=0x1709ac51
^---- Initialization
[  152.968685] flexcan_irq, esr=00040080
[  152.972386] flexcan_irq, ctrl=1709ac51
[  155.488623] flexcan_irq, esr=00040080
[  155.492326] flexcan_irq, ctrl=1709ac51
^---- Two messages with right bitrate
[  171.014124] flexcan_irq, esr=00058d0a
[  171.017823] flexcan_irq, ctrl=1709ac51
^---- One message with wrong bitrate
[  171.021631] flexcan 40020000.flexcan can0: Error Warning IRQ
[  171.021660] flexcan 40020000.flexcan can0: Error Passive IRQ

# ./candump -e any,0:0,#FFFFFFFF
  can0  1F334455   [8]  11 22 33 44 55 66 77 88
  can0  1F334455   [8]  11 22 33 44 55 66 77 88
  can0  20000004   [8]  00 10 00 00 00 00 00 00   ERRORFRAME
	controller-problem{rx-error-passive}

== Loopback test

[  464.003776] flexcan 40020000.flexcan can0: writing ctrl=0x17092051
[  464.010005] flexcan 40020000.flexcan can0: flexcan_set_bittiming:
mcr=0x5980000f ctrl=0x17092051
[  464.010035] flexcan 40020000.flexcan can0: flexcan_chip_start:
writing mcr=0x79a20208
[  464.010064] flexcan 40020000.flexcan can0: flexcan_chip_start:
writing ctrl=0x1709ac51
[  464.010199] flexcan 40020000.flexcan can0: flexcan_chip_start:
reading mcr=0x60a20208 ctrl=0x1709ac51
[  464.011682] IPv6: ADDRCONF(NETDEV_CHANGE): can0: link becomes ready
[  470.970133] flexcan_irq, esr=00064252
[  470.974833] flexcan_irq, ctrl=1709ac51
[  470.980171] flexcan 40020000.flexcan can0: Error Warning IRQ
[  470.980203] flexcan 40020000.flexcan can0: Error Passive IRQ
[  470.980328] flexcan_irq, esr=00000034
[  470.984998] flexcan_irq, ctrl=1709ac51

# ./candump -e any,0:0,#FFFFFFFF
  can0  20000044   [8]  00 10 00 00 00 00 00 00   ERRORFRAME
	controller-problem{rx-error-passive}
	bus-off

--
Stefan
