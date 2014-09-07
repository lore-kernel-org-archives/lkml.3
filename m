Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaIGRgA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 13:36:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39560 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaIGRf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 13:35:59 -0400
Date: Sun, 7 Sep 2014 18:35:57 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] several fixes
Message-ID: <20140907173557.GU7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several bugfixes (all of them -stable fodder).  Alexey's one deals with
double mutex_lock() in UFS (apparently, nobody has tried to test "ufs: sb mutex
merge + mutex_destroy" on something like file creation/removal on ufs -
it's a 100%-guaranteed deadlock).  Mine deal with two kinds of umount bugs,
in umount propagation and in handling of automounted submounts, both
resulting in bogus transient EBUSY from umount.  Please, pull from the
usual place:
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (2):
      get rid of propagate_umount() mistakenly treating slaves as busy.
      fix EBUSY on umount() from MNT_SHRINKABLE

Alexey Khoroshilov (1):
      ufs: fix deadlocks introduced by sb mutex merge

Diffstat:
 fs/namespace.c |   10 +++++++++-
 fs/pnode.c     |    1 +
 fs/ufs/inode.c |    7 ++-----
 fs/ufs/namei.c |   14 ++++++--------
 4 files changed, 18 insertions(+), 14 deletions(-)
