Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120Ab3BHM2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 07:28:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:64689 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758100Ab3BHM2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 07:28:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,629,1355126400"; 
   d="scan'208";a="284477722"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 00/11 V2]  Add MEI BUS and NFC Device
Date: Fri,  8 Feb 2013 14:28:13 +0200
Message-Id: <1360326504-17041-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is take 2 on the MEI bus + NFC Device patches addressing Arnd's comments

This patch set adds implementation of MEI BUS abstraction
over MEI device, this allows standard Linux device drivers
to access functionality exposed by MEI device that was previously
available only to the user space through /dev/mei
 
The first exercises is to export the NFC radio
 
More information can be found under
Documentation/misc-devices/mei/mei-bus.txt


V2:
1. Rename mei_add_driver to mei_driver_register and mei_del_driver to
 mei_driver_unregister.
2. Do not inline the exported bus driver data setter and getter functions.
3. Include the bus ops pointers directly into mei_bus_client.
4. Move the mei_bus_init/exit call from probe to module init time.

Samuel Ortiz (11):
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

 Documentation/misc-devices/mei/mei-bus.txt |  137 ++++++++
 drivers/misc/mei/Kconfig                   |    7 +
 drivers/misc/mei/Makefile                  |    2 +
 drivers/misc/mei/bus.c                     |  483 ++++++++++++++++++++++++++++
 drivers/misc/mei/bus.h                     |   32 ++
 drivers/misc/mei/client.c                  |    4 +
 drivers/misc/mei/init.c                    |    1 +
 drivers/misc/mei/interrupt.c               |    2 +
 drivers/misc/mei/mei_dev.h                 |   79 +++++
 drivers/misc/mei/nfc.c                     |  456 ++++++++++++++++++++++++++
 drivers/misc/mei/nfc.h                     |  141 ++++++++
 drivers/misc/mei/pci-me.c                  |   23 ++-
 include/linux/mei_bus.h                    |  108 ++++++
 13 files changed, 1473 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/misc-devices/mei/mei-bus.txt
 create mode 100644 drivers/misc/mei/bus.c
 create mode 100644 drivers/misc/mei/bus.h
 create mode 100644 drivers/misc/mei/nfc.c
 create mode 100644 drivers/misc/mei/nfc.h
 create mode 100644 include/linux/mei_bus.h

-- 
1.7.4.4

