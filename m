Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaI3EqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:46:00 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41820 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaI3Ep5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:45:57 -0400
Message-ID: <542A3593.4020108@gmail.com>
Date: Mon, 29 Sep 2014 21:46:11 -0700
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org
CC: rajatjain@juniper.net, groeck@juniper.net
Subject: [PATCH 0/4] Driver for talking to PLX PEX8xxx PCIe switch over I2C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the PLX PCI Express switches (and also switches from other vendors such
IDT) provide an I2C based secondary interface to access and program the switch.
This can be used to program the switch in situations where the PCIe interface
may not be suitable, or even available. (For instance, we may need to program
the device in a particular fashion before we even begin enumerating on the PCI,
or to even enable the PCIe interface of the device). More information on
usecases and other details has been provided in the documentation being added
as part of this patchset.

This is a driver that allows talking to the PLX PEX8xxx family of PCIe switches
over its I2C interface. Here are the patch descriptions:

[Patch 1/4] - Adds the PEX8xxx driver that exports API calls to read / write.
[Patch 2/4] - Adds a sysfs interface, to allow access to the switch.
[Patch 3/4] - Adds the MAINTAINERS entry.
[Patch 4/4] - Adds the documentation in Documentation/PCI/pex8xxx_i2c.txt

Since this is a driver for a PCIe switch, I currently put it under /driver/pci/.
I'm very open to suggestions for moving this around (Does introducing
drivers/pci/switch/ seem any better?). Especially I can see that the
drivers/pci/Kconfig appears under "Bus Options" in the main menu which does not
look like the right place for this driver. I am looking for suggestions here.

Looking forward to comments,

Thanks,

Rajat

Rajat Jain (4):
  pci: Add I2C driver for the PLX PEX8xxx PCIe switch
  pci/pex8xxx: Add sysfs interface for userspace access.
  MAINTAINERS: Add new device driver entry for PEX pex8xxx
  Documentation: Add documentation for the PCI switch PEX8xxx I2C
    driver

 Documentation/PCI/pex8xxx_i2c.txt |  134 +++++++++
 MAINTAINERS                       |    7 +
 drivers/pci/Kconfig               |   13 +
 drivers/pci/Makefile              |    2 +
 drivers/pci/pex8xxx_i2c.c         |  538 +++++++++++++++++++++++++++++++++++++
 include/linux/i2c/pex8xxx_i2c.h   |   36 +++
 6 files changed, 730 insertions(+)
 create mode 100644 Documentation/PCI/pex8xxx_i2c.txt
 create mode 100644 drivers/pci/pex8xxx_i2c.c
 create mode 100644 include/linux/i2c/pex8xxx_i2c.h

-- 
1.7.9.5

