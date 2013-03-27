Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab3C0PbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:31:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:24787 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab3C0PbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:31:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,920,1355126400"; 
   d="scan'208";a="308169896"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 00/11 V5] Add Client MEI bus and NFC device
Date: Wed, 27 Mar 2013 17:29:52 +0200
Message-Id: <1364398203-11159-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is take 5 on the MEI bus + NFC device patches

This patch set adds implementation of MEI CLIENT BUS abstraction
over MEI device, this allows standard Linux device drivers
to access functionality exposed by MEI device clients that was previously
available only to the user space through /dev/mei

The first exercises is to export the NFC radio

More information can be found under

Documentation/misc-devices/mei/mei-client-bus.txt

v4 -> v5:
	* Sanitize mei_cl_bus.h by removing the licensing terms.
	* Removed uuid field from the device_id structure as it's redundant.
	* Added the device_id structure to mod_devicetable.h and modified file2alias.c accordingly.
	* Added a modalias sysfs attribute and a uevent routine, allowing for module autoloading on the MEI bus.
	* Added a Documentation/ABI/testing/sysfs-bus-mei entry for documenting the modalias sysfs attribute.

v3 -> v4:
	* The bus is named mei client bus
- Renames:
        * mei_bus_driver to mei_cl_driver
        * mei_bus_device to mei_cl_device
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


Samuel Ortiz (11):
  mei: bus: Initial MEI Client bus type implementation
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

 Documentation/ABI/testing/sysfs-bus-mei           |   7 +
 Documentation/misc-devices/mei/mei-client-bus.txt | 135 ++++++
 drivers/misc/mei/Kconfig                          |   8 +
 drivers/misc/mei/Makefile                         |   3 +
 drivers/misc/mei/bus.c                            | 496 ++++++++++++++++++++++
 drivers/misc/mei/client.c                         |   4 +
 drivers/misc/mei/init.c                           |   3 +
 drivers/misc/mei/interrupt.c                      |   2 +
 drivers/misc/mei/main.c                           |  13 +
 drivers/misc/mei/mei_dev.h                        |  99 ++++-
 drivers/misc/mei/nfc.c                            | 458 ++++++++++++++++++++
 drivers/misc/mei/nfc.h                            | 141 ++++++
 drivers/misc/mei/pci-me.c                         |   1 -
 include/linux/mei_cl_bus.h                        |  41 ++
 include/linux/mod_devicetable.h                   |   9 +
 scripts/mod/devicetable-offsets.c                 |   3 +
 scripts/mod/file2alias.c                          |  12 +
 17 files changed, 1433 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-bus-mei
 create mode 100644 Documentation/misc-devices/mei/mei-client-bus.txt
 create mode 100644 drivers/misc/mei/bus.c
 create mode 100644 drivers/misc/mei/nfc.c
 create mode 100644 drivers/misc/mei/nfc.h
 create mode 100644 include/linux/mei_cl_bus.h

-- 
1.7.11.7

