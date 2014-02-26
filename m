Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbaBZQzr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:55:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbaBZQzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:55:42 -0500
Date: Wed, 26 Feb 2014 17:55:40 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] Notification, writeback, udf, quota fixes for 3.14-rc5
Message-ID: <20140226165540.GA28856@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get several fixes. Notification patches are (with one exception) a fallout
of my fsnotify rework which went into -rc1 (I've extented LTP to cover these
cornercases to avoid similar breakage in future). UDF patch is a nasty data
corruption Al has recently reported, revert of writeback patch is due to
possibility of violating sync(2) guarantees, and quota bug can lead to
corruption of quota files in ocfs2.  Top of the tree is ff57cd5863cf. The full
shortlog is:

Jan Kara (7):
      inotify: Fix reporting of cookies for inotify events
      udf: Fix data corruption on file type conversion
      quota: Fix race between dqput() and dquot_scan_active()
      Revert "writeback: do not sync data dirtied after sync start"
      fsnotify: Fix detection whether overflow event is queued
      fanotify: Handle overflow in case of permission events
      fsnotify: Allocate overflow events with proper type

The diffstat is

 fs/fs-writeback.c                    | 33 +++++++++++----------------------
 fs/notify/dnotify/dnotify.c          |  2 +-
 fs/notify/fanotify/fanotify.c        |  8 +++++---
 fs/notify/fanotify/fanotify_user.c   | 13 +++++++++++++
 fs/notify/fsnotify.c                 |  2 +-
 fs/notify/group.c                    |  8 +++++++-
 fs/notify/inotify/inotify.h          |  2 +-
 fs/notify/inotify/inotify_fsnotify.c |  3 ++-
 fs/notify/inotify/inotify_user.c     | 14 +++++++++++++-
 fs/notify/notification.c             | 20 +++++++++++++++-----
 fs/quota/dquot.c                     | 14 +++++++++++---
 fs/sync.c                            | 15 ++++++---------
 fs/udf/file.c                        | 14 ++++++++++++--
 fs/udf/inode.c                       |  1 +
 fs/xfs/xfs_super.c                   |  2 +-
 include/linux/fsnotify_backend.h     |  4 ++--
 include/linux/writeback.h            |  2 +-
 include/trace/events/writeback.h     |  6 +++---
 kernel/audit_tree.c                  |  2 +-
 kernel/audit_watch.c                 |  2 +-
 20 files changed, 108 insertions(+), 59 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
