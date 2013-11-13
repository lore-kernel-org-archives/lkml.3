Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab3KMNRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 08:17:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45692 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3KMNRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 08:17:47 -0500
Date: Wed, 13 Nov 2013 13:17:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git fixes
Message-ID: <20131113131745.GC13318@ZenIV.linux.org.uk>
References: <20131111163034.GY13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111163034.GY13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several fixes, mostly for regressions in the last pile.  Howeover,
prepend_path() forgetting to reininitalize dentry/vfsmount is in 3.12
as well and qib_fs had been leaking all along...  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (2):
      prepend_path() needs to reinitialize dentry/vfsmount/mnt on restarts
      qib_fs: fix (some) dcache abuses

Dan Carpenter (2):
      aio: checking for NULL instead of IS_ERR
      locks: missing unlock on error in generic_add_lease()

Li Zhong (1):
      fix unpaired rcu lock in prepend_path()

Diffstat:
 drivers/infiniband/hw/qib/qib_fs.c |    7 +++++--
 fs/aio.c                           |    4 ++--
 fs/dcache.c                        |   13 ++++++++++---
 fs/locks.c                         |    1 +
 4 files changed, 18 insertions(+), 7 deletions(-)
