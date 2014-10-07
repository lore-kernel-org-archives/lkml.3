Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaJGRCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:02:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:32562 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbaJGRCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:02:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="396667994"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 0/7] TPM 2.0 support
Date: Tue,  7 Oct 2014 20:01:10 +0300
Message-Id: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
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

Jarkko Sakkinen (6):
  tpm: merge duplicate transmit_cmd() functions
  tpm: two-phase chip management functions
  tpm: clean up tpm_tis driver life-cycle
  tpm: TPM 2.0 commands
  tpm: TPM 2.0 sysfs attributes
  tpm: TPM 2.0 CRB Interface

Will Arthur (1):
  tpm: TPM 2.0 FIFO Interface

 Documentation/ABI/stable/sysfs-class-tpm2 |  69 ++++
 drivers/char/tpm/Kconfig                  |   9 +
 drivers/char/tpm/Makefile                 |   3 +-
 drivers/char/tpm/tpm-chip.c               | 184 ++++++++++
 drivers/char/tpm/tpm-dev.c                |   4 +-
 drivers/char/tpm/tpm-interface.c          | 201 ++++-------
 drivers/char/tpm/tpm-sysfs.c              |  23 +-
 drivers/char/tpm/tpm.h                    | 103 +++++-
 drivers/char/tpm/tpm2-cmd.c               | 543 ++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2-sysfs.c             | 314 +++++++++++++++++
 drivers/char/tpm/tpm_crb.c                | 329 ++++++++++++++++++
 drivers/char/tpm/tpm_i2c_atmel.c          |   5 -
 drivers/char/tpm/tpm_i2c_infineon.c       |  10 -
 drivers/char/tpm/tpm_i2c_nuvoton.c        |   5 -
 drivers/char/tpm/tpm_infineon.c           |   1 -
 drivers/char/tpm/tpm_tis.c                | 142 +++++---
 16 files changed, 1696 insertions(+), 249 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-tpm2
 create mode 100644 drivers/char/tpm/tpm-chip.c
 create mode 100644 drivers/char/tpm/tpm2-cmd.c
 create mode 100644 drivers/char/tpm/tpm2-sysfs.c
 create mode 100644 drivers/char/tpm/tpm_crb.c

-- 
2.1.0

