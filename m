Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaAWIWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 03:22:44 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:58595 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaAWIWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 03:22:42 -0500
Date: Thu, 23 Jan 2014 09:23:36 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] fuse update for 3.14
Message-ID: <20140123082336.GJ24171@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

This contains a fix for a potential use-after-module-unload bug noticed by Al
and caching improvements for read-only fuse filesystems by Andrew Gallagher.

Thanks,
Miklos
----

Andrew Gallagher (2):
      fuse: don't invalidate attrs when not using atime
      fuse: support clients that don't implement 'open'

Miklos Szeredi (2):
      fuse: fix pipe_buf_operations
      fuse: fix SetPageUptodate() condition in STORE

---
 fs/fuse/dev.c             | 25 +++++++------------------
 fs/fuse/dir.c             | 14 ++++++++++++--
 fs/fuse/file.c            | 41 +++++++++++++++++++++++++++++------------
 fs/fuse/fuse_i.h          |  5 +++++
 fs/splice.c               | 18 ++++++++++++++++++
 include/linux/pipe_fs_i.h |  2 ++
 net/core/skbuff.c         | 32 +-------------------------------
 7 files changed, 74 insertions(+), 63 deletions(-)
