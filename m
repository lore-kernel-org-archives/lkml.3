Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaA1SkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:40:19 -0500
Received: from cobra.newdream.net ([66.33.216.30]:46606 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaA1SkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:40:17 -0500
Date: Tue, 28 Jan 2014 10:40:16 -0800 (PST)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for -rc1
Message-ID: <alpine.DEB.2.00.1401281032560.16427@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

This is a big batch.  From Ilya we have:

 - rbd support for more than ~250 mapped devices (now uses same scheme 
   that SCSI does for device major/minor numbering)
 - crush updates for new mapping behaviors (will be needed for coming 
   erasure coding support, among other things)
 - preliminary support for tiered storage pools

There is also a big series fixing a pile cephfs bugs with clustered MDSs 
from Yan Zheng, ACL support for cephfs from Guangliang Zhao, ceph fscache 
improvements from Li Wang, improved behavior when we get ENOSPC from Josh 
Durgin, some readv/writev improvements from Majianpeng, and the usual mix 
of small cleanups.

Thanks!
sage


----------------------------------------------------------------
Alex Elder (1):
      MAINTAINERS: update an e-mail address

Guangliang Zhao (1):
      ceph: add acl for cephfs

Ilya Dryomov (51):
      rbd: rbd_device::dev_id is an int, format it as such
      rbd: tweak "loaded" message and module description
      rbd: refactor rbd_init() a bit
      rbd: switch to ida for rbd id assignments
      rbd: add 'minor' sysfs rbd device attribute
      rbd: wire up is_visible() sysfs callback for rbd bus
      rbd: add support for single-major device number allocation scheme
      rbd: enable extended devt in single-major mode
      rbd: introduce rbd_dev_header_unwatch_sync() and switch to it
      rbd: tear down watch request if rbd_dev_device_setup() fails
      libceph: all features fields must be u64
      libceph: update ceph_features.h
      crush: pass weight vector size to map function
      crush: factor out (trivial) crush_destroy_rule()
      crush: reduce scope of some local variables
      crush: fix some comments
      crush: eliminate CRUSH_MAX_SET result size limitation
      crush: return CRUSH_ITEM_UNDEF for failed placements with indep
      crush: use breadth-first search for indep mode
      crush: add note about r in recursive choose
      crush: strip firstn conditionals out of crush_choose, rename
      crush: clarify numrep vs endpos
      crush: pass parent r value for indep call
      crush: new SET_CHOOSE_LEAF_TRIES command
      crush: apply chooseleaf_tries to firstn mode too
      crush: add SET_CHOOSE_TRIES rule step
      crush: CHOOSE_LEAF -> CHOOSELEAF throughout
      crush: generalize descend_once
      crush: add set_choose_local_[fallback_]tries steps
      crush: attempts -> tries
      crush: fix crush_choose_firstn comment
      crush: support new indep mode and SET_* steps (crush v2) by default
      libceph: use CEPH_MON_PORT when the specified port is 0
      libceph: rename ceph_msg::front_max to front_alloc_len
      libceph: rename front to front_len in get_reply()
      libceph: fix preallocation check in get_reply()
      libceph: add ceph_kv{malloc,free}() and switch to them
      libceph: dout() is missing a newline
      libceph: start using oloc abstraction
      libceph: move ceph_file_layout helpers to ceph_fs.h
      libceph: rename MAX_OBJ_NAME_SIZE to CEPH_MAX_OID_NAME_LEN
      libceph: introduce and start using oid abstraction
      libceph: replace ceph_calc_ceph_pg() with ceph_oloc_oid_to_pg()
      libceph: CEPH_OSD_FLAG_* enum update
      libceph: add ceph_pg_pool_by_id()
      libceph: follow {read,write}_tier fields on osd request submission
      libceph: rename ceph_osd_request::r_{oloc,oid} to r_base_{oloc,oid}
      libceph: follow redirect replies from osds
      libceph: support CEPH_FEATURE_OSD_CACHEPOOL feature
      ceph: fix dout() compile warnings in ceph_filemap_fault()
      ceph: cast PAGE_SIZE to size_t in ceph_sync_write()

J. Bruce Fields (1):
      ceph: trivial comment fix

Josh Durgin (2):
      libceph: block I/O when PAUSE or FULL osd map flags are set
      libceph: resend all writes after the osdmap loses the full flag

Li Wang (4):
      ceph: Clean up if error occurred in finish_read()
      ceph: Add necessary clean up if invalid reply received in handle_reply()
      ceph fscache: Introduce a routine for uncaching single no data page from fscache
      ceph fscache: Uncaching no data page from fscache in readpage()

Libo Chen (1):
      fs: ceph: new helper: file_inode(file)

Yan, Zheng (13):
      ceph: drop unconnected inodes
      ceph: check caps in filemap_fault and page_mkwrite
      ceph: handle cap export race in try_flush_caps()
      ceph: use ceph_seq_cmp() to compare migrate_seq
      ceph: fix cache revoke race
      ceph: fix trim caps
      ceph: handle -ESTALE reply
      ceph: check inode caps in ceph_d_revalidate
      ceph: handle session flush message
      ceph: remove exported caps when handling cap import message
      ceph: add open export target session helper
      ceph: add imported caps when handling cap export message
      libceph: support CEPH_FEATURE_EXPORT_PEER

majianpeng (2):
      ceph: Implement writev/pwritev for sync operation.
      ceph: implement readv/preadv for sync operation

 Documentation/ABI/testing/sysfs-bus-rbd |  26 ++
 MAINTAINERS                             |   2 +-
 drivers/block/rbd.c                     | 303 ++++++++++++++--------
 fs/ceph/Kconfig                         |  13 +
 fs/ceph/Makefile                        |   1 +
 fs/ceph/acl.c                           | 332 ++++++++++++++++++++++++
 fs/ceph/addr.c                          |  93 ++++++-
 fs/ceph/cache.h                         |  13 +
 fs/ceph/caps.c                          | 338 +++++++++++++++---------
 fs/ceph/dir.c                           |  16 +-
 fs/ceph/file.c                          | 437 ++++++++++++++++++++++----------
 fs/ceph/inode.c                         |  33 ++-
 fs/ceph/ioctl.c                         |   8 +-
 fs/ceph/mds_client.c                    | 132 ++++++----
 fs/ceph/mds_client.h                    |   2 +
 fs/ceph/strings.c                       |   2 +
 fs/ceph/super.c                         |   9 +-
 fs/ceph/super.h                         |  45 +++-
 fs/ceph/xattr.c                         |  60 ++++-
 include/linux/ceph/buffer.h             |   1 -
 include/linux/ceph/ceph_features.h      | 101 +++++---
 include/linux/ceph/ceph_fs.h            |  36 ++-
 include/linux/ceph/libceph.h            |  19 +-
 include/linux/ceph/messenger.h          |  13 +-
 include/linux/ceph/osd_client.h         |  19 +-
 include/linux/ceph/osdmap.h             |  66 +++--
 include/linux/ceph/rados.h              |   4 +
 include/linux/crush/crush.h             |  20 +-
 include/linux/crush/mapper.h            |   3 +-
 net/ceph/buffer.c                       |  22 +-
 net/ceph/ceph_common.c                  |  24 +-
 net/ceph/crush/crush.c                  |   7 +-
 net/ceph/crush/mapper.c                 | 336 +++++++++++++++++++-----
 net/ceph/debugfs.c                      |   3 +-
 net/ceph/messenger.c                    |  32 +--
 net/ceph/mon_client.c                   |   8 +-
 net/ceph/osd_client.c                   | 283 +++++++++++++++++++--
 net/ceph/osdmap.c                       |  78 ++++--
 38 files changed, 2261 insertions(+), 679 deletions(-)
 create mode 100644 fs/ceph/acl.c
