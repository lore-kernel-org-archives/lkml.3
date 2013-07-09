Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3GITax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 15:30:53 -0400
Received: from cobra.newdream.net ([66.33.216.30]:47571 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab3GITaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 15:30:52 -0400
Date: Tue, 9 Jul 2013 12:30:51 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 3.11
Message-ID: <alpine.DEB.2.00.1307091227150.19631@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

There is some follow-on RBD cleanup after the last window's code drop, a 
series from Yan fixing multi-mds behavior in cephfs, and then a sprinkling 
of bug fixes all around.  Some warnings, sleeping while atomic, a null 
dereference, and cleanups.

Thanks!
sage


----------------------------------------------------------------
Alex Elder (11):
      rbd: drop original request earlier for existence check
      libceph: add lingering request reference when registered
      rbd: flush dcache after zeroing page data
      rbd: clean up a few things in the refresh path
      rbd: protect against duplicate client creation
      libceph: print more info for short message header
      rbd: set removing flag while holding list lock
      rbd: protect against concurrent unmaps
      rbd: don't hold ctl_mutex to get/put device
      rbd: use rwsem to protect header updates
      rbd: take a little credit

Dan Carpenter (1):
      ceph: tidy ceph_mdsmap_decode() a little

Emil Goode (1):
      ceph: improve error handling in ceph_mdsmap_decode

Geert Uytterhoeven (1):
      rbd: Use min_t() to fix comparison of distinct pointer types warning

Jianpeng Ma (1):
      ceph: remove sb_start/end_write in ceph_aio_write.

Jim Schutt (1):
      ceph: fix up comment for ceph_count_locks() as to which lock to hold

Josh Durgin (1):
      libceph: fix invalid unsigned->signed conversion for timespec encoding

Sage Weil (1):
      rbd: fix a couple warnings

Sasha Levin (1):
      ceph: avoid accessing invalid memory

Tyler Hicks (1):
      libceph: Fix NULL pointer dereference in auth client code

Yan, Zheng (12):
      libceph: fix safe completion
      libceph: fix truncate size calculation
      ceph: fix cap release race
      ceph: reset iov_len when discarding cap release messages
      ceph: fix race between page writeback and truncate
      ceph: check migrate seq before changing auth cap
      ceph: clear migrate seq when MDS restarts
      ceph: move inode to proper flushing list when auth MDS changes
      ceph: fix pending vmtruncate race
      ceph: fix cap revoke race
      ceph: fix race between cap issue and revoke
      libceph: call r_unsafe_callback when unsafe reply is received

majianpeng (4):
      ceph: fix sleeping function called from invalid context.
      ceph: avoid meaningless calling ceph_caps_revoking if sync_mode == WB_SYNC_ALL.
      ceph: Free mdsc if alloc mdsc->mdsmap failed.
      ceph: Reconstruct the func ceph_reserve_caps.

 drivers/block/rbd.c             | 174 +++++++++++++++++++++-------------------
 fs/ceph/addr.c                  |  88 ++++++++++----------
 fs/ceph/caps.c                  | 102 ++++++++++++++---------
 fs/ceph/file.c                  |   4 +-
 fs/ceph/inode.c                 |  14 ++--
 fs/ceph/locks.c                 |   2 +-
 fs/ceph/mds_client.c            |   6 +-
 fs/ceph/mdsmap.c                |  42 +++++-----
 fs/ceph/super.c                 |   2 +-
 fs/ceph/super.h                 |   4 +-
 fs/ceph/xattr.c                 |   9 ++-
 include/linux/ceph/decode.h     |   5 --
 include/linux/ceph/osd_client.h |   1 -
 net/ceph/auth_none.c            |   6 ++
 net/ceph/osd_client.c           |  63 ++++++++-------
 15 files changed, 277 insertions(+), 245 deletions(-)
