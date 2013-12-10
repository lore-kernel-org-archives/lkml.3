Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab3LJUAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:00:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56882 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3LJUAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:00:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@kernel.org>
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running without PCI on ARM64
Date: Tue, 10 Dec 2013 21:00:20 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Mark Rutland <Mark.Rutland@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Hanjun Guo <hanjun.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org> <201312100428.52588.arnd@arndb.de> <20131210192217.GI11468@sirena.org.uk>
In-Reply-To: <20131210192217.GI11468@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201312102100.20570.arnd@arndb.de>
X-Provags-ID: V02:K0:0c5CLNCKrAp1/Kr6fAsB5uK9o6Yp7KMFbF0tkVmfkWS
 d0zXckUf6ZTGQbo6obHUfVl2xTaopx8ExSB9/OXH/pEmVo24F8
 Y/1/rdOf8klQSrBmhxI8P6RzWws6NEkfTkZcsamhDyClqF6RI4
 ktufVdLQjVZzJdaMCKIlJKKEEooZLZT3p18Nv1Qi0Cs/NcLkP+
 ak1B9mB++qrvQQ5u6g7kFqos0xtBFbpJIODODGGPwQ/CZ7PbCc
 VmNT4ZVLqGTurp9fOKBv+UQpauxcMvEvoOP0ox0bv7ehdj7etL
 DaY/aK7oU3BL3LOBZh6ea/M3/LNIg9ZG3Ec0SYVN3Y1BvCQgZx
 w0r8l6Foc7kNCUXwjwlc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 December 2013, Mark Brown wrote:
> On Tue, Dec 10, 2013 at 04:28:52AM +0100, Arnd Bergmann wrote:
> > On Monday 09 December 2013, Matthew Garrett wrote:
> 
> > > People are trying to deploy ACPI-based embedded x86, and most of the 
> > > ACPI/DT integration discussion seems to have been based on the idea that 
> > > this is a worthwhile thing to support. If we're not interested in doing 
> > > so then we should probably make that a whole kernel decision rather than 
> > > a per architecture one.
> 
> > Well, except it's not an architecture independent decision. An embedded
> > x86 SoC will still be very much like a PC, just with a few things added
> > in and some other bits left out, and you can already describe it mostly
> 
> It's not just the SoC, it's also the rest of the board.  The patches the
> Intel guys are submitting at the minute are mainly for the off-SoC
> devices at least as far as I noticed.  This'll impact anyone who ends up
> using ACPI, we need to at least pay attention to what's going on there.

Yes, but I'm not that worried about off-soc stuff, which tends to be
off the much simpler variety: a few MMIO or PIO registers, IRQs,
GPIOs or (with ACPI-5.0) devices on i2c and spi buses.

> > with plain ACPI-5.0. Also, there are only a couple of different non-PC style
> > devices that Intel is integrating into their SoCs, so we're talking
> > about a few dozen device drivers here.
> 
> It's going to be way more than that for the whole system, and you can't
> assume that all the system integrators are going to pay a blind bit of
> notice to the reference designs.  Some will just clone them but others
> will bin them and do their own thing.

They won't be able to change the on-chip components for obvious reasons.

	Arnd
