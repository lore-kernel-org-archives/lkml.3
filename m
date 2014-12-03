Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaLCKL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:11:57 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35413 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751843AbaLCKLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:11:55 -0500
Date: Wed, 3 Dec 2014 10:11:09 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lyra Zhang <zhang.lyra@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Mark Brown <broonie@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        Wei Qiao =?utf-8?B?KOS5lOS8nyk=?= <wei.qiao@spreadtrum.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        "zhizhou.zhang" <zhizhou.zhang@spreadtrum.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Pawel Moll <pawel.moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Hayato Suzuki <hytszk@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        Mark Brown <broonie@kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v3 5/5] tty/serial: Add Spreadtrum sc9836-uart driver
 support
Message-ID: <20141203101109.GB11285@n2100.arm.linux.org.uk>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <54761BFC.4020705@ti.com>
 <CAAfSe-u+g0mYGi9Adrd+YwwZ=q0-s79yCg_paB1UAVqFoufXEA@mail.gmail.com>
 <3212776.kDbe7yX4eX@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3212776.kDbe7yX4eX@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 10:50:17AM +0100, Arnd Bergmann wrote:
> On Wednesday 03 December 2014 17:17:13 Lyra Zhang wrote:
> 
> > 2014-11-27 2:29 GMT+08:00 Murali Karicheri <m-karicheri2@ti.com>:
> > > How about sorting this includes? asm/irq.h go first followed linux/ in alphabatical order?
> >
> > There are a few compile warnings if I moved asm/irq.h to the top of
> > all included files.
> 
> The order that Murali meant is
> 
> - first all linux/*.h headers, sorted alphabetically
> - then all asm/*.h headers, again sorted alphabetically
> 
> This is the recommended style in general.
> 
> > Warning details are below:
> > 
> > In file included from drivers/tty/serial/sprd_serial.c:14:0:
> > ./arch/arm64/include/asm/irq.h:6:39: warning: ‘struct pt_regs’
> > declared inside parameter list [enabled by default]
> >  extern void (*handle_arch_irq)(struct pt_regs *);
> >                                        ^
> > ./arch/arm64/include/asm/irq.h:6:39: warning: its scope is only this
> > definition or declaration, which is probably not what you want
> > [enabled by default]
> > ./arch/arm64/include/asm/irq.h:8:54: warning: ‘struct pt_regs’
> > declared inside parameter list [enabled by default]
> >  extern void set_handle_irq(void (*handle_irq)(struct pt_regs *));
> > 
> 
> I would consider this a (minor) bug in asm/irq.h. If you don't mind,
> please submit a patch to add a line with 'struct pt_regs;' to
> asm/irq.h.

A better question is: why is a modern driver using asm/irq.h in the
first place.

We used to include that file when platforms defined IRQ numbers
statically, but modern platforms don't do that, so it shouldn't be
required anymore.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
