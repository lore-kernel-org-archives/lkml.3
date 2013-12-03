Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3LCO2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:28:38 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:59494 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3LCO2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:28:37 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 0/6] Generic WorkQueue Engine (GenWQE) device driver (v8)
Date: Tue,  3 Dec 2013 15:28:17 +0100
Message-Id: <1386080903-27160-1-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120314-5024-0000-0000-000008047C32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GenWQE device is a PCIe card used to acclerate different tasks.
Since it is configurable, it can be adjusted to different purposes.
Our initial task for the card is to do zlib style compression/decompression
RFC1950, RFC1951, and RFC1952.

I kindly ask for your feedback on the code, such that I can do
any change which helps me to get it integrated smoothly.

The genwqe driver has a user-space interface described in
linux/include/genwqe/genwqe_card.h. There are several ioctls which can
be used to talk to the driver.

In addition there are some sysfs entries where information can be
exchanged with user-space. The sysfs interface is described in
Documentation/ABI/testing/sysfs-driver-genwqe.

Now the driver has also a debugfs interface. This is described in
Documentation/ABI/testing/debugfs-driver-genwqe.

Frank Haverkamp (6):
  GenWQE PCI support, health monitoring and recovery
  GenWQE Character device and DDCB queue
  GenWQE Utility functions
  GenWQE Debugfs interfaces
  GenWQE Sysfs interfaces
  GenWQE Enable driver

 Documentation/ABI/testing/debugfs-driver-genwqe |   70 ++
 Documentation/ABI/testing/sysfs-driver-genwqe   |   50 +
 drivers/misc/Kconfig                            |    1 +
 drivers/misc/Makefile                           |    1 +
 drivers/misc/genwqe/Kconfig                     |   13 +
 drivers/misc/genwqe/Makefile                    |    7 +
 drivers/misc/genwqe/card_base.c                 | 1203 +++++++++++++++++++
 drivers/misc/genwqe/card_base.h                 |  551 +++++++++
 drivers/misc/genwqe/card_ddcb.c                 | 1373 +++++++++++++++++++++
 drivers/misc/genwqe/card_ddcb.h                 |  188 +++
 drivers/misc/genwqe/card_debugfs.c              |  474 ++++++++
 drivers/misc/genwqe/card_dev.c                  | 1464 +++++++++++++++++++++++
 drivers/misc/genwqe/card_sysfs.c                |  260 ++++
 drivers/misc/genwqe/card_utils.c                |  949 +++++++++++++++
 drivers/misc/genwqe/genwqe_driver.h             |   74 ++
 include/uapi/linux/genwqe/genwqe_card.h         |  507 ++++++++
 16 files changed, 7185 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-driver-genwqe
 create mode 100644 Documentation/ABI/testing/sysfs-driver-genwqe
 create mode 100644 drivers/misc/genwqe/Kconfig
 create mode 100644 drivers/misc/genwqe/Makefile
 create mode 100644 drivers/misc/genwqe/card_base.c
 create mode 100644 drivers/misc/genwqe/card_base.h
 create mode 100644 drivers/misc/genwqe/card_ddcb.c
 create mode 100644 drivers/misc/genwqe/card_ddcb.h
 create mode 100644 drivers/misc/genwqe/card_debugfs.c
 create mode 100644 drivers/misc/genwqe/card_dev.c
 create mode 100644 drivers/misc/genwqe/card_sysfs.c
 create mode 100644 drivers/misc/genwqe/card_utils.c
 create mode 100644 drivers/misc/genwqe/genwqe_driver.h
 create mode 100644 include/uapi/linux/genwqe/genwqe_card.h

