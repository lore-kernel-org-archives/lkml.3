Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3JYKLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:11:32 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:60361 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3JYKLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:11:31 -0400
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        jsvogt@de.ibm.com, MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com,
        michael@ibmra.de, haver@linux.vnet.ibm.com
Subject: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v3)
Date: Fri, 25 Oct 2013 12:09:43 +0200
Message-Id: <1382695784-10127-1-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20131024100942.GA13614@kroah.com>
References: <20131024100942.GA13614@kroah.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102510-0542-0000-0000-000006DAEB32
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
  Generic WorkQueue Engine (GenWQE) device driver (v3)

 Documentation/ABI/testing/sysfs-driver-genwqe |  108 ++
 drivers/misc/Kconfig                          |    1 +
 drivers/misc/Makefile                         |    1 +
 drivers/misc/genwqe/Kconfig                   |   23 +
 drivers/misc/genwqe/Makefile                  |    8 +
 drivers/misc/genwqe/card_base.c               | 1305 ++++++++++++++++++++
 drivers/misc/genwqe/card_base.h               |  515 ++++++++
 drivers/misc/genwqe/card_ddcb.c               | 1377 +++++++++++++++++++++
 drivers/misc/genwqe/card_ddcb.h               |  159 +++
 drivers/misc/genwqe/card_dev.c                | 1614 +++++++++++++++++++++++++
 drivers/misc/genwqe/card_sysfs.c              |  645 ++++++++++
 drivers/misc/genwqe/card_utils.c              | 1032 ++++++++++++++++
 drivers/misc/genwqe/genwqe_driver.h           |   83 ++
 include/linux/genwqe/genwqe_card.h            |  697 +++++++++++
 14 files changed, 7568 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-genwqe
 create mode 100644 drivers/misc/genwqe/Kconfig
 create mode 100644 drivers/misc/genwqe/Makefile
 create mode 100644 drivers/misc/genwqe/card_base.c
 create mode 100644 drivers/misc/genwqe/card_base.h
 create mode 100644 drivers/misc/genwqe/card_ddcb.c
 create mode 100644 drivers/misc/genwqe/card_ddcb.h
 create mode 100644 drivers/misc/genwqe/card_dev.c
 create mode 100644 drivers/misc/genwqe/card_sysfs.c
 create mode 100644 drivers/misc/genwqe/card_utils.c
 create mode 100644 drivers/misc/genwqe/genwqe_driver.h
 create mode 100644 include/linux/genwqe/genwqe_card.h

