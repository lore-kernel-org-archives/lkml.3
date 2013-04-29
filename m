Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab3D2CqC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 22:46:02 -0400
Received: from tundra.namei.org ([65.99.196.166]:50359 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab3D2CqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 22:46:00 -0400
Date: Mon, 29 Apr 2013 12:48:50 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem updates for 3.10
Message-ID: <alpine.LRH.2.02.1304291237210.6626@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some minor updates across the subsystem.

Note: I can't figure out why the patch from Lai Jiangshan shows up twice 
in the shortlog.  Everything checks out otherwise.



The following changes since commit c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1:

  Linux 3.9 (2013-04-28 17:36:01 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Casey Schaufler (1):
      Smack: include magic.h in smackfs.c

Chen Gang (1):
      drivers/char/tpm/tpm_ppi: use strlcpy instead of strncpy

Duncan Laurie (1):
      TPM: Retry SaveState command in suspend path

Igor Zhbanov (1):
      Fix NULL pointer dereference in smack_inode_unlink() and smack_inode_rmdir()

James Morris (3):
      Merge tag 'v3.9-rc2' into next
      Merge branch 'stage-for-3.10' of git://git.gitorious.org/smack-next/kernel into ra-next
      Merge branch 'tpmdd-04-17-13' of git://github.com/shpedoikal/linux into my-next

Jarkko Sakkinen (1):
      smack: SMACK_MAGIC to include/uapi/linux/magic.h

Jeff Layton (1):
      selinux: make security_sb_clone_mnt_opts return an error on context mismatch

Lai Jiangshan (2):
      tomoyo: use DEFINE_SRCU() to define tomoyo_ss
      tomoyo: use DEFINE_SRCU() to define tomoyo_ss

Mimi Zohar (1):
      ima: eliminate passing d_name.name to process_measurement()

Nicolas Schichan (1):
      seccomp: allow BPF_XOR based ALU instructions.

Peter Huewe (4):
      tpm/tpm_i2c_stm_st33: formatting and white space changes
      tpm: Add support for new Infineon I2C TPM (SLB 9645 TT 1.2 I2C)
      tpm/tpm_i2c_infineon.c: Add OF attributes type and name to the of_device_id table entries
      tpm/tpm_i2c_infineon: Add small comment about return value of __i2c_transfer

Rafal Krypa (3):
      Smack: prevent revoke-subject from failing when unseen label is written to it
      Smack: add missing support for transmute bit in smack_str_from_perm()
      Smack: add support for modification of existing rules

Sachin Kamat (1):
      tpm_i2c_stm_st33: Remove duplicate inclusion of header files

Shubhrajyoti Datta (1):
      char/tpm: Convert struct i2c_msg initialization to C99 format

 .../devicetree/bindings/i2c/trivial-devices.txt    |    2 +
 Documentation/security/Smack.txt                   |   11 +
 drivers/char/tpm/tpm.c                             |   31 ++-
 drivers/char/tpm/tpm.h                             |    3 +
 drivers/char/tpm/tpm_i2c_infineon.c                |  180 +++++++++++----
 drivers/char/tpm/tpm_i2c_stm_st33.c                |   64 +++---
 drivers/char/tpm/tpm_ppi.c                         |   14 +-
 fs/nfs/super.c                                     |    3 +-
 include/linux/security.h                           |   10 +-
 include/uapi/linux/magic.h                         |    1 +
 kernel/seccomp.c                                   |    2 +
 security/capability.c                              |    3 +-
 security/integrity/ima/ima_main.c                  |   14 +-
 security/security.c                                |    4 +-
 security/selinux/hooks.c                           |   39 +++-
 security/smack/smack.h                             |    5 -
 security/smack/smack_access.c                      |    2 +
 security/smack/smack_lsm.c                         |    4 +-
 security/smack/smackfs.c                           |  254 +++++++++++++-------
 security/tomoyo/tomoyo.c                           |    5 +-
 20 files changed, 450 insertions(+), 201 deletions(-)
