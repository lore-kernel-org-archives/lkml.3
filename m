Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaJTKcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:32:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58657 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753054AbaJTKcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:32:23 -0400
Date: Mon, 20 Oct 2014 11:32:13 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Lyra Zhang <zhang.lyra@gmail.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "artagnon@gmail.com" <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>
Subject: Re: [PATCH v2 5/5] tty/serial: Add earlycon support for Spreadtrum
 serial driver
Message-ID: <20141020103213.GA26235@leverpostej>
References: <1413539665-11484-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1413539665-11484-6-git-send-email-chunyan.zhang@spreadtrum.com>
 <20141017130354.GC5587@leverpostej>
 <CAAfSe-sJxVZ46aQfGyOh+eTepiXwPhQPQCX-3yZ0Ew30n+oP+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfSe-sJxVZ46aQfGyOh+eTepiXwPhQPQCX-3yZ0Ew30n+oP+w@mail.gmail.com>
Thread-Topic: [PATCH v2 5/5] tty/serial: Add earlycon support for Spreadtrum
 serial driver
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 08:27:24AM +0100, Lyra Zhang wrote:
> 2014-10-17 21:03 GMT+08:00 Mark Rutland <mark.rutland@arm.com>:
> > On Fri, Oct 17, 2014 at 10:54:25AM +0100, Chunyan Zhang wrote:
> >> Add serial driver for spreadtrum sharkl platform with earlycon
> >> support at first.
> >>
> >> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> >> ---
> >>  drivers/tty/serial/Kconfig       |   24 ++++++++++++++
> >>  drivers/tty/serial/Makefile      |    1 +
> >>  drivers/tty/serial/sprd-serial.c |   64 ++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 89 insertions(+)
> >>  create mode 100644 drivers/tty/serial/sprd-serial.c
> >>
> >> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> >> index 26cec64..33b8f90 100644
> >> --- a/drivers/tty/serial/Kconfig
> >> +++ b/drivers/tty/serial/Kconfig
> >> @@ -113,6 +113,30 @@ config SERIAL_SB1250_DUART_CONSOLE
> >>
> >>         If unsure, say Y.
> >>
> >> +config SERIAL_SPRD
> >> +     tristate "Support for SPRD serial"
> >> +     depends on ARM || ARM64
> >> +     select SERIAL_CORE
> >> +     help
> >> +          This enables the driver for the Spreadtrum's serial.
> >> +
> >> +config SERIAL_SPRD_NR
> >> +        int "Maximum number of sprd serial ports"
> >> +        depends on SERIAL_SPRD
> >> +        default "4"
> >
> > This is not used below.
> >
> Ok, I'll remove it in v3.
> 
> >> +
> >> +config SERIAL_SPRD_CONSOLE
> >> +        bool "SPRD UART console support"
> >> +        depends on SERIAL_SPRD=y
> >> +        select SERIAL_CORE_CONSOLE
> >> +     select SERIAL_EARLYCON
> >> +        help
> >> +       Support for early debug console using Spreadtrum's serial. This enables
> >> +       the console before standard serial driver is probed. This is enabled
> >> +       with "earlycon=serial_sprd" on the kernel command line. The console is
> >> +       enabled when early_param is processed.
> >
> > There only appears to be an earlycon driver, and not "standard serial
> > driver".
> >
> > What happens after earlycon?
> >
> > Surely there should be a real driver to take ownership of the UART?
> >
> > As far as I can see it won't be possible to boot your platform to a
> > prompt, because earlycon will have gone before that.
> >
> > Thanks,
> > Mark.
> >
> 
> We are planed to add standard serial driver after this patch-set is approved.
> In the first patch we contribute to the upstream, I'd like to add
> architecture related code of
> Spreadtrum's Sharkl, and then we will add more functions about Sharkl3
> SoC step by step.

The series is simple enough that the only issues I've noticed are minor.
I'm happy with that.

However, the absence of a real UART driver means that this series alone
is not sufficient to boot your platform to a usable state. Given that
the rest of the series is simply plumbing, I think it would make sense
for that to accompany a full UART driver (or perhaps some other I/O like
ethernet) such that it's possible to interact with the platform.

Thanks,
Mark.
