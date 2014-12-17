Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaLQX1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 18:27:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284AbaLQX1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 18:27:23 -0500
Date: Wed, 17 Dec 2014 15:27:19 -0800 (PST)
From: Sage Weil <sweil@redhat.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 3.19-rc1
Message-ID: <alpine.DEB.2.00.1412171520460.5263@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

The big item here is support for inline data for CephFS and for message 
signatures from Zheng.  There are also several bug fixes, including 
interrupted flock request handling, 0-length xattrs, mksnap, cached 
readdir results, and a message version compat field.  Finally there are 
several cleanups from Ilya, Dan, and Markus.

Note that there is another series coming soon that fixes some bugs in the 
RBD 'lingering' requests, but it isn't quite ready yet.

Thanks!
sage


----------------------------------------------------------------
Dan Carpenter (1):
      ceph: do_sync is never initialized

Ilya Dryomov (4):
      libceph: nuke ceph_kvfree()
      ceph: remove unused stringification macros
      rbd: don't treat CEPH_OSD_OP_DELETE as extent op
      libceph: fixup includes in pagelist.h

John Spray (2):
      libceph: update ceph_msg_header structure
      ceph: message versioning fixes

SF Markus Elfring (1):
      ceph, rbd: delete unnecessary checks before two function calls

Yan, Zheng (19):
      ceph: fix file lock interruption
      ceph: introduce a new inode flag indicating if cached dentries are ordered
      libceph: store session key in cephx authorizer
      libceph: message signature support
      ceph: introduce global empty snap context
      libceph: require cephx message signature by default
      libceph: add SETXATTR/CMPXATTR osd operations support
      libceph: add CREATE osd operation support
      libceph: specify position of extent operation
      ceph: parse inline data in MClientReply and MClientCaps
      ceph: add inline data to pagecache
      ceph: use getattr request to fetch inline data
      ceph: fetch inline data when getting Fcr cap refs
      ceph: sync read inline data
      ceph: convert inline data to normal data before data write
      ceph: flush inline version
      ceph: support inline data feature
      ceph: fix mksnap crash
      ceph: fix setting empty extended attribute

 drivers/block/rbd.c                |  11 +-
 fs/ceph/addr.c                     | 273 +++++++++++++++++++++++++++++++++++--
 fs/ceph/caps.c                     | 132 ++++++++++++++----
 fs/ceph/dir.c                      |  27 ++--
 fs/ceph/file.c                     |  97 +++++++++++--
 fs/ceph/inode.c                    |  59 ++++++--
 fs/ceph/locks.c                    |  64 +++++++--
 fs/ceph/mds_client.c               |  41 +++++-
 fs/ceph/mds_client.h               |  10 ++
 fs/ceph/snap.c                     |  37 ++++-
 fs/ceph/super.c                    |  16 ++-
 fs/ceph/super.h                    |  55 ++++++--
 fs/ceph/super.h.rej                |  10 ++
 fs/ceph/xattr.c                    |   7 +-
 include/linux/ceph/auth.h          |  26 ++++
 include/linux/ceph/buffer.h        |   3 +-
 include/linux/ceph/ceph_features.h |   1 +
 include/linux/ceph/ceph_fs.h       |  10 +-
 include/linux/ceph/libceph.h       |   2 +-
 include/linux/ceph/messenger.h     |   9 +-
 include/linux/ceph/msgr.h          |  11 +-
 include/linux/ceph/osd_client.h    |  13 +-
 include/linux/ceph/pagelist.h      |   4 +-
 net/ceph/auth_x.c                  |  76 ++++++++++-
 net/ceph/auth_x.h                  |   1 +
 net/ceph/buffer.c                  |   4 +-
 net/ceph/ceph_common.c             |  21 +--
 net/ceph/messenger.c               |  34 ++++-
 net/ceph/osd_client.c              | 118 ++++++++++++----
 29 files changed, 992 insertions(+), 180 deletions(-)
 create mode 100644 fs/ceph/super.h.rej
