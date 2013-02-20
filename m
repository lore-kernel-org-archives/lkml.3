Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933794Ab3BTIVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:21:31 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:54234 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933546Ab3BTIV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:21:29 -0500
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
Date: Wed, 20 Feb 2013 09:21:27 +0100
Message-ID: <CAJfpegu2fPDL1RctiTq1xDeb=u7TPNoYj7sYwioa4tU-CrKd6g@mail.gmail.com>
Subject: [GIT PULL] fuse updates for 3.9
From: Miklos Szeredi <miklos@szeredi.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/fuse.git for-linus

The biggest part of this pull request is a patch series from Maxim
Patlasov to optimize scatter-gather direct IO.  There's also the
addition of a "readdirplus" API, poll events and various fixes and
cleanups.

There's a one line change outside of fuse to mm/filemap.c which makes
the argument of iov_iter_single_seg_count() const, required by Maxim's
patches.

Thanks,
Miklos

----
Anand V. Avati (1):
      fuse: implement NFS-like readdirplus support

Anatol Pomozov (1):
      Do not use RCU for current process credentials

Enke Chen (1):
      fuse: send poll events

Eric Wong (2):
      fuse: avoid out-of-scope stack access
      fuse: allow control of adaptive readdirplus use

Feng Shuo (1):
      FUSE: Adapt readdirplus to application usage patterns

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

Miklos Szeredi (4):
      fuse: cleanup fuse_direct_io()
      fuse: bump version for READDIRPLUS
      fuse: don't WARN when nlink is zero
      Synchronize fuse header with one used in library

---
 fs/fuse/cuse.c            |   10 +-
 fs/fuse/dev.c             |  128 ++++++++++++++++------
 fs/fuse/dir.c             |  259 ++++++++++++++++++++++++++++++++++++++-------
 fs/fuse/file.c            |  238 ++++++++++++++++++++++++++---------------
 fs/fuse/fuse_i.h          |   74 ++++++++++---
 fs/fuse/inode.c           |   16 ++-
 include/linux/fs.h        |    2 +-
 include/uapi/linux/fuse.h |   60 ++++++++++-
 mm/filemap.c              |    2 +-
 9 files changed, 609 insertions(+), 180 deletions(-)
