Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbaJNWH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 18:07:26 -0400
Received: from cobra.newdream.net ([66.33.216.30]:38789 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbaJNWHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 18:07:25 -0400
Date: Tue, 14 Oct 2014 15:07:24 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 3.18-rc1
Message-ID: <alpine.DEB.2.00.1410141502460.6466@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There is the long-awaited discard support for RBD (Guangliang Zhao, Josh 
Durgin), a pile of RBD bug fixes that didn't belong in late -rc's (Ilya 
Dryomov, Li RongQing), a pile of fs/ceph bug fixes and performance and 
debugging improvements (Yan, Zheng, John Spray), and a smattering of 
cleanups (Chao Yu, Fabian Frederick, Joe Perches).

Thanks!
sage


----------------------------------------------------------------
Chao Yu (1):
      ceph: remove redundant code for max file size verification

Fabian Frederick (2):
      libceph: remove redundant declaration
      ceph: fix bool assignments

Guangliang Zhao (3):
      rbd: skip the copyup when an entire object writing
      rbd: extend the operation type
      rbd: initial discard bits from Guangliang Zhao

Ilya Dryomov (10):
      libceph: abstract out ceph_osd_request enqueue logic
      libceph: resend lingering requests with a new tid
      libceph: select CRYPTO_CBC in addition to CRYPTO_AES
      libceph: don't try checking queue_work() return value
      rbd: do not return -ERANGE on auth failures
      rbd: add img_obj_request_simple() helper
      libceph: sync osd op definitions in rados.h
      libceph: separate multiple ops with commas in debugfs output
      libceph: ceph-msgr workqueue needs a resque worker
      rbd: rbd workqueues need a resque worker

Joe Perches (1):
      libceph: Convert pr_warning to pr_warn

John Spray (3):
      ceph: send client metadata to MDS
      ceph: export ceph_session_state_name function
      ceph: additional debugfs output

Josh Durgin (8):
      rbd: access snapshot context and mapping size safely
      rbd: read image size for discard check safely
      rbd: fix snapshot context reference count for discards
      rbd: tolerate -ENOENT for discard operations
      rbd: make discard trigger copy-on-write
      rbd: extract a method for adding object operations
      rbd: use helpers to handle discard for layered images correctly
      rbd: set the remaining discard properties to enable support

Li RongQing (1):
      libceph: fix a use after free issue in osdmap_set_max_osd

Yan, Zheng (11):
      ceph: trim unused inodes before reconnecting to recovering MDS
      ceph: protect kick_requests() with mdsc->mutex
      ceph: make sure request isn't in any waiting list when kicking request.
      ceph: request xattrs if xattr_version is zero
      ceph: move ceph_find_inode() outside the s_mutex
      ceph: remove redundant io_iter_advance()
      ceph: fix llistxattr on symlink
      libceph: reference counting pagelist
      ceph: use pagelist to present MDS request data
      ceph: include the initial ACL in create/mkdir/mknod MDS requests
      ceph: fix divide-by-zero in __validate_layout()

 drivers/block/rbd.c           | 396 +++++++++++++++++++++++++++++-------------
 fs/ceph/acl.c                 | 125 ++++++++++---
 fs/ceph/addr.c                |   9 -
 fs/ceph/caps.c                |  37 ++--
 fs/ceph/debugfs.c             |  46 +++++
 fs/ceph/dir.c                 |  41 +++--
 fs/ceph/file.c                |  33 ++--
 fs/ceph/inode.c               |  16 +-
 fs/ceph/ioctl.c               |   6 +-
 fs/ceph/mds_client.c          | 136 +++++++++++----
 fs/ceph/mds_client.h          |   6 +-
 fs/ceph/super.h               |  27 ++-
 fs/ceph/xattr.c               |  81 ++++-----
 include/linux/ceph/libceph.h  |   1 -
 include/linux/ceph/pagelist.h |   5 +-
 include/linux/ceph/rados.h    | 225 ++++++++++++++----------
 net/ceph/Kconfig              |   1 +
 net/ceph/ceph_common.c        |  15 +-
 net/ceph/ceph_strings.c       |  75 +-------
 net/ceph/debugfs.c            |   3 +-
 net/ceph/messenger.c          |  28 +--
 net/ceph/mon_client.c         |   8 +-
 net/ceph/osd_client.c         | 192 +++++++++-----------
 net/ceph/osdmap.c             |  52 +++---
 net/ceph/pagelist.c           |   7 +-
 25 files changed, 948 insertions(+), 623 deletions(-)
