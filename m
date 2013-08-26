Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3HZJcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 05:32:46 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:35236 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3HZJco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 05:32:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130824001345.GD14810@roeck-us.net>
References: <20130820192650.GA19470@srcf.ucam.org>
	<6438184.2yT2NMB1CE@vostro.rjw.lan>
	<20130821233942.GA21502@srcf.ucam.org>
	<1810269.JOHnJ0H7P9@vostro.rjw.lan>
	<20130822000306.GA21785@srcf.ucam.org>
	<1377300343.5259.84.camel@dvhart-mobl4.amr.corp.intel.com>
	<20130823233805.GA1801@srcf.ucam.org>
	<1377301548.5259.91.camel@dvhart-mobl4.amr.corp.intel.com>
	<20130824001345.GD14810@roeck-us.net>
Date: Mon, 26 Aug 2013 11:32:44 +0200
Message-ID: <CACRpkdb-qwDrKUp4+5OzPQ_tJPGB4B69GmO__i-KwjFTETSYqw@mail.gmail.com>
Subject: Re: ACPI vs Device Tree - moving forward
From: Linus Walleij <linus.walleij@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 2:13 AM, Guenter Roeck <linux@roeck-us.net> wrote:

> Did the group conclude that the idea of FDT augmenting ACPI is not feasible ?

I don't think anyone really knows. For example: how to specify a few
config options through a FDT augmented ACPI system is trivial. Passing
system-wide resources such as clocks, regulators, pin control handles,
GPIOs, interrupts and DMA channels is a criss-cross operation and
nobody knows if that will work because nobody tried to hash out
the details of.

> If not, the key question for me is how to implement it, and how to handle
> all its little problems.

It seems like we are in the "teenagers talking about sex" situation,
everybody is talking about it but nobody is really doing it.
Which makes it all pretty theoretical.

> If yes, the key question for me is how to handle all the drivers which
> assume fdt-style properties, and how to express all that information in ACPI
> in a way which does not require a substantial driver rewrite (and, as you point
> out, how that data would be described in ACPI consistently across multiple
> vendors).

For GPIO we have this:

drivers/gpio/gpiolib-of.c
drivers/gpio/gpiolib-acpi.c

So one thing is clear: for this resource we're going to have two
implementations.

Yours,
Linus Walleij
