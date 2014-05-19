Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbaESRs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:48:28 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:50845 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaESRsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:48:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: dbaryshkov@gmail.com, dwmw2@infradead.org, ijc+devicetree@hellion.org.uk,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com, galak@codeaurora.org,
        grant.likely@linaro.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        grygorii.strashko@ti.com, olof@lixom.net, w-kwok2@ti.com,
        sboyd@codeaurora.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch v3 0/5] Introduce keystone reset driver
Date: Mon, 19 May 2014 19:47:13 +0200
Message-ID: <5095812.b6DgWAxYzH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <537A1E2C.8040102@ti.com>
References: <1400495155-11136-1-git-send-email-ivan.khoronzhuk@ti.com> <537A1E2C.8040102@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:zNWjhACa8Ud/Jgy8nqM27dXkzcG90Uaj+5XjqxNqHBk
 3hcxNtGY4dresJQtfOFQ0fl/iVOagLcbr/3QTeg/QyOuddOsSp
 fPoH2Mpee04dRPGtSQoE79gTqs1//mclyDUI75a0IEje6FAVLY
 GrsEgu76EeCd8ajTwMSOfKl8OlUNKR7x2kKDKAh4nR2G5It9IS
 v4R4VME4D/dlc+rCSIKGtg651tiiXGH7qNOcVEFckUAMrbF+zW
 R7g9YCiAWkOrAbVaObxE4BBDQx9TsjmB63c+OQdouPe4x/5iAK
 MYwP+o/m3DvkBSy3KhGVphXiHYOkaAFkzkHPexCR6QsxGE1z/E
 tJ6+wFPOwM0IABPNz3LE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 May 2014 11:07:24 Santosh Shilimkar wrote:
> On Monday 19 May 2014 06:25 AM, Ivan Khoronzhuk wrote:
> > These patches introduce keystone reset driver.
> > 
> > The keystone SoC can be rebooted in several ways. By external reset
> > pin, by soft and by watchdogs. This driver allows software reset and reset
> > by one of the watchdogs. Also added opportunity to set soft/hard reset type.
> > 
> > Based on v3.15-rc5
> > 
> Arnd,
> Can I have have your ack/reviewed-by please since you did gave few comments
> on previous version.

Sorry for not getting back to you earlier on this topic.

> On 04/14/2014 09:44 PM, Arnd Bergmann wrote:
> > On Monday 14 April 2014 20:41:20 Ivan Khoronzhuk wrote:
> >> +Optional properties:
> >> +
> >> +- ti,soft-reset:       Boolean option indicating soft reset.
> >> +                       By default hard reset is used.
> >> +
> >> +- ti,wdt_list:         WDT list that can cause SoC reset.
> >> +                       The list in format: <0>, <2>;
> >> +                       Begins from 0 to 3, as keystone can contain up
> >> +                       to 4 SoC reset watchdogs.
> > 
> > This looks like your binding just describes a subset of the
> > watchdog timer registers. If so, don't do a standalone reset
> 
> The registers are not a subset of watchdog hardware it's SoC specific future
> controlled by SoC specific registers (bootregs and PLL regs).
> 
> For watchog IP setup, the Keystone uses the watchdog driver common with
> other
> SoCs -- davinci_watchdog that is not depend on other SoC settings like
> this driver does.
> 
> The Keystone SoCs have separate registers to tune Keystone2 reset
> functionality
> by configuring Reset multiplexer &  PLL. And it tunes not only watchdog
> usage.
> The keystone SoC can be rebooted in several ways. By external reset pin,
> by soft and
> by watchdogs. This driver allows software reset or reset by one of the
> watchdogs
> (and other settings) independently on watchdog driver settings. This is
> job of reset driver.

It sounds like you use a syscon area in the reset driver. This is not
uncommon, but it means you should probably have a generic node for
the SoC specific registers that contains all of them at once and
exports them as a regmap using the drivers/mfd/syscon.c driver.

	Arnd
