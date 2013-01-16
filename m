Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3APMyG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:54:06 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:49922 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3APMyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:54:04 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] fuse updates for 3.8
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Maxim Patlasov <mpatlasov@parallels.com>
Date: Wed, 16 Jan 2013 13:53:47 +0100
Message-ID: <87obgpcmqs.fsf@tucsk.piliscsaba.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for the late submission.  Most of this was bound for 3.7, which I
missed due to moving house.  I think it makes sense to merge it now
instead of next cycle as there are quite of few other fuse updates
pending.

Please consider pulling

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

The large part of this pull request is a patch series from Maxim
Patlasov to optimize scatter-gather direct IO.  The rest is small fixes
and cleanups.

There's a one line change outside of fs/fuse to mm/filemap.c which makes
the argument of iov_iter_single_seg_count() const, required by Maxim's
patches.

Thanks,
Miklos

----
Anand V. Avati (1):
      fuse: implement NFS-like readdirplus support

David Herrmann (2):
      cuse: use mutex as registration lock instead of spinlocks
      cuse: do not register multiple devices with identical names

Maxim Patlasov (12):
      fuse: general infrastructure for pages[] of variable size
      fuse: categorize fuse_get_req()
      fuse: rework fuse_retrieve()
      fuse: rework fuse_readpages()
      fuse: rework fuse_perform_write()
      fuse: rework fuse_do_ioctl()
      fuse: add per-page descriptor <offset, length> to fuse_req
      fuse: use req->page_descs[] for argpages cases
      mm: minor cleanup of iov_iter_single_seg_count()
      fuse: pass iov[] to fuse_get_user_pages()
      fuse: optimize fuse_get_user_pages()
      fuse: optimize __fuse_direct_io()

Miklos Szeredi (3):
      fuse: cleanup fuse_direct_io()
      fuse: make fuse_file_fallocate() static
      cuse: fix uninitialized variable warnings

Robert P. J. Day (1):
      fuse: Move CUSE Kconfig entry from fs/Kconfig into fs/fuse/Kconfig

Wei Yongjun (1):
      fuse: remove unused variable in fuse_try_move_page()

---
 fs/Kconfig                |   10 --
 fs/fuse/Kconfig           |   16 ++-
 fs/fuse/cuse.c            |   46 +++++----
 fs/fuse/dev.c             |  122 ++++++++++++++++-------
 fs/fuse/dir.c             |  199 ++++++++++++++++++++++++++++++++-----
 fs/fuse/file.c            |  240 +++++++++++++++++++++++++++++----------------
 fs/fuse/fuse_i.h          |   58 ++++++++---
 fs/fuse/inode.c           |   11 ++-
 include/linux/fs.h        |    2 +-
 include/uapi/linux/fuse.h |   12 +++
 mm/filemap.c              |    2 +-
 11 files changed, 528 insertions(+), 190 deletions(-)
