Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaJVQYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:24:25 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:39027 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbaJVQYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:24:22 -0400
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, josh.triplett@intel.com,
        christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 0/3] tpm: prepare for TPM2
Date: Wed, 22 Oct 2014 19:23:53 +0300
Message-Id: <1413995036-22497-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 37.136.210.236
X-SA-Exim-Mail-From: jarkko.sakkinen@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes two race conditions in the TPM subsystem:

* Two-phase initialization for struct tpm_chip so that device can
  initialize fully initialize before exposing itself to the user
  space. Also, in future TPM2 devices must be flagged before they
  can be registered.
* Machines where there are two TPM devices exposed by ACPI have
  a racy lookup for the PPI interface. This patch set fixes this
  issues

In addition, transmit_cmd() is renamed as tpm_transmit_cmd() and
made opaque so that separate command structure can be introduced
for TPM2.

Comments about v1:
* I think this could be pulled to 3.18 because this clearly fixes
  bugs in the current implementation.

Jarkko Sakkinen (3):
  tpm: merge duplicate transmit_cmd() functions
  tpm: two-phase chip management functions
  tpm: fix multiple race conditions in tpm_ppi.c

 drivers/char/tpm/Makefile           |   2 +-
 drivers/char/tpm/tpm-chip.c         | 190 ++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-dev.c          |   4 +-
 drivers/char/tpm/tpm-interface.c    | 201 ++++++------------------------------
 drivers/char/tpm/tpm-sysfs.c        |  23 +----
 drivers/char/tpm/tpm.h              |  32 +++---
 drivers/char/tpm/tpm_atmel.c        |  11 +-
 drivers/char/tpm/tpm_i2c_atmel.c    |  33 ++----
 drivers/char/tpm/tpm_i2c_infineon.c |  37 ++-----
 drivers/char/tpm/tpm_i2c_nuvoton.c  |  44 +++-----
 drivers/char/tpm/tpm_i2c_stm_st33.c |  22 ++--
 drivers/char/tpm/tpm_ibmvtpm.c      |  17 ++-
 drivers/char/tpm/tpm_infineon.c     |  13 ++-
 drivers/char/tpm/tpm_nsc.c          |  11 +-
 drivers/char/tpm/tpm_ppi.c          | 137 ++++++++++++++----------
 drivers/char/tpm/tpm_tis.c          |  94 ++++++++---------
 drivers/char/tpm/xen-tpmfront.c     |  14 +--
 17 files changed, 458 insertions(+), 427 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-chip.c

-- 
2.1.0

