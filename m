Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548AbaI3Up7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:45:59 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:54308 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaI3Up5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:45:57 -0400
MIME-Version: 1.0
In-Reply-To: <542A3593.4020108@gmail.com>
References: <542A3593.4020108@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 30 Sep 2014 14:45:37 -0600
Message-ID: <CAErSpo7BkXDHOZwHzwEu2BN3=39xFwQOyrjgVo6afWKMsnYT=A@mail.gmail.com>
Subject: Re: [PATCH 0/4] Driver for talking to PLX PEX8xxx PCIe switch over I2C
To: Rajat Jain <rajatxjain@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>,
        Wolfram Sang <wsa@the-dreams.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Wolfram]

On Mon, Sep 29, 2014 at 10:46 PM, Rajat Jain <rajatxjain@gmail.com> wrote:
> Most of the PLX PCI Express switches (and also switches from other vendors such
> IDT) provide an I2C based secondary interface to access and program the switch.
> This can be used to program the switch in situations where the PCIe interface
> may not be suitable, or even available. (For instance, we may need to program
> the device in a particular fashion before we even begin enumerating on the PCI,
> or to even enable the PCIe interface of the device). More information on
> usecases and other details has been provided in the documentation being added
> as part of this patchset.
>
> This is a driver that allows talking to the PLX PEX8xxx family of PCIe switches
> over its I2C interface. Here are the patch descriptions:
>
> [Patch 1/4] - Adds the PEX8xxx driver that exports API calls to read / write.
> [Patch 2/4] - Adds a sysfs interface, to allow access to the switch.
> [Patch 3/4] - Adds the MAINTAINERS entry.
> [Patch 4/4] - Adds the documentation in Documentation/PCI/pex8xxx_i2c.txt
>
> Since this is a driver for a PCIe switch, I currently put it under /driver/pci/.
> I'm very open to suggestions for moving this around (Does introducing
> drivers/pci/switch/ seem any better?). Especially I can see that the
> drivers/pci/Kconfig appears under "Bus Options" in the main menu which does not
> look like the right place for this driver. I am looking for suggestions here.

Definitely interesting work.  I have no idea where to put it.  It
doesn't have anything to do with PCI core services or structures, so
drivers/pci doesn't seem like the ideal place for it, but I don't have
any better ideas.  If it did end up under drivers/pci, I agree that a
drivers/pci/switch or something similar would probably be better than
having it directly in drivers/pci.

Maybe Wolfram or other I2C folks will have an idea.

> Rajat Jain (4):
>   pci: Add I2C driver for the PLX PEX8xxx PCIe switch
>   pci/pex8xxx: Add sysfs interface for userspace access.
>   MAINTAINERS: Add new device driver entry for PEX pex8xxx
>   Documentation: Add documentation for the PCI switch PEX8xxx I2C
>     driver
>
>  Documentation/PCI/pex8xxx_i2c.txt |  134 +++++++++
>  MAINTAINERS                       |    7 +
>  drivers/pci/Kconfig               |   13 +
>  drivers/pci/Makefile              |    2 +
>  drivers/pci/pex8xxx_i2c.c         |  538 +++++++++++++++++++++++++++++++++++++
>  include/linux/i2c/pex8xxx_i2c.h   |   36 +++
>  6 files changed, 730 insertions(+)
>  create mode 100644 Documentation/PCI/pex8xxx_i2c.txt
>  create mode 100644 drivers/pci/pex8xxx_i2c.c
>  create mode 100644 include/linux/i2c/pex8xxx_i2c.h
>
> --
> 1.7.9.5
>
