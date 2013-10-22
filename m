Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3JVABe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 20:01:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:41405 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab3JVAB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 20:01:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="422609601"
Message-ID: <5265C0C5.70905@linux.intel.com>
Date: Mon, 21 Oct 2013 17:03:17 -0700
From: Bin Gao <bin.gao@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] drivers/misc: add rawio framework and drivers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To read/write registers from a device is very important on embedded system,
especially SoC systems. Physically there could be different types of devices
based on bus tyes, e.g. PCI devices, I2C (slave)devices, I/O devices(memory
mapped), inter-processor devices, etc. Typically there are userland
tools from
PC Linux to access device registers, but on some embedded system initrd and
rootfs come with a minimal busybox and most useful userland tools are not
available. To add these tools back to rootfs is not convenient either.
What's more, on some systems with runtime pm enabled, reading/writing
registers
from a device which is in low power state will cause problems. For these
reasons, to have some tools/interfaces directly from kernel space via debug
fs seems to be easy, cheap and convenient.

These patchsets are designed to  achieve above goals to ease
device driver and kernel debugging on embedded systems.

Rawio provides a framework to read/write registers from a bus, including
pci, i2c, I/O device(memory mapped), etc. based on debug fs.
Rawio bus drivers implement the read/write operation on a specific bus
on top of the rawio framework driver.
Currently only three bus drivers are available: pci, iomem and i2c.
But it's extremely easy to add more drivers on top of the framework
if needed.

 drivers/misc/Kconfig             |   1 +
 drivers/misc/Makefile            |   1 +
 drivers/misc/rawio/Kconfig       |  59 +++++
 drivers/misc/rawio/Makefile      |   4 +
 drivers/misc/rawio/rawio.c       | 514
+++++++++++++++++++++++++++++++++++++++
 drivers/misc/rawio/rawio_i2c.c   | 224 +++++++++++++++++
 drivers/misc/rawio/rawio_iomem.c | 401 ++++++++++++++++++++++++++++++
 drivers/misc/rawio/rawio_pci.c   | 235 ++++++++++++++++++
 include/linux/rawio.h            |  78 ++++++
 9 files changed, 1517 insertions(+)
 create mode 100644 drivers/misc/rawio/Kconfig
 create mode 100644 drivers/misc/rawio/Makefile
 create mode 100644 drivers/misc/rawio/rawio.c
 create mode 100644 drivers/misc/rawio/rawio_i2c.c
 create mode 100644 drivers/misc/rawio/rawio_iomem.c
 create mode 100644 drivers/misc/rawio/rawio_pci.c
 create mode 100644 include/linux/rawio.h
