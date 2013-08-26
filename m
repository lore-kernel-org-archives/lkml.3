Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab3HZKu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:50:27 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:56334 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3HZKuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:50:25 -0400
Date: Mon, 26 Aug 2013 11:48:40 +0100
From: Graeme Gregory <graeme.gregory@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Darren Hart <dvhart@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ACPI vs Device Tree - moving forward
Message-ID: <20130826104840.GF31554@xora-yoga.xora.org.uk>
References: <20130820192650.GA19470@srcf.ucam.org>
 <6438184.2yT2NMB1CE@vostro.rjw.lan>
 <20130821233942.GA21502@srcf.ucam.org>
 <1810269.JOHnJ0H7P9@vostro.rjw.lan>
 <20130822000306.GA21785@srcf.ucam.org>
 <1377300343.5259.84.camel@dvhart-mobl4.amr.corp.intel.com>
 <20130823233805.GA1801@srcf.ucam.org>
 <1377301548.5259.91.camel@dvhart-mobl4.amr.corp.intel.com>
 <20130824001345.GD14810@roeck-us.net>
 <CACRpkdb-qwDrKUp4+5OzPQ_tJPGB4B69GmO__i-KwjFTETSYqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb-qwDrKUp4+5OzPQ_tJPGB4B69GmO__i-KwjFTETSYqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 11:32:44AM +0200, Linus Walleij wrote:
> On Sat, Aug 24, 2013 at 2:13 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> 
> > Did the group conclude that the idea of FDT augmenting ACPI is not feasible ?
> 
> I don't think anyone really knows. For example: how to specify a few
> config options through a FDT augmented ACPI system is trivial. Passing
> system-wide resources such as clocks, regulators, pin control handles,
> GPIOs, interrupts and DMA channels is a criss-cross operation and
> nobody knows if that will work because nobody tried to hash out
> the details of.
> 
This bit the ACPI team at Linaro is currently trying to hash out.

> > If not, the key question for me is how to implement it, and how to handle
> > all its little problems.
> 
> It seems like we are in the "teenagers talking about sex" situation,
> everybody is talking about it but nobody is really doing it.
> Which makes it all pretty theoretical.
> 
> > If yes, the key question for me is how to handle all the drivers which
> > assume fdt-style properties, and how to express all that information in ACPI
> > in a way which does not require a substantial driver rewrite (and, as you point
> > out, how that data would be described in ACPI consistently across multiple
> > vendors).
> 
> For GPIO we have this:
> 
> drivers/gpio/gpiolib-of.c
> drivers/gpio/gpiolib-acpi.c
> 
> So one thing is clear: for this resource we're going to have two
> implementations.
> 
My personal feeling is we will need two of everything at the ACPI/FDT level,
but we can share commonality between the two subsystems in a more generic
level. One thing we have been looking at it allowing some devices in ACPI
and some in FDT type initialisations.

Within the Linaro ACPI team we are currently prototyping to try and settle
some of the questions raised.

I do not think that trying to get OEMs to put FDT fragments inside ACPI will
work, although that solution would certainly "solve" a lot of driver
implementation issues.

Graeme

