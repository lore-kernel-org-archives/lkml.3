Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193AbaHOLiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 07:38:11 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:35822 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaHOLiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 07:38:09 -0400
Date: Fri, 15 Aug 2014 07:38:04 -0400
From: Jeff Layton <jlayton@poochiereds.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] please pull file locking changes for v3.17 (pile #2)
Message-ID: <20140815073804.76fb9b47@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit c8d6637d0497d62093dbba0694c7b3a80b79bfe1:

  Merge tag 'modules-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux (2014-08-10 21:31:58 -0700)

are available in the git repository at:


  git://git.samba.org/jlayton/linux.git tags/locks-v3.17-2

for you to fetch changes up to 2ece173e4715031c031de9114491eee80a69cf68:

  locks: update Locking documentation to clarify fl_release_private behavior (2014-08-14 10:08:20 -0400)

----------------------------------------------------------------
File locking related bugfixes for v3.17 (pile #2)

Hi Linus!

Most of these patches are to fix a long-standing regression that crept
in when the BKL was removed from the file-locking code. The code was
converted to use a conventional spinlock, but some fl_release_private
ops can block and you can end up sleeping inside the lock.

There's also a patch to make /proc/locks show delegations as "DELEG".

----------------------------------------------------------------
Jeff Layton (6):
      locks: show delegations as "DELEG" in /proc/locks
      locks: don't call locks_release_private from locks_copy_lock
      locks: don't reuse file_lock in __posix_lock_file
      locks: defer freeing locks in locks_delete_lock until after i_lock has been dropped
      locks: move locks_free_lock calls in do_fcntl_add_lease outside spinlock
      locks: update Locking documentation to clarify fl_release_private behavior

 Documentation/filesystems/Locking |  6 +++++-
 fs/locks.c                        | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------
 2 files changed, 62 insertions(+), 30 deletions(-)

-- 
Jeff Layton <jlayton@poochiereds.net>
