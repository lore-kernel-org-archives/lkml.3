Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab3BUONx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 09:13:53 -0500
Received: from tundra.namei.org ([65.99.196.166]:33914 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab3BUONv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 09:13:51 -0500
Date: Fri, 22 Feb 2013 01:03:29 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] Security subsystem updates for 3.9
Message-ID: <alpine.LRH.2.02.1302220058500.18199@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is basically a maintenance update for the TPM driver and EVM/IMA.

Please pull.


The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:
  Linus Torvalds (1):
        Linux 3.8

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

Andy Shevchenko (1):
      mpilib: use DIV_ROUND_UP and remove unused macros

Dmitry Kasatkin (14):
      evm: remove unused cleanup functions
      ima: set appraise status in fix mode only when xattr is fixed
      ima: remove enforce checking duplication
      ima: remove security.ima hexdump
      integrity: reduce storage size for ima_status and evm_status
      ima: move full pathname resolution to separate function
      ima: forbid write access to files with digital signatures
      ima: added policy support for 'security.ima' type
      digsig: remove unnecessary memory allocation and copying
      evm: add file system uuid to EVM hmac
      ima: add policy support for file system uuid
      ima: use new crypto_shash API instead of old crypto_hash
      ima: rename hash calculation functions
      ima: digital signature verification using asymmetric keys

James Morris (1):
      Merge tag 'v3.8-rc2' into next

Jason Gunthorpe (4):
      TPM: Issue TPM_STARTUP at driver load if the TPM has not been started
      TPM: Switch to __packed instead of __attribute__((packed))
      TPM: Work around buggy TPMs that block during continue self test
      TPM: Wait for TPM_ACCESS tpmRegValidSts to go high at startup

Kent Yoder (8):
      tpm: add documentation for sysfs interfaces
      tpm: rename vendor data to priv and provide an accessor
      tpm: STM i2c driver fixes
      tpm: rename STM driver to match other i2c drivers
      tpm_i2c_stm_st33: fix oops when i2c client is unavailable
      tpm_i2c_stm_st33: removed unused variables/code
      tpm_tis: check pnp_acpi_device return code
      tpm/ibmvtpm: build only when IBM pseries is configured

Mathias Leblanc (2):
      TPM: STMicroelectronics ST33 I2C KERNEL 3.x
      TPM: STMicroelectronics ST33 I2C BUILD STUFF

Mimi Zohar (5):
      ima: re-initialize IMA policy LSM info
      ima: rename FILE_MMAP to MMAP_CHECK
      ima: increase iint flag size
      ima: per hook cache integrity appraisal status
      ima: differentiate appraise status only for hook specific rules

Peter Huewe (8):
      char/tpm: Remove duplicated lookup table
      char/tpm: simplify duration calculation and eliminate smatch warning.
      char/tpm: Use true and false for bools
      char/tpm: Use struct dev_pm_ops for power management
      char/tpm/tpm_i2c_stm_st33: Don't use memcpy for one byte assignment
      char/tpm/tpm_i2c_stm_st33: Remove __devexit attribute
      char/tpm/tpm_i2c_stm_st33: remove dead assignment in tpm_st33_i2c_probe
      char/tpm/tpm_i2c_stm_st33: drop temporary variable for return value

Stefan Berger (3):
      tpm: Store TPM vendor ID
      tpm: Fix cancellation of TPM commands (polling mode)
      tpm: Fix cancellation of TPM commands (interrupt mode)

 Documentation/ABI/stable/sysfs-class-tpm |  185 +++++++
 Documentation/ABI/testing/ima_policy     |   10 +-
 drivers/char/tpm/Kconfig                 |   12 +-
 drivers/char/tpm/Makefile                |    1 +
 drivers/char/tpm/tpm.c                   |  114 ++--
 drivers/char/tpm/tpm.h                   |   52 +-
 drivers/char/tpm/tpm_acpi.c              |    8 +-
 drivers/char/tpm/tpm_atmel.c             |    7 +-
 drivers/char/tpm/tpm_i2c_infineon.c      |    7 +-
 drivers/char/tpm/tpm_i2c_stm_st33.c      |  887 ++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm_i2c_stm_st33.h      |   61 ++
 drivers/char/tpm/tpm_ibmvtpm.c           |   15 +-
 drivers/char/tpm/tpm_nsc.c               |    7 +-
 drivers/char/tpm/tpm_tis.c               |   64 ++-
 lib/digsig.c                             |   41 +-
 lib/mpi/mpi-internal.h                   |    4 -
 lib/mpi/mpicoder.c                       |    8 +-
 security/integrity/Kconfig               |   12 +
 security/integrity/Makefile              |    1 +
 security/integrity/digsig.c              |   11 +-
 security/integrity/digsig_asymmetric.c   |  115 ++++
 security/integrity/evm/Kconfig           |   13 +
 security/integrity/evm/evm.h             |    2 +-
 security/integrity/evm/evm_crypto.c      |    3 +
 security/integrity/evm/evm_main.c        |   10 +-
 security/integrity/evm/evm_secfs.c       |    6 -
 security/integrity/iint.c                |   10 +-
 security/integrity/ima/ima.h             |   21 +-
 security/integrity/ima/ima_api.c         |   27 +-
 security/integrity/ima/ima_appraise.c    |   92 +++-
 security/integrity/ima/ima_crypto.c      |   81 ++-
 security/integrity/ima/ima_init.c        |    3 +
 security/integrity/ima/ima_main.c        |  133 ++---
 security/integrity/ima/ima_policy.c      |  138 ++++-
 security/integrity/integrity.h           |   62 ++-
 35 files changed, 1914 insertions(+), 309 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-tpm
 create mode 100644 drivers/char/tpm/tpm_i2c_stm_st33.c
 create mode 100644 drivers/char/tpm/tpm_i2c_stm_st33.h
 create mode 100644 security/integrity/digsig_asymmetric.c
