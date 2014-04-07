Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbaDGRBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:01:06 -0400
Received: from cobra.newdream.net ([66.33.216.30]:37493 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaDGRBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:01:05 -0400
Date: Mon, 7 Apr 2014 10:01:04 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates
Message-ID: <alpine.DEB.2.00.1404062303350.11637@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

The biggest chunk is a series of patches from Ilya that add support for 
new Ceph osd and crush map features, including some new tunables, primary 
affinity, and the new encoding that is needed for erasure coding support.  
This brings things into parity with the server side and the looming 
firefly release.  There is also support for allocation hints in RBD that 
help limit fragmentation on the server side.

There is also a series of patches from Zheng fixing NFS reexport, 
directory fragmentation support, flock vs fnctl behavior, and some issues 
with clustered MDS.

Finally, there are some miscellaneous fixes from Yunchuan Wen for 
fscache, Fabian Frederick for ACLs, and from me for fsync(dirfd) 
behavior.

Thanks-
sage


----------------------------------------------------------------
Fabian Frederick (1):
      ceph: Remove get/set acl on symlinks

Ilya Dryomov (48):
      libceph: a per-osdc crush scratch buffer
      rbd: remove out_partial label in rbd_img_request_fill()
      rbd: fix error paths in rbd_img_request_fill()
      libceph: encode CEPH_OSD_OP_FLAG_* op flags
      libceph: add support for CEPH_OSD_OP_SETALLOCHINT osd op
      libceph: bump CEPH_OSD_MAX_OP to 3
      rbd: num_ops parameter for rbd_osd_req_create()
      rbd: prefix rbd writes with CEPH_OSD_OP_SETALLOCHINT osd op
      crush: fix off-by-one errors in total_tries refactor
      crush: allow crush rules to set (re)tries counts to 0
      crush: add chooseleaf_vary_r tunable
      crush: add SET_CHOOSELEAF_VARY_R step
      crush: support chooseleaf_vary_r tunable (tunables3) by default
      libceph: refer to osdmap directly in osdmap_show()
      libceph: do not prefix osd lines with \t in debugfs output
      libceph: dump pg_temp mappings to debugfs
      libceph: dump osdmap and enhance output on decode errors
      libceph: split osdmap allocation and decode steps
      libceph: fixup error handling in osdmap_decode()
      libceph: safely decode max_osd value in osdmap_decode()
      libceph: check length of osdmap osd arrays
      libceph: fix crush_decode() call site in osdmap_decode()
      libceph: fixup error handling in osdmap_apply_incremental()
      libceph: nuke bogus encoding version check in osdmap_apply_incremental()
      libceph: fix and clarify ceph_decode_need() sizes
      libceph: rename __decode_pool{,_names}() to decode_pool{,_names}()
      libceph: introduce decode{,_new}_pools() and switch to them
      libceph: switch osdmap_set_max_osd() to krealloc()
      libceph: introduce decode{,_new}_pg_temp() and switch to them
      libceph: introduce get_osdmap_client_data_v()
      libceph: generalize ceph_pg_mapping
      libceph: primary_temp infrastructure
      libceph: primary_temp decode bits
      libceph: primary_affinity infrastructure
      libceph: primary_affinity decode bits
      libceph: enable OSDMAP_ENC feature bit
      libceph: ceph_osd_{exists,is_up,is_down}(osd) definitions
      libceph: ceph_can_shift_osds(pool) and pool type defines
      libceph: introduce pg_to_raw_osds() and raw_to_up_osds() helpers
      libceph: introduce apply_temps() helper
      libceph: switch ceph_calc_pg_acting() to new helpers
      libceph: return primary from ceph_calc_pg_acting()
      libceph: add support for primary_temp mappings
      libceph: add support for osd primary affinity
      libceph: redo ceph_calc_pg_primary() in terms of ceph_calc_pg_acting()
      libceph: enable PRIMARY_AFFINITY feature bit
      libceph: output primary affinity values on osdmap updates
      libceph: dump pool {read,write}_tier to debugfs

Sage Weil (4):
      ceph: avoid useless ceph_get_dentry_parent_inode() in ceph_rename()
      ceph: do not chain inode updates to parent fsync
      ceph: do not assume r_old_dentry[_dir] always set together
      ceph: do not set r_old_dentry_dir on link()

Yan, Zheng (23):
      ceph: fix ceph_dir_llseek()
      ceph: fix reset_readdir()
      ceph: let MDS adjust readdir 'frag'
      ceph: simplify ceph_fh_to_dentry()
      ceph: add get_parent() NFS export callback
      ceph: fix ceph_fh_to_parent()
      ceph: add get_name() NFS export callback
      ceph: print inode number for LOOKUPINO request
      ceph: make sure write caps are registered with auth MDS
      ceph: update i_max_size even if inode version does not change
      ceph: use fl->fl_type to decide flock operation
      ceph: forbid mandatory file lock
      ceph: use fl->fl_file as owner identifier of flock and posix lock
      ceph: set mds_wanted when MDS reply changes a cap to auth cap
      libceph: fix oops in ceph_msg_data_{pages,pagelist}_advance()
      ceph: fix null pointer dereference in discard_cap_releases()
      ceph: check buffer size in ceph_vxattrcb_layout()
      ceph: don't include ceph.{file,dir}.layout vxattr in listxattr()
      ceph: preallocate buffer for readdir reply
      ceph: drop extra open file reference in ceph_atomic_open()
      ceph: don't grabs open file reference for aborted request
      ceph: flush cap release queue when trimming session caps
      ceph: skip invalid dentry during dcache readdir

Yunchuan Wen (3):
      ceph: fscache: add an interface to synchronize object store limit
      ceph: fscache: Update object store limit after file writing
      ceph: fscache: Wait for completion of object initialization

 drivers/block/rbd.c                |   87 +++-
 fs/ceph/cache.c                    |    1 +
 fs/ceph/cache.h                    |   10 +
 fs/ceph/caps.c                     |    9 +-
 fs/ceph/debugfs.c                  |    5 +-
 fs/ceph/dir.c                      |   53 +-
 fs/ceph/export.c                   |  267 +++++-----
 fs/ceph/file.c                     |    8 +-
 fs/ceph/inode.c                    |   76 ++-
 fs/ceph/ioctl.c                    |    5 +-
 fs/ceph/locks.c                    |   98 ++--
 fs/ceph/mds_client.c               |   97 +++-
 fs/ceph/mds_client.h               |    4 +-
 fs/ceph/strings.c                  |    1 +
 fs/ceph/super.c                    |    1 +
 fs/ceph/super.h                    |    3 +-
 fs/ceph/xattr.c                    |   48 +-
 include/linux/ceph/ceph_features.h |   12 +-
 include/linux/ceph/ceph_fs.h       |    5 +-
 include/linux/ceph/osd_client.h    |   11 +-
 include/linux/ceph/osdmap.h        |   50 +-
 include/linux/ceph/rados.h         |   18 +-
 include/linux/crush/crush.h        |    7 +
 net/ceph/crush/mapper.c            |   85 ++-
 net/ceph/debugfs.c                 |   55 +-
 net/ceph/messenger.c               |    6 +
 net/ceph/osd_client.c              |   41 +-
 net/ceph/osdmap.c                  |  993 ++++++++++++++++++++++++++----------
 28 files changed, 1421 insertions(+), 635 deletions(-)
