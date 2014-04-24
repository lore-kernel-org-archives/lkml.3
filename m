Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaDXLqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:46:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753675AbaDXLqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:46:01 -0400
Date: Thu, 24 Apr 2014 07:45:57 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull file locking changes for v3.15 (pile #2)
Message-ID: <20140424074557.57f91e16@tlielax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 55101e2d6ce1c780f6ee8fee5f37306971aac6cd:

  Merge git://git.kernel.org/pub/scm/virt/kvm/kvm (2014-04-14 16:21:28 -0700)

are available in the git repository at:


  git://git.samba.org/jlayton/linux.git tags/locks-v3.15-2

for you to fetch changes up to cff2fce58b2b0f59089e7edcdc38803d65057b9f:

  locks: rename FL_FILE_PVT and IS_FILE_PVT to use "*_OFDLCK" instead (2014-04-23 16:17:03 -0400)

----------------------------------------------------------------
File locking related bugfixes for v3.15 (pile #2)

- fix for a long-standing bug in __break_lease that can cause soft lockups
- renaming of file-private locks to "open file description" locks, and the
  command macros to more visually distinct names.

The fix for __break_lease is also in the pile of patches for which Bruce
sent a pull request, but I assume that your merge procedure will handle
that correctly.

For the other patches, I don't like the fact that we need to rename this
stuff at this late stage, but it should be settled now (hopefully).

----------------------------------------------------------------
Jeff Layton (3):
      locks: allow __break_lease to sleep even when break_time is 0
      locks: rename file-private locks to "open file description locks"
      locks: rename FL_FILE_PVT and IS_FILE_PVT to use "*_OFDLCK" instead

 arch/arm/kernel/sys_oabi-compat.c |  6 +++---
 fs/compat.c                       | 14 +++++++-------
 fs/fcntl.c                        | 12 ++++++------
 fs/locks.c                        | 55 +++++++++++++++++++++++++++----------------------------
 include/linux/fs.h                |  2 +-
 include/uapi/asm-generic/fcntl.h  | 20 ++++++++++----------
 security/selinux/hooks.c          |  6 +++---
 7 files changed, 57 insertions(+), 58 deletions(-)

-- 
Jeff Layton <jlayton@redhat.com>
