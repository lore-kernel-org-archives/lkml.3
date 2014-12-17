Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaLQKBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:01:49 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38918 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbaLQKBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:01:46 -0500
Date: Wed, 17 Dec 2014 11:02:02 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] fuse update for 3.19
Message-ID: <20141217100202.GA19050@tucsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

First part makes sure we don't hold up umount with pending async requests.  In
addition to being a cleanup, this is a small behavioral change (for the better)
and unlikely to break anything.  Second part prepares for a cleanup of the fuse
device I/O code by adding a helper for simple request submission, with some
savings in line numbers already realized.

Thanks,
Miklos

---
Miklos Szeredi (6):
      fuse: don't wake up reserved req in fuse_conn_kill()
      fuse: flush requests on umount
      fuse: hold inode instead of path after release
      fuse: reduce max out args
      fuse: introduce fuse_simple_request() helper
      fuse: use file_inode() in fuse_file_fallocate()

---
 fs/fuse/cuse.c   |   2 +-
 fs/fuse/dev.c    |  29 +++
 fs/fuse/dir.c    | 538 ++++++++++++++++++++++---------------------------------
 fs/fuse/file.c   | 230 ++++++++----------------
 fs/fuse/fuse_i.h |  45 +++--
 fs/fuse/inode.c  |  39 +---
 6 files changed, 359 insertions(+), 524 deletions(-)
