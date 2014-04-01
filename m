Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaDAAuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 20:50:24 -0400
Received: from tundra.namei.org ([65.99.196.166]:47316 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbaDAAuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 20:50:18 -0400
Date: Tue, 1 Apr 2014 11:53:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT] Security subsystem changes for 3.15
Message-ID: <alpine.LRH.2.02.1404011149310.21976@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apart from reordering the SELinux mmap code to ensure DAC is called 
before MAC, these are minor maintenance updates.

Please pull.

The following changes since commit 01d5f3b598b18a5035426c30801adf65822dbd0c:

  Merge branch 'for-3.15' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata (2014-03-31 15:27:37 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus

Dmitry Kasatkin (6):
      ima: fix erroneous removal of security.ima xattr
      integrity: fix checkpatch errors
      ima: return d_name.name if d_path fails
      evm: EVM does not use MD5
      ima: skip memory allocation for empty files
      evm: enable key retention service automatically

James Morris (1):
      Merge branch 'next-fixes' of git://git.kernel.org/.../zohar/linux-integrity into next

Jeff Layton (1):
      security: have cap_dentry_init_security return error

Jingoo Han (1):
      security: replace strict_strto*() with kstrto*()

Joe Perches (2):
      capability: Use current logging styles
      security: integrity: Use a more current logging style

Libo Chen (1):
      ima: new helper: file_inode(file)

Mimi Zohar (3):
      ima: use static const char array definitions
      fs: move i_readcount
      MAINTAINERS: email updates and other misc. changes

Paul Moore (4):
      selinux: fix the output of ./scripts/get_maintainer.pl for SELinux
      selinux: fix the output of ./scripts/get_maintainer.pl for SELinux
      selinux: put the mmap() DAC controls before the MAC controls
      selinux: correctly label /proc inodes in use before the policy is loaded

Rashika Kheria (1):
      kernel: Mark function as static in kernel/seccomp.c

Roberto Sassu (2):
      ima: restore the original behavior for sending data with ima template
      ima: reduce memory usage when a template containing the n field is used

Sam Ravnborg (1):
      security: cleanup Makefiles to use standard syntax for specifying sub-directories

Tetsuo Handa (1):
      Integrity: Pass commname via get_task_comm()

 MAINTAINERS                               |   22 +++++---
 include/linux/fs.h                        |    6 +-
 kernel/capability.c                       |   29 ++++-------
 kernel/seccomp.c                          |    2 +-
 security/Makefile                         |   12 ++--
 security/apparmor/lsm.c                   |    2 +-
 security/capability.c                     |    2 +-
 security/integrity/Makefile               |    4 +-
 security/integrity/evm/Kconfig            |    6 +-
 security/integrity/evm/evm.h              |   28 +++++-----
 security/integrity/evm/evm_crypto.c       |    8 ++-
 security/integrity/evm/evm_main.c         |    6 ++-
 security/integrity/evm/evm_secfs.c        |    6 ++-
 security/integrity/iint.c                 |    2 +-
 security/integrity/ima/ima.h              |    2 +-
 security/integrity/ima/ima_api.c          |   20 ++++----
 security/integrity/ima/ima_appraise.c     |    4 +-
 security/integrity/ima/ima_crypto.c       |   37 +++++++++----
 security/integrity/ima/ima_fs.c           |    8 ++-
 security/integrity/ima/ima_init.c         |    9 ++-
 security/integrity/ima/ima_main.c         |   11 +---
 security/integrity/ima/ima_policy.c       |   79 +++++++++++++++--------------
 security/integrity/ima/ima_queue.c        |   12 +++--
 security/integrity/ima/ima_template.c     |   19 ++++---
 security/integrity/ima/ima_template_lib.c |   29 ++++-------
 security/integrity/integrity_audit.c      |    7 ++-
 security/keys/encrypted-keys/encrypted.c  |    2 +-
 security/keys/trusted.c                   |    6 +-
 security/selinux/hooks.c                  |   60 +++++++++++++--------
 security/selinux/selinuxfs.c              |    2 +-
 30 files changed, 235 insertions(+), 207 deletions(-)
