Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab3GBAla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 20:41:30 -0400
Received: from tundra.namei.org ([65.99.196.166]:60325 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab3GBAl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 20:41:28 -0400
Date: Tue, 2 Jul 2013 10:41:37 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Security subsystem updates for 3.11
Message-ID: <alpine.LRH.2.02.1307021033160.8613@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this update, Smack learns to love IPv6 and to mount a filesystem with a 
transmutable hierarchy (i.e. security labels are inherited from parent 
directory upon creation rather than creating process).

The rest of the changes are maintenance.

Please pull.


The following changes since commit 8bb495e3f02401ee6f76d1b1d77f3ac9f079e376:

  Linux 3.10 (2013-06-30 15:13:29 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Al Viro (1):
      apparmor: no need to delay vfree()

Casey Schaufler (3):
      Smack: Local IPv6 port based controls
      Smack: Improve access check performance
      Smack: Add smkfstransmute mount option

J. Bruce Fields (1):
      security: clarify cap_inode_getsecctx description

James Morris (2):
      Merge tag 'aa-3.10' of git://git.kernel.org/.../jj/linux-apparmor into ra-next
      Merge branch 'smack-for-3.11' of git://git.gitorious.org/smack-next/kernel into ra-next

John Johansen (20):
      apparmor: fix auditing of domain transition failures due to incomplete policy
      apparmor: Remove -W1 warnings
      apparmor: refactor profile mode macros
      apparmor: fix error code to failure message mapping for name lookup
      apparmor: add utility function to get an arbitrary tasks profile.
      apparmor: add kvzalloc to handle zeroing for kvmalloc
      apparmor: use common fn to clear task_context for domain transitions
      apparmor: remove "permipc" command
      apparmor: relax the restrictions on setting rlimits
      apparmor: misc cleanup of match
      apparmor: move perm defines into policy_unpack
      apparmor: remove sid from profiles
      apparmor: move the free_profile fn ahead of aa_alloc_profile
      apparmor: reserve and mask off the top 8 bits of the base field
      apparmor: fix the audit type table
      apparmor: Fix smatch warning in aa_remove_profiles
      apparmor: fix sparse warnings
      apparmor: localize getting the security context to a few macros
      apparmor: fix setprocattr arg processing for onexec
      apparmor: fix fully qualified name parsing

Kent Yoder (1):
      maintainers: Remove Kent from maintainers

Lars-Peter Clausen (1):
      tpm: tpm_i2c_infinion: Don't modify i2c_client->driver

Mimi Zohar (5):
      tpm: move TPM_DIGEST_SIZE defintion
      maintainers:  add Dmitry Kasatkin
      evm: calculate HMAC after initializing posix acl on tmpfs
      integrity: move integrity_audit_msg()
      evm: audit integrity metadata failures

Passion,Zhao (1):
      Smack: Fix the bug smackcipso can't set CIPSO correctly

Peter Huewe (2):
      tpm: fix regression caused by section type conflict of tpm_dev_release() in ppc builds
      tpm/tpm_i2c_infineon: Remove unused header file

Tetsuo Handa (1):
      Smack: Fix possible NULL pointer dereference at smk_netlbl_mls()

Wei Yongjun (1):
      tpm_tis: missing platform_driver_unregister() on error in init_tis()

 Documentation/kernel-parameters.txt                |   10 +-
 MAINTAINERS                                        |    7 +-
 drivers/char/tpm/tpm.c                             |    2 +-
 drivers/char/tpm/tpm.h                             |    2 +-
 drivers/char/tpm/tpm_i2c_infineon.c                |    4 -
 drivers/char/tpm/tpm_tis.c                         |   17 +-
 include/linux/security.h                           |    3 +-
 include/linux/tpm.h                                |    2 +
 mm/shmem.c                                         |   16 +-
 security/apparmor/audit.c                          |    2 +-
 security/apparmor/context.c                        |   44 +-
 security/apparmor/domain.c                         |   26 +-
 security/apparmor/include/apparmor.h               |   12 +-
 security/apparmor/include/context.h                |   61 ++-
 security/apparmor/include/file.h                   |   14 +-
 security/apparmor/include/match.h                  |   21 +-
 security/apparmor/include/policy.h                 |   16 +-
 security/apparmor/include/procattr.h               |    1 -
 security/apparmor/include/sid.h                    |    4 +-
 security/apparmor/ipc.c                            |   13 +-
 security/apparmor/lib.c                            |   44 +-
 security/apparmor/lsm.c                            |   69 +-
 security/apparmor/match.c                          |   23 +-
 security/apparmor/path.c                           |    2 +-
 security/apparmor/policy.c                         |  181 +++---
 security/apparmor/policy_unpack.c                  |    4 +-
 security/apparmor/procattr.c                       |    6 -
 security/apparmor/resource.c                       |   15 +-
 security/integrity/Kconfig                         |   15 +
 security/integrity/Makefile                        |    1 +
 security/integrity/evm/evm_main.c                  |   15 +-
 security/integrity/ima/Kconfig                     |   12 -
 security/integrity/ima/Makefile                    |    1 -
 security/integrity/ima/ima.h                       |   14 -
 security/integrity/integrity.h                     |   14 +
 .../{ima/ima_audit.c => integrity_audit.c}         |   12 +-
 security/smack/smack.h                             |  110 ++--
 security/smack/smack_access.c                      |   43 +-
 security/smack/smack_lsm.c                         |  684 ++++++++++++++------
 security/smack/smackfs.c                           |   53 +-
 40 files changed, 985 insertions(+), 610 deletions(-)
 rename security/integrity/{ima/ima_audit.c => integrity_audit.c} (85%)
