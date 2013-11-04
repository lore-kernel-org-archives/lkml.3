Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab3KDRIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:08:18 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:58154 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3KDRIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:08:17 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 0/9] Generic WorkQueue Engine (GenWQE) device driver (v5)
Date: Mon,  4 Nov 2013 18:08:00 +0100
Message-Id: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110417-8372-0000-0000-000007A9DB4B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GenWQE device is a PCIe card used to acclerate different tasks.
Since it is configurable, it can be adjusted to different purposes.
Our initial task for the card is to do zlib style compression/decompression
RFC1950, RFC1951, and RFC1952.

I kindly ask for your feedback on the code, such that I can do
any change which helps me to get it integrated smoothly.

Frank Haverkamp (9):
  Generic WorkQueue Engine (GenWQE) device driver (v4)
  GenWQE: Remove option to select name
  GenWQE: Remove obsolete constants
  GenWQE: Rework comments
  GenWQE: Move comments
  GenWQE: Remove/rework module parameters
  GenWQE: Start using sysfs attribute groups
  GenWQE: Simplify sysfs buffer printouts
  GenWQE: Increment driver internal version number

 Documentation/ABI/testing/debugfs-driver-genwqe |   70 ++
 Documentation/ABI/testing/sysfs-driver-genwqe   |   55 +
 drivers/misc/Kconfig                            |    1 +
 drivers/misc/Makefile                           |    1 +
 drivers/misc/genwqe/Kconfig                     |   13 +
 drivers/misc/genwqe/Makefile                    |    8 +
 drivers/misc/genwqe/card_base.c                 | 1203 ++++++++++++++++++
 drivers/misc/genwqe/card_base.h                 |  570 +++++++++
 drivers/misc/genwqe/card_ddcb.c                 | 1380 +++++++++++++++++++++
 drivers/misc/genwqe/card_ddcb.h                 |  188 +++
 drivers/misc/genwqe/card_debugfs.c              |  579 +++++++++
 drivers/misc/genwqe/card_dev.c                  | 1499 +++++++++++++++++++++++
 drivers/misc/genwqe/card_sysfs.c                |  290 +++++
 drivers/misc/genwqe/card_utils.c                |  983 +++++++++++++++
 drivers/misc/genwqe/genwqe_driver.h             |   75 ++
 include/linux/genwqe/genwqe_card.h              |  547 +++++++++
 16 files changed, 7462 insertions(+), 0 deletions(-)
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

