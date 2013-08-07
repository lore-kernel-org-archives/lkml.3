Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab3HGVNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:13:01 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:57602 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933309Ab3HGVM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:12:58 -0400
Date: Wed, 7 Aug 2013 23:12:35 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, ciminaghi@gnudd.com,
        giancarlo.asnaghi@st.com, x86@kernel.org, mingo@redhat.com,
        linux@arm.linux.org.uk, tglx@linutronix.de, devicetree@vger.kernel.org
Subject: Re: [PATCH 00/26] STA2X11 devicetree support for amba/pci
Message-ID: <20130807211235.GA17863@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <52026AB5.80009@zytor.com>
References: <52026AB5.80009@zytor.com>
  <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[stripped list of issues from my original message follows]
>> Some of the problems he found are:
>> 
>>      * Passing a dtb to the kernel: we use a modified kexec at present
>>      * Passing correct irq numbers to the AMBA drivers
>>      * Switching to a new gpio driver with devicetree support
>>      * Writing a suitable dts: at present, a dts only exists for one
>>        of the STA2X11 based boards (Intel Northville).

> OK, so we have a real corner case here... which is a plugin board beyond
> which sits a bus normally used by fixed devices.  You are definitely
> correct that this is something that stresses current means of
> description to the breaking point.

Basically, it's an ARM chip with a PCI interface. So it offers USB, SATA,
Eth, i2c, spi, gpio, can etc to the x86 CPU.

> *Note there are some questions below that I would perfectly understand
> if you can't talk about publicly, if so, please contact me privately at
> my corporate address.*

Thanks. I'm not aware of any such issues at this point, though.
 
> However, the plugin board is very different from it being the main
> chipset, in no small part because you can boot without it.  I think this
> is the first time I have ever heard of a chip which can act both as a
> system chipset and a plugin card.

The main CPU in the Northville is an Atom, which IIUC has its own
memory controller -- and definitely a PCIe controller.  The Sta2x11
chip is connected to the PCIe bus, as both a slave and a master. It's
a busmaster for SATA, USB and something else, and equipped with a
PrimeCell PL080 as DMA engine for UART, I2C, SPI, MMC.

I'm aware it might be the first time this happens, but I also suspect
it will be common pretty soon: the industrial world wants I2C, UART,
SPI and GPIO, and bridging overt PCI to an external SoC is the right
approach, in my opinion.

> The mainboard case is relatively straightforward -- we should use ACPI 5
> (preferred for x86) or device tree to describe it.  My understanding
> from what you describe so far is that the only existing case is the
> Northville which is a mainboard.

There are a pair of such mainboards around, but what we developers
only have the Northville at this time.

And the evaluation board, which is a PCIe card. With the previous
platform_data-based approach I could plug two of them and access all
devices (2 * 4 UART, 2 * 3 I2C etc).

> For the plugin case, my thinking is that we probably do need a driver of
> some kind which at least contains the description of the board, as I
> assume one is not present in any kind of firmware on the board itself
> (*do any such boards or plans for them actually exist at this point?*)

The board exists as an evaluation board. But I see nothing against an
industrial-grade commercial offering, to give SPI, CAN and all the
rest to PC users that need them, as a single do-it-all cheap board.

> Ideally that driver should be (primarily?) a data object (an ACPI 5 SSDT
> or a DTB file) rather than open coded C.

Mostly so. It used to be platform data, to register devices for
drivers that already exist. Like we did for Ether and CAN: just
add the vendor/device pair and PCI support where missing.
 
> I believe ACPI 5 unlike device tree should be able to specify the
> dynamic properties that you are rightfully concerned with.

We'll try to get acquainted with that, but my wild guess is that
platform data is still simpler. I'm aware of the issues, and I'm not
insisting, though.
 
> Sorry if this feels like a wild goose chase to you.  Some of this
> problem domain is not very well handled by the current code, but we
> really have to draw a hard line to make sure it doesn't descend into
> unmaintainable chaos.

I understand. My impression of devicetree is exactly like that, I must
say.  What we have here is a very clean PCI enumeration of it all: we
only need to specify the mapping of GPIO pins (i.e. card-detect for
mmc) and DMA channels, as all the rest works by itself.

> We have similar issues with MinnowBoard and are trying to use that as a
> platform to figure out how a lot of these things need to be handled.

Interesting. I'll take a look. We were looking for a simple PC today
and found that very thing as a viable option.

Thank you for your feedback.  May I ask three more questions (this is
the 1st)?

Is the patch-set a viable approach for mainline, modulo serious evaluation
of the hairy IRQ details and the other bits?

Would it make sense to work on devicetree support in x86 bootloaders
(especially yours, let's ignore grub)?

thank you again
/alessandro
