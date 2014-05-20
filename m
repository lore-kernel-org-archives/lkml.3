Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbaETT3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:29:12 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:59063 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaETT3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:29:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, dbaryshkov@gmail.com,
        dwmw2@infradead.org, ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com, galak@codeaurora.org,
        grant.likely@linaro.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        grygorii.strashko@ti.com, olof@lixom.net, w-kwok2@ti.com,
        sboyd@codeaurora.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch v3 0/5] Introduce keystone reset driver
Date: Tue, 20 May 2014 21:27:48 +0200
Message-ID: <10992709.10WgsOixXr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <537BA06B.5060200@ti.com>
References: <1400495155-11136-1-git-send-email-ivan.khoronzhuk@ti.com> <537B5D5D.8030106@ti.com> <537BA06B.5060200@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:wtN+1jjlk7DXKm2TmoKmEIXdhtK2LuescadjXPxfWtf
 cMU+eEFJuLMo1HlDdVEasPD0O3RT0J/UCAGTBfLtpgA9G5Z6j+
 hLXhI1U7U5hFyzUmbRYi3y233e7FDUGcMWsqZW5t/nhP2w9ub2
 EPH0iH2tDkHdqbWCoZGryFk42YbvJoFuGHMEn9ZLpHaY0r1nfZ
 kSUxS9+M/DJ4uxWuh5tJd4qDQh0ubDdeorRhzqeYp+XeNVQBHr
 biQBYN0DNk48JHzJBCvgm2088pHJ7Y56F0m5zr2uzw/TyEOO/x
 Lq20VI/5PiDWIgElXZFUE4uXzpV0bOfC4q1c+kIJ+oEpAAEvPC
 Qb9LYofqVLTQYQ0692fI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 21:35:23 Ivan Khoronzhuk wrote:
> Thank for the note.
> 
> Ok.
> 
> Memory map:
> [00 02310000 - 00 023101FF] size=512 PLL Controller
> [00 02620000 - 00 02620FFF] size=4K device state control registers
> 
> I'll define in DT two new syscon compatible nodes like:
> 
>          pllctrl: pll_controller {
>              compatible = "syscon";
>              reg = <0x2310000 0x200>;
>          };
> 
>          devctrl: device_state_control {
>              compatible = "syscon";
>              reg = <0x2620000 0x1000>;
>          };

Please add a well-defined compatible-string in addition to "syscon" as
well.

> then correct reset-controller node like:
> 
>          rstctrl: reset-controller {
>              compatible = "ti,keystone-reset";
>              reg = <0xE4 0x10>, <0x328 0x10>;
>              reg-names = "pllregs", "muxregs";
>              syscon1 = <&pllctrl>;
>              syscon2 = <&devctrl>;
>              ti,wdt_list = <0>;
>          };

You can't really use the "reg" property to refer to syscon
registers, but you can make up your own property for that,
or put the register numbers into the syscon1/2 properties,
or just hardcode the offsets in the driver.

> And correct reset-controller code to get regmap by phandle,
> then access registers by regmap.
> 
> Also I'll post two separate patches that add syscon nodes in question.

Sounds good, thanks!

	Arnd
