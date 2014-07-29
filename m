Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaG2Siw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 14:38:52 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:54745 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaG2Siv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 14:38:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Tue, 29 Jul 2014 20:39:20 +0200
From: Stefan Agner <stefan@agner.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, shawn.guo@freescale.com,
        kernel@pengutronix.de, peter.chen@freescale.com,
        linux-kernel@vger.kernel.org, jingchang.lu@freescale.com
Subject: Re: [PATCH] ARM: imx: clk-vf610: introduce =?UTF-8?Q?clks=5Finit?=
 =?UTF-8?Q?=5Fon?=
In-Reply-To: <2815679.ZycfkLhBgI@wuerfel>
References: <1406643628-4061-1-git-send-email-stefan@agner.ch>
 <2815679.ZycfkLhBgI@wuerfel>
Message-ID: <2a672a5d28af5425e1c406b0607befd5@agner.ch>
User-Agent: Roundcube Webmail/1.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-07-29 16:44, schrieb Arnd Bergmann:
> On Tuesday 29 July 2014 16:20:28 Stefan Agner wrote:
>> At the end of the boot process, the clock framework might disable
>> required main PLL's. So far, this was no issue since drivers
>> requested clocks, which are descended of the main PLL's (e.g.
>> pll1_pfd1, which provides the system clock).
>>
>> To archive the full 500MHz system clock, DDR clock need to be a
>> descendant of PLL2 rather than PLL1 (DDRC_CLK_SEL set to 0). The
>> bootloader sets up the clocks accordingly before making use of
>> DDR at all. However, in Linux, there is no driver using PLL2,
>> which lead to PLL2 being disabled by the clock framework.
>>
>> With this patch, we make sure that the main system clock and the
>> DDR clock are initially enabled and are kept enabled.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>>
> 
> Wouldn't it be better to list this in the DT as a default for
> the respective clocks?
> 

What do you mean by that exactly? Creating a driver for the main PLL's
and add device tree entries to instantiate them, along with a property
like "boot-enabled" or similar?

The approach chosen in this patch is aligned the way it's done for i.MX6
(see arch/arm/mach-imx/clk-imx6q.c). The whole clock module(s) in Vybrid
are slightly striped variants found in i.MX6. For now, I would prefer to
leave it that way. 

--
Stefan
