Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3IFBnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 21:43:10 -0400
Received: from tundra.namei.org ([65.99.196.166]:45822 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029Ab3IFBnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 21:43:08 -0400
Date: Fri, 6 Sep 2013 11:44:52 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [GIT PULL] security subsystem changes for 3.12
Message-ID: <alpine.LRH.2.02.1309061143310.17574@tundra.namei.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing major for this kernel, just maintenance updates.

Please pull.



The following changes since commit 2e032852245b3dcfe5461d7353e34eb6da095ccf:

  Merge branch 'for-linus' of git://git.linaro.org/people/rmk/linux-arm (2013-09-05 18:07:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next

Casey Schaufler (1):
      Smack: network label match fix

James Morris (2):
      Merge branch 'linus-master'; commit 'v3.11-rc2' into ra-next
      Merge branch 'smack-for-3.12' of git://git.gitorious.org/smack-next/kernel into ra-next

John Johansen (14):
      apparmor: enable users to query whether apparmor is enabled
      apparmor: add a features/policy dir to interface
      apparmor: provide base for multiple profiles to be replaced at once
      apparmor: convert profile lists to RCU based locking
      apparmor: change how profile replacement update is done
      apparmor: update how unconfined is handled
      apparmor: rework namespace free path
      apparmor: make free_profile available outside of policy.c
      apparmor: allow setting any profile into the unconfined state
      apparmor: add interface files for profiles and namespaces
      apparmor: add an optional profile attachment string for profiles
      apparmor: add the profile introspection file to interface
      apparmor: export set of capabilities supported by the apparmor module
      apparmor: add the ability to report a sha1 hash of loaded policy

Rafal Krypa (1):
      Smack: parse multiple rules per write to load2, up to PAGE_SIZE-1 bytes

Tetsuo Handa (2):
      xattr: Constify ->name member of "struct xattr".
      apparmor: remove minimum size check for vmalloc()

Tomasz Stanislawski (2):
      security: smack: fix memleak in smk_write_rules_list()
      security: smack: add a hash table to quicken smk_find_entry()

 fs/ocfs2/xattr.h                          |    2 +-
 include/linux/security.h                  |    8 +-
 include/linux/xattr.h                     |    2 +-
 include/uapi/linux/reiserfs_xattr.h       |    2 +-
 security/apparmor/Kconfig                 |   12 +
 security/apparmor/Makefile                |    7 +-
 security/apparmor/apparmorfs.c            |  636 ++++++++++++++++++++++++++++-
 security/apparmor/capability.c            |    5 +
 security/apparmor/context.c               |   16 +-
 security/apparmor/crypto.c                |   97 +++++
 security/apparmor/domain.c                |   24 +-
 security/apparmor/include/apparmor.h      |    6 +
 security/apparmor/include/apparmorfs.h    |   40 ++
 security/apparmor/include/audit.h         |    1 -
 security/apparmor/include/capability.h    |    4 +
 security/apparmor/include/context.h       |   15 +-
 security/apparmor/include/crypto.h        |   36 ++
 security/apparmor/include/policy.h        |  218 +++++++---
 security/apparmor/include/policy_unpack.h |   21 +-
 security/apparmor/lib.c                   |    5 -
 security/apparmor/lsm.c                   |   22 +-
 security/apparmor/policy.c                |  609 ++++++++++++++++------------
 security/apparmor/policy_unpack.c         |  135 +++++--
 security/apparmor/procattr.c              |    2 +-
 security/capability.c                     |    2 +-
 security/integrity/evm/evm_main.c         |    2 +-
 security/security.c                       |    8 +-
 security/selinux/hooks.c                  |   17 +-
 security/smack/smack.h                    |   13 +-
 security/smack/smack_access.c             |   29 ++-
 security/smack/smack_lsm.c                |   51 ++-
 security/smack/smackfs.c                  |  184 ++++-----
 32 files changed, 1675 insertions(+), 556 deletions(-)
 create mode 100644 security/apparmor/crypto.c
 create mode 100644 security/apparmor/include/crypto.h
