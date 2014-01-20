Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759AbaATNJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:09:06 -0500
Received: from tundra.namei.org ([65.99.196.166]:33573 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbaATNJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:09:03 -0500
Date: Tue, 21 Jan 2014 00:11:24 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem changes for 3.14
Message-ID: <alpine.LRH.2.02.1401210007390.27813@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes for this kernel include maintenance updates for Smack, SELinux 
(and several networking fixes), IMA and TPM.

Please pull.


The following changes since commit d8ec26d7f8287f5788a494f56e8814210f0e64be:

  Linux 3.13 (2014-01-19 18:40:07 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Casey Schaufler (5):
      Smack: Prevent the * and @ labels from being used in SMACK64EXEC
      Smack: Make the syslog control configurable
      Smack: change rule cap check
      Smack: Rationalize mount restrictions
      Smack: File receive audit correction

Chad Hanson (1):
      selinux: fix broken peer recv check

Fengguang Wu (2):
      tpm/tpm_i2c_atmel: fix coccinelle warnings
      tpm/tpm-sysfs: active_show() can be static

Geyslan G. Bem (1):
      selinux: fix possible memory leak

James Morris (3):
      Merge to v3.13-rc7 for prerequisite changes in the Xen code for TPM
      Merge branch 'master' of git://git.infradead.org/users/pcmoore/selinux into next
      Merge branch 'master' of git://git.infradead.org/users/pcmoore/selinux into next

Jarkko Sakkinen (1):
      smack: fix: allow either entry be missing on access/access2 check (v2)

Jason Gunthorpe (7):
      tpm: Pull everything related to /dev/tpmX into tpm-dev.c
      tpm: Move sysfs functions from tpm-interface to tpm-sysfs
      tpm: Pull all driver sysfs code into tpm-sysfs.c
      tpm: Create a tpm_class_ops structure and use it in the drivers
      tpm: Use the ops structure instead of a copy in tpm_vendor_specific
      tpm: Make tpm-dev allocate a per-file structure
      tpm: tpm_tis: Fix compile problems with CONFIG_PM_SLEEP/CONFIG_PNP

Michal Nazarewicz (1):
      char: tpm: nuvoton: remove unused variable

Mimi Zohar (1):
      ima: update IMA-templates.txt documentation

Oleg Nesterov (1):
      selinux: selinux_setprocattr()->ptrace_parent() needs rcu_read_lock()

Paul Moore (8):
      Merge tag 'v3.12'
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
      selinux: handle TCP SYN-ACK packets correctly in selinux_ip_postroute()
      selinux: ensure that the cached NetLabel secattr matches the desired SID
      selinux: pull address family directly from the request_sock struct
      selinux: look for IPsec labels on both inbound and outbound packets
      selinux: process labeled IPsec TCP SYN-ACK packets properly in selinux_ip_postroute()
      selinux: revert 102aefdda4d8275ce7d7100bc16c88c74272b260

Peter Huewe (5):
      tpm/tpm_ppi: Do not compare strcmp(a,b) == -1
      tpm/tpm_ppi: Check return value of acpi_get_name
      tpm/tpm_i2c_stm_st33: Check return code of get_burstcount
      tpm/tpm_ibmvtpm: fix unreachable code warning (smatch warning)
      tpm: MAINTAINERS: Cleanup TPM Maintainers file

Richard Haines (1):
      SELinux: Update policy version to support constraints info

Roberto Sassu (3):
      ima: change the default hash algorithm to SHA1 in ima_eventdigest_ng_init()
      ima: pass HASH_ALGO__LAST as hash algo in ima_eventdigest_init()
      ima: remove unneeded size_limit argument from ima_eventdigest_init_common()

Tetsuo Handa (1):
      SELinux: Fix memory leak upon loading policy

Tim Gardner (1):
      SELinux: security_load_policy: Silence frame-larger-than warning

Wei Yongjun (1):
      SELinux: remove duplicated include from hooks.c

 Documentation/security/IMA-templates.txt  |    6 +-
 MAINTAINERS                               |    8 +-
 drivers/char/tpm/Makefile                 |    2 +-
 drivers/char/tpm/tpm-dev.c                |  213 +++++++++++++
 drivers/char/tpm/tpm-interface.c          |  488 ++---------------------------
 drivers/char/tpm/tpm-sysfs.c              |  318 +++++++++++++++++++
 drivers/char/tpm/tpm.h                    |   83 +++---
 drivers/char/tpm/tpm_atmel.c              |   28 +--
 drivers/char/tpm/tpm_i2c_atmel.c          |   44 +---
 drivers/char/tpm/tpm_i2c_infineon.c       |   42 +---
 drivers/char/tpm/tpm_i2c_nuvoton.c        |   43 +---
 drivers/char/tpm/tpm_i2c_stm_st33.c       |   48 +---
 drivers/char/tpm/tpm_ibmvtpm.c            |   41 +---
 drivers/char/tpm/tpm_infineon.c           |   28 +--
 drivers/char/tpm/tpm_nsc.c                |   28 +--
 drivers/char/tpm/tpm_ppi.c                |   11 +-
 drivers/char/tpm/tpm_tis.c                |   49 +---
 drivers/char/tpm/xen-tpmfront.c           |   45 +---
 include/linux/tpm.h                       |   12 +
 security/integrity/ima/ima_template_lib.c |   18 +-
 security/selinux/hooks.c                  |    7 +-
 security/selinux/include/security.h       |    3 +-
 security/selinux/netlabel.c               |   31 ++-
 security/selinux/ss/constraint.h          |    1 +
 security/selinux/ss/policydb.c            |  110 ++++++-
 security/selinux/ss/policydb.h            |   11 +
 security/selinux/ss/services.c            |   54 ++--
 security/smack/smack.h                    |    5 +-
 security/smack/smack_lsm.c                |  140 ++++-----
 security/smack/smackfs.c                  |  134 +++++++--
 30 files changed, 1010 insertions(+), 1041 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-dev.c
 create mode 100644 drivers/char/tpm/tpm-sysfs.c
