Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbaKJMuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:50:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:2901 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbaKJMuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:50:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,352,1413270000"; 
   d="scan'208";a="619935695"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v6 00/10] TPM 2.0 support
Date: Mon, 10 Nov 2014 14:49:44 +0200
Message-Id: <1415623794-6090-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set enables TPM2 protocol and provides drivers for FIFO and
CRB interfaces.

Major changes since v1:

- Improved struct tpm_chip life-cycle by taking advantage of devres
  API.
- Refined sysfs attributes as simple key-values thereby not repeating
  mistakes in TPM1 sysfs attributes.
- Documented functions in tpm-chip.c and tpm2-cmd.c.
- Documented sysfs attributes.

Major changes since v2:

- Lots of fixes in calling order in device drivers (thanks to Jason
  Gunthorpe for pointing these out!).
- Attach sysfs attributes to the misc device because it represents
  TPM device to the user space.

Major changes since v3:

- Disable sysfs attibutes for TPM 2.0 for until we can sort out the 
  best approach for them.
- Fixed all the style issues found with checkpatch.pl.

Major changes since v4:

- missing EXPORT_SYMBOL_GPL()
- own class for TPM devices used for TPM 2.0 devices and onwards.

Major changes since v5:

- Non-racy initialization for sysfs attributes using struct device's
  groups field.
- The class 'tpm' is used now for all TPM devices. For the first device
  node major MISC_MAJOR and minor TPM_MINOR is used in order to retain
  backwards compatability.

Jarkko Sakkinen (9):
  tpm: merge duplicate transmit_cmd() functions
  tpm: two-phase chip management functions
  tpm: fix multiple race conditions in tpm_ppi.c
  tpm: rename chip->dev to chip->pdev
  tpm: device class for tpm
  tpm: fix race condition with sysfs attributes
  tpm: TPM 2.0 baseline support
  tpm: TPM 2.0 CRB Interface
  tpm: TPM 2.0 sysfs attributes

Will Arthur (1):
  tpm: TPM 2.0 FIFO Interface

 Documentation/ABI/stable/sysfs-class-tpm2 |  57 +++
 drivers/char/tpm/Kconfig                  |   9 +
 drivers/char/tpm/Makefile                 |   3 +-
 drivers/char/tpm/tpm-chip.c               | 193 ++++++++++
 drivers/char/tpm/tpm-dev.c                |  72 ++--
 drivers/char/tpm/tpm-interface.c          | 264 +++++---------
 drivers/char/tpm/tpm-sysfs.c              |  46 +--
 drivers/char/tpm/tpm.h                    | 132 ++++++-
 drivers/char/tpm/tpm2-cmd.c               | 566 ++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2-sysfs.c             | 152 ++++++++
 drivers/char/tpm/tpm_atmel.c              |  25 +-
 drivers/char/tpm/tpm_crb.c                | 327 +++++++++++++++++
 drivers/char/tpm/tpm_i2c_atmel.c          |  49 +--
 drivers/char/tpm/tpm_i2c_infineon.c       |  43 +--
 drivers/char/tpm/tpm_i2c_nuvoton.c        |  68 ++--
 drivers/char/tpm/tpm_i2c_stm_st33.c       |  44 +--
 drivers/char/tpm/tpm_ibmvtpm.c            |  17 +-
 drivers/char/tpm/tpm_infineon.c           |  51 +--
 drivers/char/tpm/tpm_nsc.c                |  34 +-
 drivers/char/tpm/tpm_ppi.c                | 136 ++++---
 drivers/char/tpm/tpm_tis.c                | 180 ++++++----
 drivers/char/tpm/xen-tpmfront.c           |  14 +-
 22 files changed, 1900 insertions(+), 582 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-tpm2
 create mode 100644 drivers/char/tpm/tpm-chip.c
 create mode 100644 drivers/char/tpm/tpm2-cmd.c
 create mode 100644 drivers/char/tpm/tpm2-sysfs.c
 create mode 100644 drivers/char/tpm/tpm_crb.c

-- 
2.1.0

