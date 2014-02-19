Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaBST1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:27:21 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33395 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaBST1T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:27:19 -0500
Date: Wed, 19 Feb 2014 19:26:46 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <ruiv.wang@gmail.com>
Subject: Re: [PATCH v6 4/4] i2c, i2c_imc: Add DIMM bus code
Message-ID: <20140219192646.1a62521d@alan.etchedpixels.co.uk>
In-Reply-To: <CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
References: <cover.1387588711.git.luto@amacapital.net>
	<15eccfa508fd0f55230c4274e3e968f91a123b73.1387588711.git.luto@amacapital.net>
	<20140219151626.GA13973@katana>
	<CALCETrVBPzGqaXbZVgUZMw7D5U5YnUMJOEsw1r=TceLYjJ39JA@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> example, lots of graphics drivers provide i2c busses, and those busses
> often contain eeproms, and, in theory, things should know that the
> eeprom is associated with a particular graphics port, for example.
> Unfortunately, the i2c core does not know that, things like
> decode-dimms will try to decode it, sensors-detect will scan graphics
> ports for motherboard sensors, etc.

ACPI does now try to describe what is on an i²c bus. We perhaps don't use
that information well but on a modern PC class box at least for onboard
devices most of the info is there for the munching.

> For extra fun, there could be drivers for different types of i2c_port.
>  One of them could be the "DIMM bus" driver, which would know how to
> probe the i2c adapter associated with a DIMM port.  Another could be
> the graphics port driver, which (maybe with some extra configuration
> hints from the graphics driver) could look for EDID-related things.

Busses are not necessarily that tidily organised. There isn't anything
saying you can't sneak multiple things on the same bus. In the graphics
case its unlikely but I wouldn't rule even that out for a display panel.
Once you get onto phones and tablets it seems anything goes 8)

> I wonder if this would fit in well with the device tree stuff, too --
> DT has ways to say "this node links to that one", right?

ACPI basically tries to describe the heirarchy of devices on the bus, but
as you say the "real" device can be a rambling mix of GPIO, I²C, SPI,
PCI (quite probably fake PCI at that) and other resources.

If there is a legitimate use case for poking around with memory dimm i2c
on these boards then really there needs to be a proper defined interface
for doing so that covers firmware and OS users.

Alan
