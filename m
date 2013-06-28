Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab3F1Ta6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:30:58 -0400
Received: from mxout1.idt.com ([157.165.5.25]:42267 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab3F1Ta5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:30:57 -0400
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jun 2013 15:30:57 EDT
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@Prodrive.nl>,
        Micha Nelissen <micha.nelissen@Prodrive.nl>,
        Stef van Os <stef.van.os@Prodrive.nl>, Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 0/7] rapidio: modularize rapidio subsystem
Date: Fri, 28 Jun 2013 15:18:49 -0400
Message-Id: <1372447136-5751-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches modifies kernel RapidIO subsystem to enable build
and use of its components as loadable kernel modules. Combinations of statically
linked and modular components are also supported.

For this release full RapidIO subsystem modularization is implemented for
x86-based platforms. For PowerPC platforms (mostly MPC85xx) RapidIO core and
the mport driver (fsl_rio.c) still have only statically linked build option
while other components (enumerator and switch drivers) can be built as kernel
modules. This is not a significant limitation for embedded PowerPC platforms
because they use on-chip RapidIO controllers. For PowerPC platforms that may use
an external PCIe RapidIO controller (e.g. Tsi721) an additional patch will be
provided later.

This set of patches is based on the current linux-next code tree that contains
previously submitted patches for modularized enumeration/discovery method.

Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Cc: Stef van Os <stef.van.os@Prodrive.nl>
Cc: Jean Delvare <jdelvare@suse.de>

Alexandre Bounine (7):
  rapidio: convert switch drivers to modules
  rapidio/rionet: rework driver initialization and removal
  rapidio: update enumerator registration mechanism
  rapidio/tsi721: convert to modular mport driver
  rapidio: add modular build option for the subsystem core
  rapidio: add udev notification
  rapidio: documentation update

 Documentation/rapidio/rapidio.txt   |   98 ++++++-
 Documentation/rapidio/sysfs.txt     |    1 +
 arch/x86/Kconfig                    |    4 +-
 drivers/net/rionet.c                |  103 ++++++--
 drivers/rapidio/Kconfig             |    5 +
 drivers/rapidio/Makefile            |    4 +-
 drivers/rapidio/devices/Kconfig     |    2 +-
 drivers/rapidio/devices/Makefile    |    7 +-
 drivers/rapidio/devices/tsi721.c    |    9 +-
 drivers/rapidio/rio-driver.c        |   18 ++
 drivers/rapidio/rio-scan.c          |  172 +------------
 drivers/rapidio/rio-sysfs.c         |   31 +--
 drivers/rapidio/rio.c               |  490 ++++++++++++++++++++++++++++-------
 drivers/rapidio/rio.h               |   44 +---
 drivers/rapidio/switches/Kconfig    |   12 +-
 drivers/rapidio/switches/idt_gen2.c |   98 ++++++--
 drivers/rapidio/switches/idtcps.c   |   86 +++++--
 drivers/rapidio/switches/tsi568.c   |   71 +++++-
 drivers/rapidio/switches/tsi57x.c   |   81 +++++-
 include/asm-generic/vmlinux.lds.h   |    7 -
 include/linux/mod_devicetable.h     |   19 ++
 include/linux/rio.h                 |   82 +++---
 include/linux/rio_ids.h             |    2 -
 scripts/mod/devicetable-offsets.c   |    6 +
 scripts/mod/file2alias.c            |   20 ++
 25 files changed, 998 insertions(+), 474 deletions(-)

-- 
1.7.8.4

