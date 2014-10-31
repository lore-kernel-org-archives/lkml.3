Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbaJaShw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 14:37:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:59043 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaJaShv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 14:37:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,295,1413270000"; 
   d="scan'208";a="629168575"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        josh.triplett@intel.com, christophe.ricard@gmail.com,
        jason.gunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v4 0/6] TPM 2.0 support
Date: Fri, 31 Oct 2014 20:37:32 +0200
Message-Id: <1414780658-3507-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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

Jarkko Sakkinen (5):
  tpm: merge duplicate transmit_cmd() functions
  tpm: two-phase chip management functions
  tpm: fix multiple race conditions in tpm_ppi.c
  tpm: TPM 2.0 baseline support
  tpm: TPM 2.0 CRB Interface

Will Arthur (1):
  tpm: TPM 2.0 FIFO Interface

 drivers/char/tpm/Kconfig            |   9 +
 drivers/char/tpm/Makefile           |   3 +-
 drivers/char/tpm/tpm-chip.c         | 203 +++++++++++++
 drivers/char/tpm/tpm-interface.c    | 221 +++-----------
 drivers/char/tpm/tpm-sysfs.c        |  23 +-
 drivers/char/tpm/tpm.h              |  97 ++++++-
 drivers/char/tpm/tpm2-cmd.c         | 565 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_atmel.c        |  12 +-
 drivers/char/tpm/tpm_crb.c          | 334 +++++++++++++++++++++
 drivers/char/tpm/tpm_i2c_atmel.c    |  33 +--
 drivers/char/tpm/tpm_i2c_infineon.c |  37 +--
 drivers/char/tpm/tpm_i2c_nuvoton.c  |  44 +--
 drivers/char/tpm/tpm_i2c_stm_st33.c |  38 +--
 drivers/char/tpm/tpm_ibmvtpm.c      |  17 +-
 drivers/char/tpm/tpm_infineon.c     |  29 +-
 drivers/char/tpm/tpm_nsc.c          |  14 +-
 drivers/char/tpm/tpm_ppi.c          | 136 +++++----
 drivers/char/tpm/tpm_tis.c          | 165 ++++++-----
 drivers/char/tpm/xen-tpmfront.c     |  14 +-
 19 files changed, 1527 insertions(+), 467 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-chip.c
 create mode 100644 drivers/char/tpm/tpm2-cmd.c
 create mode 100644 drivers/char/tpm/tpm_crb.c

-- 
2.1.0

