Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaIXJGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:06:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:44451 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbaIXJGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:06:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,587,1406617200"; 
   d="scan'208";a="596081544"
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: tpmdd-devel@lists.sourceforge.net
Cc: Peter Huewe <peterhuewe@gmx.de>, Marcel Selhorst <tpmdd@selhorst.net>,
        linux-kernel@vger.kernel.org, jgunthorpe@obsidianresearch.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 00/12] tpm: TPM2 support
Date: Wed, 24 Sep 2014 12:05:50 +0300
Message-Id: <1411549562-24242-1-git-send-email-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set enables TPM2 protocol and provides drivers for FIFO and
CRB interfaces.

Jarkko Sakkinen (8):
  tpm: prepare TPM driver for adding TPM2 support
  tpm: TPM2 support for tpm_pcr_read()
  tpm: TPM2 support for tpm_do_selftest()
  tpm: added tpm2_get_tpm_pt()
  tpm: TPM2 support for tpm_pcr_extend()
  tpm: TPM2 support for tpm_get_random().
  tpm: Driver for TPM 2.0 CRB Interface
  tpm: TPM2 sysfs attributes

Will Arthur (4):
  tpm: TPM2 support for tpm_calc_ordinal_durations()
  tpm: TPM2 support for tpm_startup()
  tpm: TPM2 support for tpm_gen_interrupt().
  tpm: TPM 2.0 FIFO Interface

 drivers/char/tpm/Kconfig         |   9 +
 drivers/char/tpm/Makefile        |   3 +-
 drivers/char/tpm/tpm-chip.c      | 175 ++++++++++++++++
 drivers/char/tpm/tpm-interface.c | 160 +++++----------
 drivers/char/tpm/tpm.h           |  84 ++++++++
 drivers/char/tpm/tpm2-commands.c | 422 +++++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm2-sysfs.c    | 242 ++++++++++++++++++++++
 drivers/char/tpm/tpm2.h          | 108 ++++++++++
 drivers/char/tpm/tpm_crb.c       | 332 ++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_tis.c       |  53 ++++-
 10 files changed, 1463 insertions(+), 125 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-chip.c
 create mode 100644 drivers/char/tpm/tpm2-commands.c
 create mode 100644 drivers/char/tpm/tpm2-sysfs.c
 create mode 100644 drivers/char/tpm/tpm2.h
 create mode 100644 drivers/char/tpm/tpm_crb.c

-- 
2.1.0

