Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbaKXSeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 13:34:18 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:59860 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaKXSeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:34:16 -0500
MIME-Version: 1.0
In-Reply-To: <11772640.IZcxoRkMEM@wuerfel>
References: <1416796846-28149-1-git-send-email-cernekee@gmail.com>
	<1416796846-28149-12-git-send-email-cernekee@gmail.com>
	<11772640.IZcxoRkMEM@wuerfel>
Date: Mon, 24 Nov 2014 10:34:15 -0800
X-Google-Sender-Auth: FBoW6-OK76MnjoFJtngZEebsfv8
Message-ID: <CAL1qeaH8d0DAZ5SEyioPUM1WXvTgyEoXOqM88-tibnsd-MDT=Q@mail.gmail.com>
Subject: Re: [PATCH V3 11/11] MIPS: Add multiplatform BMIPS target
From: Andrew Bresticker <abrestic@chromium.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Cernekee <cernekee@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>, jfraser@broadcom.com,
        Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Jonas Gorski <jogo@openwrt.org>,
        computersforpeace@gmail.com, Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 24, 2014 at 6:00 AM, Arnd Bergmann <arnd@arndb.de> wrote:
>> ---
>>  .../devicetree/bindings/mips/brcm/bmips.txt        |   8 +
>>  .../devicetree/bindings/mips/brcm/soc.txt          |  12 ++
>>  arch/mips/Kbuild.platforms                         |   1 +
>>  arch/mips/Kconfig                                  |  36 ++++
>>  arch/mips/bmips/Kconfig                            |  50 ++++++
>>  arch/mips/bmips/Makefile                           |   1 +
>>  arch/mips/bmips/Platform                           |   7 +
>>  arch/mips/bmips/dma.c                              | 141 +++++++++++++++
>>  arch/mips/bmips/irq.c                              |  38 ++++
>>  arch/mips/bmips/setup.c                            | 195 +++++++++++++++++++++
>>  arch/mips/boot/dts/Makefile                        |   9 +
>>  arch/mips/boot/dts/bcm3384_viper.dtsi              | 108 ++++++++++++
>>  arch/mips/boot/dts/bcm3384_zephyr.dtsi             | 126 +++++++++++++
>>  arch/mips/boot/dts/bcm6328.dtsi                    |  87 +++++++++
>>  arch/mips/boot/dts/bcm6368.dtsi                    |  94 ++++++++++
>>  arch/mips/boot/dts/bcm7125.dtsi                    | 107 +++++++++++
>>  arch/mips/boot/dts/bcm7346.dtsi                    | 192 ++++++++++++++++++++
>>  arch/mips/boot/dts/bcm7360.dtsi                    | 129 ++++++++++++++
>>  arch/mips/boot/dts/bcm7420.dtsi                    | 151 ++++++++++++++++
>>  arch/mips/boot/dts/bcm7425.dtsi                    | 191 ++++++++++++++++++++
>
> I hadn't noticed before that the dts files are now all in one
> directory on MIPS, apparently after a patch from Andrew Brewsticker.
> We should really coordinate these things better, we have just merged
> an arm64 patch to split out the files into multiple directories.

FWIW, I'm planning on sending a patch once 3.19-rc1 is released to
move the DTs into per-vendor sub-directories.  I was expecting to do
it for 3.19, but Robert Richter's series which added kbuild support
for the vendor sub-directories did not end up landing in 3.18.
