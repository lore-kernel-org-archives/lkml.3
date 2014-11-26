Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaKZDIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 22:08:07 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:51841 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaKZDIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 22:08:04 -0500
MIME-Version: 1.0
In-Reply-To: <3490516.nCDXzA8J8x@wuerfel>
References: <1416917818-10506-5-git-send-email-chunyan.zhang@spreadtrum.com>
	<3490516.nCDXzA8J8x@wuerfel>
Date: Wed, 26 Nov 2014 11:08:01 +0800
Message-ID: <CAAfSe-uDk-ih2tqU9a3UEzr=BZgU_=+XJm9=zWbE3J4HMOuiog@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] arm64: Add support for Spreadtrum's Sharkl64
 Platform in Kconfig and defconfig
From: Lyra Zhang <zhang.lyra@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>, grant.likely@linaro.org,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>, Kumar Gala <galak@codeaurora.org>,
        Mark Brown <broonie@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        Will Deacon <will.deacon@arm.com>, gnomes@lxorguk.ukuu.org.uk,
        corbet@lwn.net, jason@lakedaemon.net, Mark Brown <broonie@kernel.org>,
        heiko@sntech.de, shawn.guo@freescale.com, florian.vaussard@epfl.ch,
        andrew@lunn.ch, hytszk@gmail.com, Orson Zhai <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        lanqing.liu@spreadtrum.com,
        =?UTF-8?B?V2VpIFFpYW8gKOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-25 20:57 GMT+08:00 Arnd Bergmann <arnd@arndb.de>:
>
> On Tuesday 25 November 2014 20:16:57 Chunyan Zhang wrote:
> >
> > +menuconfig ARCH_SPRD
> > +       bool "Spreadtrum SoC platform"
> > +       depends on ARM64
> > +       help
> > +         Support for Spreadtrum ARM based SoCs
> > +
> > +if ARCH_SPRD
> > +
> > +config ARCH_SHARKL64
> > +       bool "Sharkl64 SoC Platform"
> > +       help
> > +         Sharkl64 is a Spreadtrum's SoC Platform which is based
> > +         on ARM 64-bit processor core including
> > +           sc9836
> > +
> > +endif #ARCH_SPRD
> > +
>
> I don't think we need multiple levels here, it should be enough to
> have either ARCH_SPRD or ARCH_SHARKL64, because all device drivers
> are going to be optional anyway. Typically a Kconfig symbol covers
> all SoCs that are related, so if you Spreadtrum are doing both
> phone and server chips and these are designed independently, you
> would have two symbols, but if you only expect to see phone chips
> here that are all derived from the same product line, using ARCH_SPRD
> to refer to all of them should be enough.
>
>         Arnd


For now, we have only one platform(Sharkl64) based on ARM64 been
submitted, but we're intending to add support for more our platforms
based on ARM64 or ARM32 in the future. There are many common devices
on these platforms, such as serial. Our idea would be that if we had a
'menuconfig ARCH_SPRD' in the Kconfig, these common devices only need
to depend on ARCH_SPRD in the respective Kconfig, otherwise they may
depend on a few Kconfig symbols for every platforms which include
these common devices.

So, do you think whether we should define a menuconfig(ARCH_SPRD) in
the Kconfig for this case ?

Thanks!

Best regards,
Chunyan
