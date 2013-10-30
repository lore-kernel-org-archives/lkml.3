Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3J3Jem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:34:42 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:39669 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab3J3Jel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:34:41 -0400
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
Date: Wed, 30 Oct 2013 10:32:57 +0100
Message-Id: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103009-0542-0000-0000-000006E799F1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GenWQE device is a PCIe card used to acclerate different tasks.
Since it is configurable, it can be adjusted to different purposes.
Our initial task for the card is to do zlib style compression/decompression
RFC1950, RFC1951, and RFC1952.

I kindly ask for your feedback on the code, such that I can do
any change which helps me to get it integrated smoothly.

Frank Haverkamp (1):
  Generic WorkQueue Engine (GenWQE) device driver (v4)

 Documentation/ABI/testing/debugfs-driver-genwqe |   57 +
 Documentation/ABI/testing/sysfs-driver-genwqe   |   46 +
 drivers/misc/Kconfig                            |    1 +
 drivers/misc/Makefile                           |    1 +
 drivers/misc/genwqe/Kconfig                     |   23 +
 drivers/misc/genwqe/Makefile                    |    8 +
 drivers/misc/genwqe/card_base.c                 | 1238 +++++++++++++++++++
 drivers/misc/genwqe/card_base.h                 |  569 +++++++++
 drivers/misc/genwqe/card_ddcb.c                 | 1380 +++++++++++++++++++++
 drivers/misc/genwqe/card_ddcb.h                 |  188 +++
 drivers/misc/genwqe/card_debugfs.c              |  566 +++++++++
 drivers/misc/genwqe/card_dev.c                  | 1499 +++++++++++++++++++++++
 drivers/misc/genwqe/card_sysfs.c                |  306 +++++
 drivers/misc/genwqe/card_utils.c                |  983 +++++++++++++++
 drivers/misc/genwqe/genwqe_driver.h             |   75 ++
 include/linux/genwqe/genwqe_card.h              |  559 +++++++++
 16 files changed, 7499 insertions(+), 0 deletions(-)
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
 create mode 100644 include/linux/genwqe/genwqe_card.h

