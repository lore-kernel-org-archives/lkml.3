Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751188Ab3FDIBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:01:33 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:59256 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3FDIBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:01:31 -0400
Date: Tue, 4 Jun 2013 10:01:25 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Maxim Patlasov <mpatlasov@parallels.com>
Subject: [GIT PULL] fuse bugfixes for 3.10-rc5
Message-ID: <20130604080125.GD1842@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following bugfixes for fuse:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

One patch fixes an Oops introduced in 3.9 with the readdirplus feature.  The
rest are fixes for async-dio in 3.10.

Thanks,
Miklos

---
Brian Foster (4):
      fuse: allocate for_background dio requests based on io->async state
      fuse: truncate pagecache range on hole punch
      fuse: update inode size and invalidate attributes on fallocate
      fuse: return -EIOCBQUEUED from fuse_direct_IO() for all async requests

Maxim Patlasov (1):
      fuse: fix alignment in short read optimization for async_dio

Miklos Szeredi (1):
      fuse: fix readdirplus Oops in fuse_dentry_revalidate

---
 fs/fuse/dir.c   |   12 +++++++++---
 fs/fuse/file.c  |   58 ++++++++++++++++++++++++++++++++++++++++++++++---------
 fs/fuse/inode.c |    7 ++++---
 3 files changed, 62 insertions(+), 15 deletions(-)
