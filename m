Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaDCNvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:51:50 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59251 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbaDCNvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:51:46 -0400
Date: Thu, 3 Apr 2014 15:51:41 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] fuse update for 3.15
Message-ID: <20140403135141.GD10187@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

This series adds cached writeback support to fuse, improving write throughput.

Thanks,
Miklos
----

Maxim Patlasov (3):
      fuse: Trust kernel i_mtime only
      fuse: restructure fuse_readpage()
      fuse: fuse_flush() should wait on writeback

Pavel Emelyanov (8):
      fuse: Linking file to inode helper
      fuse: Prepare to handle short reads
      fuse: Connection bit for enabling writeback
      fuse: Trust kernel i_size only
      fuse: Flush files on wb close
      fuse: Implement write_begin/write_end callbacks
      fuse: Fix O_DIRECT operations vs cached writeback misorder
      fuse: Turn writeback cache on

Rajat Jain (1):
      fuse: fix "uninitialized variable" warning

---
 fs/fuse/cuse.c            |   5 +-
 fs/fuse/dir.c             | 119 ++++++++++++++++---
 fs/fuse/file.c            | 286 +++++++++++++++++++++++++++++++++++++---------
 fs/fuse/fuse_i.h          |  22 +++-
 fs/fuse/inode.c           |  29 ++++-
 include/uapi/linux/fuse.h |   7 +-
 6 files changed, 384 insertions(+), 84 deletions(-)
