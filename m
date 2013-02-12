Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727Ab3BLShb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:37:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:24658 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933688Ab3BLSha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:37:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290195959"
From: Samuel Ortiz <sameo@linux.intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [char-misc-next 00/12 v3] Add MEI bus and NFC device
Date: Tue, 12 Feb 2013 19:36:50 +0100
Message-Id: <1360694222-27632-1-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is take 3 on the MEI bus + NFC device patches addressing Arnd and Greg
comments.

This patch set adds implementation of MEI BUS abstraction
over MEI device, this allows standard Linux device drivers
to access functionality exposed by MEI device that was previously
available only to the user space through /dev/mei

The first exercises is to export the NFC radio

More information can be found under
Documentation/misc-devices/mei/mei-bus.txt

v2 -> v3:
- Renames:
        * mei_device to mei_host. The mei_host pointers are still called *dev
          as I didn't want the first patch to get too fat. 
        * mei_bus_driver to mei_driver
        * mei_bus_client to mei_device

- mei_driver structure changes:
	* name pointer addition
	* MEI id table
	* probe routine now takes the probed MEI id as an argument

- mei-bus.txt update according to the mei_driver changes and the structure
  renaming.
- All exported symbols converted to EXPORT_SYMBOL_GPL.
- to_mei_* macros moved to bus.c
- drivers/misc/mei/bus.h deleted, all API definitions moved to mei_dev.h
- mei_device structure clenup: mei_host, mei_driver, and name fields removed.
- Fixed driver owner: mei_driver_register() is now a macro over
  __mei_driver_register, using THIS_MODULE as the default owner.

Samuel Ortiz (12):
  mei: Rename mei_device to mei_host
  mei: bus: Initial MEI bus type implementation
  mei: bus: Implement driver registration
  mei: bus: Initial implementation for I/O routines
  mei: bus: Add bus related structures to mei_cl
  mei: bus: Call bus routines from the core code
  mei: bus: Synchronous API for the data transmission
  mei: bus: Implement bus driver data setter/getter
  mei: nfc: Initial nfc implementation
  mei: nfc: Connect also the regular ME client
  mei: nfc: Add NFC device to the MEI bus
  mei: nfc: Implement MEI bus IO ops

 Documentation/misc-devices/mei/mei-bus.txt |  138 ++++++++
 drivers/misc/mei/Kconfig                   |    7 +
 drivers/misc/mei/Makefile                  |    2 +
 drivers/misc/mei/amthif.c                  |   30 +-
 drivers/misc/mei/bus.c                     |  475 ++++++++++++++++++++++++++++
 drivers/misc/mei/client.c                  |   40 +--
 drivers/misc/mei/client.h                  |   14 +-
 drivers/misc/mei/hbm.c                     |   28 +-
 drivers/misc/mei/hbm.h                     |   10 +-
 drivers/misc/mei/hw-me.c                   |   42 +--
 drivers/misc/mei/hw-me.h                   |    2 +-
 drivers/misc/mei/init.c                    |    7 +-
 drivers/misc/mei/interrupt.c               |   20 +-
 drivers/misc/mei/main.c                    |   14 +-
 drivers/misc/mei/mei_dev.h                 |  206 ++++++++----
 drivers/misc/mei/nfc.c                     |  459 +++++++++++++++++++++++++++
 drivers/misc/mei/nfc.h                     |  141 +++++++++
 drivers/misc/mei/pci-me.c                  |   31 +-
 drivers/misc/mei/wd.c                      |   20 +-
 include/linux/mei_bus.h                    |  112 +++++++
 20 files changed, 1627 insertions(+), 171 deletions(-)
 create mode 100644 Documentation/misc-devices/mei/mei-bus.txt
 create mode 100644 drivers/misc/mei/bus.c
 create mode 100644 drivers/misc/mei/nfc.c
 create mode 100644 drivers/misc/mei/nfc.h
 create mode 100644 include/linux/mei_bus.h

-- 
1.7.10.4

