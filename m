Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaKCAGt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 19:06:49 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:64930 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaKCAGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 19:06:46 -0500
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, cascardo@linux.vnet.ibm.com
Cc: lidza.louina@gmail.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-serial@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 0/5] serial: jsm: Add support for the Digi Classic adapters
Date: Mon,  3 Nov 2014 01:06:25 +0100
Message-Id: <1414973190-10153-1-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The staging/dgnc and the serial/jsm drivers have the same origin. They
come from the same codebase however the jsm is the community adopted
version where the dgnc is kind of a direct submission from the Digi
company.

The recent commits to the jsm driver moved in the support for some of
the Neo cards from the dgnc driver. This series of patches continues
this trend by moving the support for the remaining Digi adapters (the
Classic line) from dgnc to the jsm driver.

This code is heavily based on the changes that were applied to the
jsm/dgnc code when the support for the Neo adapters was moved to the
mainline (git diff and LKML archives).

Since after this change is applied the staging/dgnc driver is obsolete
(no devices supported) it has been removed.

I do not own the Classic card therefore I was unable to test it. I did
my best being super-carefull during the implementation however it is
highly recommended that someone tests it.

Konrad Zapalowicz (5):
  drivers: serial: jsm: Add Classic board UART structure
  drivers: serial: jsm: Add the Classic board implementation
  drivers: serial: jsm: Enable support for Digi Classic adapters
  staging: dgnc: Remove driver in favor of serial/jsm driver
  drivers: serial: jsm: Remove FSF address from the file
    documentation/header

 MAINTAINERS                         |    7 -
 drivers/staging/Kconfig             |    2 -
 drivers/staging/Makefile            |    1 -
 drivers/staging/dgnc/Kconfig        |    6 -
 drivers/staging/dgnc/Makefile       |    8 -
 drivers/staging/dgnc/TODO           |   10 -
 drivers/staging/dgnc/dgnc_cls.c     | 1389 ---------------
 drivers/staging/dgnc/dgnc_cls.h     |   89 -
 drivers/staging/dgnc/dgnc_driver.c  |  757 ---------
 drivers/staging/dgnc/dgnc_driver.h  |  465 -----
 drivers/staging/dgnc/dgnc_kcompat.h |   64 -
 drivers/staging/dgnc/dgnc_mgmt.c    |  281 ---
 drivers/staging/dgnc/dgnc_mgmt.h    |   31 -
 drivers/staging/dgnc/dgnc_neo.c     | 1878 --------------------
 drivers/staging/dgnc/dgnc_neo.h     |  157 --
 drivers/staging/dgnc/dgnc_pci.h     |   75 -
 drivers/staging/dgnc/dgnc_sysfs.c   |  750 --------
 drivers/staging/dgnc/dgnc_sysfs.h   |   49 -
 drivers/staging/dgnc/dgnc_tty.c     | 3201 -----------------------------------
 drivers/staging/dgnc/dgnc_tty.h     |   42 -
 drivers/staging/dgnc/dgnc_types.h   |   33 -
 drivers/staging/dgnc/dgnc_utils.c   |   70 -
 drivers/staging/dgnc/dgnc_utils.h   |    7 -
 drivers/staging/dgnc/digi.h         |  415 -----
 drivers/staging/dgnc/dpacompat.h    |  115 --
 drivers/tty/serial/Kconfig          |    4 +-
 drivers/tty/serial/jsm/Makefile     |    2 +-
 drivers/tty/serial/jsm/jsm.h        |   71 +-
 drivers/tty/serial/jsm/jsm_cls.c    |  985 +++++++++++
 drivers/tty/serial/jsm/jsm_driver.c |  156 +-
 drivers/tty/serial/jsm/jsm_neo.c    |    5 -
 drivers/tty/serial/jsm/jsm_tty.c    |    7 +-
 32 files changed, 1174 insertions(+), 9958 deletions(-)
 delete mode 100644 drivers/staging/dgnc/Kconfig
 delete mode 100644 drivers/staging/dgnc/Makefile
 delete mode 100644 drivers/staging/dgnc/TODO
 delete mode 100644 drivers/staging/dgnc/dgnc_cls.c
 delete mode 100644 drivers/staging/dgnc/dgnc_cls.h
 delete mode 100644 drivers/staging/dgnc/dgnc_driver.c
 delete mode 100644 drivers/staging/dgnc/dgnc_driver.h
 delete mode 100644 drivers/staging/dgnc/dgnc_kcompat.h
 delete mode 100644 drivers/staging/dgnc/dgnc_mgmt.c
 delete mode 100644 drivers/staging/dgnc/dgnc_mgmt.h
 delete mode 100644 drivers/staging/dgnc/dgnc_neo.c
 delete mode 100644 drivers/staging/dgnc/dgnc_neo.h
 delete mode 100644 drivers/staging/dgnc/dgnc_pci.h
 delete mode 100644 drivers/staging/dgnc/dgnc_sysfs.c
 delete mode 100644 drivers/staging/dgnc/dgnc_sysfs.h
 delete mode 100644 drivers/staging/dgnc/dgnc_tty.c
 delete mode 100644 drivers/staging/dgnc/dgnc_tty.h
 delete mode 100644 drivers/staging/dgnc/dgnc_types.h
 delete mode 100644 drivers/staging/dgnc/dgnc_utils.c
 delete mode 100644 drivers/staging/dgnc/dgnc_utils.h
 delete mode 100644 drivers/staging/dgnc/digi.h
 delete mode 100644 drivers/staging/dgnc/dpacompat.h
 create mode 100644 drivers/tty/serial/jsm/jsm_cls.c

-- 
1.9.1

