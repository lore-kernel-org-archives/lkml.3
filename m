Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab3B0Ey0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 23:54:26 -0500
Received: from cobra.newdream.net ([66.33.216.30]:55989 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758838Ab3B0EyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 23:54:23 -0500
Date: Tue, 26 Feb 2013 20:54:23 -0800 (PST)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 3.9-rc1
Message-ID: <alpine.DEB.2.00.1302261959060.26090@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

A few groups of patches here.  Alex has been hard at work improving the 
RBD code, layout groundwork for understanding the new formats and doing 
layering.  Most of the infrastructure is now in place for the final bits 
that will come with the next window.

There are a few changes to the data layout.  Jim Schutt's patch fixes some 
non-ideal CRUSH behavior, and a set of patches from me updates the client 
to speak a newer version of the protocol and implement an improved hashing 
strategy across storage nodes (when the server side supports it too).

A pair of patches from Sam Lang fix the atomicity of open+create 
operations.  Several patches from Yan, Zheng fix various mds/client issues 
that turned up during multi-mds torture tests.

A final set of patches expose file layouts via virtual xattrs, and allow 
the policies to be set on directories via xattrs as well (avoiding the 
awkward ioctl interface and providing a consistent interface for both 
kernel mount and ceph-fuse users).

Thanks!
sage



----------------------------------------------------------------
Alex Elder (118):
      libceph: reformat __reset_osd()
      rbd: document rbd_spec structure
      rbd: kill rbd_spec->image_name_len
      rbd: kill rbd_spec->image_id_len
      rbd: use kmemdup()
      ceph: define ceph_encode_8_safe()
      rbd: define and use rbd_warn()
      rbd: add warning messages for missing arguments
      rbd: add a warning in bio_chain_clone_range()
      rbd: add warnings to rbd_dev_probe_update_spec()
      rbd: standardize rbd_request variable names
      rbd: standardize ceph_osd_request variable names
      rbd: be picky about osd request status type
      rbd: encapsulate handling for a single request
      rbd: end request on error in rbd_do_request() caller
      rbd: a little more cleanup of rbd_rq_fn()
      rbd: make exists flag atomic
      rbd: only get snap context for write requests
      rbd: separate layout init
      rbd: drop oid parameters from ceph_osdc_build_request()
      rbd: drop snapid parameter from rbd_req_sync_read()
      rbd: drop flags parameter from rbd_req_sync_exec()
      rbd: kill rbd_req_sync_op() snapc and snapid parameters
      rbd: don't bother setting snapid in rbd_do_request()
      libceph: always allow trail in osd request
      libceph: kill op_needs_trail()
      libceph: pass length to ceph_osdc_build_request()
      libceph: pass length to ceph_calc_file_object_mapping()
      libceph: drop snapid in ceph_calc_raw_layout()
      libceph: drop osdc from ceph_calc_raw_layout()
      libceph: don't set flags in ceph_osdc_alloc_request()
      libceph: don't set pages or bio in ceph_osdc_alloc_request()
      rbd: pass num_op with ops array
      libceph: pass num_op with ops
      rbd: there is really only one op
      rbd: assume single op in a request
      rbd: kill ceph_osd_req_op->flags
      rbd: pull in ceph_calc_raw_layout()
      rbd: open code rbd_calc_raw_layout()
      rbd: don't bother calculating file mapping
      rbd: use a common layout for each device
      rbd: combine rbd sync watch/unwatch functions
      rbd: don't leak rbd_req on synchronous requests
      rbd: don't leak rbd_req for rbd_req_sync_notify_ack()
      rbd: don't assign extent info in rbd_do_request()
      rbd: don't assign extent info in rbd_req_sync_op()
      rbd: move call osd op setup into rbd_osd_req_op_create()
      rbd: move remaining osd op setup into rbd_osd_req_op_create()
      rbd: assign watch request more directly
      rbd: fix type of snap_id in rbd_dev_v2_snap_info()
      rbd: small changes
      rbd: check for overflow in rbd_get_num_segments()
      rbd: don't retry setting up header watch
      Merge branch 'testing' of github.com:ceph/ceph-client into v3.8-rc5-testing
      libceph: fix messenger CONFIG_BLOCK dependencies
      rbd: new request tracking code
      rbd: kill rbd_rq_fn() and all other related code
      rbd: kill rbd_req_coll and rbd_request
      rbd: implement sync object read with new code
      rbd: get rid of rbd_req_sync_read()
      rbd: implement watch/unwatch with new code
      rbd: get rid of rbd_req_sync_watch()
      rbd: use new code for notify ack
      rbd: get rid of rbd_req_sync_notify_ack()
      rbd: send notify ack asynchronously
      rbd: implement sync method with new code
      rbd: get rid of rbd_req_sync_exec()
      rbd: unregister linger in watch sync routine
      rbd: track object rather than osd request for watch
      rbd: decrement obj request count when deleting
      rbd: don't drop watch requests on completion
      rbd: define flags field, use it for exists flag
      rbd: prevent open for image being removed
      libceph: add a compatibility check interface
      rbd: don't take extra bio reference for osd client
      libceph: don't require r_num_pages for bio requests
      rbd: turn off interrupts for open/remove locking
      rbd: add barriers near done flag operations
      libceph: improve packing in struct ceph_osd_req_op
      ceph: kill ceph_osdc_writepages() "nofail" parameter
      ceph: kill ceph_osdc_writepages() "dosync" parameter
      ceph: kill ceph_osdc_writepages() "flags" parameter
      ceph: kill ceph_osdc_new_request() "num_reply" parameter
      libceph: lock outside send_queued()
      libdeph: don't export ceph_osdc_init() or ceph_osdc_stop()
      libceph: kill ceph_calc_raw_layout()
      libceph: kill ceph_osdc_create_event() "one_shot" parameter
      libceph: kill ceph_osdc_wait_event()
      libceph: update rados.h
      libceph: add ceph_osd_state_name()
      libceph: update ceph_osd_op_name()
      libceph: report defined but unsupported osd ops
      libceph: remove dead code in osd_req_encode_op()
      libceph: update ceph_fs.h
      libceph: update ceph_mds_state_name() and ceph_mds_op_name()
      libceph: simplify data length calculation
      rbd: add parentheses to object request iterator macros
      libceph: allow STAT osd operations
      ceph: remove a few bogus declarations
      libceph: use void pointers in page vector functions
      rbd: prevent bytes transferred overflow
      rbd: ignore result of ceph_copy_from_page_vector()
      libceph: drop return value from page vector copy routines
      Merge branch 'testing' of github.com:ceph/ceph-client into into linux-3.8-ceph
      rbd: ignore zero-length requests
      rbd: barriers are hard
      rbd: normalize dout() calls
      libceph: define connection flag helpers
      rbd: eliminate sparse warnings
      ceph: eliminate sparse warnings in fs code
      libceph: eliminate sparse warnings
      libceph: encapsulate connection backoff
      libceph: separate non-locked fault handling
      libceph: use a flag to indicate a fault has occurred
      libceph: use a do..while loop in con_work()
      rbd: move rbd_osd_trivial_callback()
      rbd: pass length, not op for osd completions
      ceph: update "ceph_features.h"

Cong Ding (1):
      libceph: fix undefined behavior when using snprintf()

Jim Schutt (1):
      libceph: for chooseleaf rules, retry CRUSH map descent from root if leaf is failed

Sage Weil (18):
      crush: avoid recursion if we have already collided
      ceph: remove 'ceph.layout' virtual xattr
      ceph: support hidden vxattrs
      ceph: pass unhandled ceph.* setxattrs through to MDS
      ceph: pass ceph.* removexattrs through to MDS
      ceph: add exists_cb to vxattr struct
      ceph: fix getxattr vxattr handling
      ceph: fix listxattr handling for vxattrs
      ceph: change ceph.file.layout.* implementation, content
      ceph: add ceph.dir.layout vxattr
      ceph: implement hidden per-field ceph.*.layout.* vxattrs
      ceph: fix statvfs fr_size
      libceph: rename ceph_pg -> ceph_pg_v1
      libceph: decode into cpu-native ceph_pg type
      ceph: update support for PGID64, PGPOOL3, OSDENC protocol features
      libceph: calculate placement based on the internal data types
      libceph: update osd request/reply encoding
      libceph: add support for HASHPSPOOL pool flag

Sam Lang (2):
      ceph: Check for err on mds request in atomic_open
      ceph: Check for created flag in response from mds

Yan, Zheng (5):
      ceph: re-calculate truncate_size for strip object
      ceph: move dirty inode to migrating list when clearing auth caps
      ceph: allow revoking duplicated caps issued by non-auth MDS
      ceph: allocate cap_release message when receiving cap import
      ceph: check mds_wanted for imported cap

 drivers/block/rbd.c                | 1852 ++++++++++++++++++++++--------------
 fs/ceph/addr.c                     |   38 +-
 fs/ceph/caps.c                     |   32 +-
 fs/ceph/file.c                     |    8 +-
 fs/ceph/ioctl.c                    |    6 +-
 fs/ceph/mds_client.c               |   33 +-
 fs/ceph/mds_client.h               |    6 +
 fs/ceph/mdsmap.c                   |   12 +-
 fs/ceph/strings.c                  |    4 +
 fs/ceph/super.c                    |    7 +-
 fs/ceph/super.h                    |   10 +-
 fs/ceph/xattr.c                    |  214 ++++-
 include/linux/ceph/ceph_features.h |   38 +-
 include/linux/ceph/ceph_fs.h       |   32 +-
 include/linux/ceph/decode.h        |   29 +-
 include/linux/ceph/libceph.h       |   16 +-
 include/linux/ceph/mdsmap.h        |    4 +-
 include/linux/ceph/messenger.h     |    2 +
 include/linux/ceph/osd_client.h    |   74 +-
 include/linux/ceph/osdmap.h        |   30 +-
 include/linux/ceph/rados.h         |  158 ++-
 include/linux/crush/crush.h        |    2 +
 net/ceph/ceph_common.c             |   22 +-
 net/ceph/ceph_strings.c            |   39 +
 net/ceph/crush/mapper.c            |   15 +-
 net/ceph/crypto.c                  |    7 +-
 net/ceph/debugfs.c                 |   29 +-
 net/ceph/messenger.c               |  260 +++--
 net/ceph/mon_client.c              |    2 +-
 net/ceph/osd_client.c              |  635 +++++++------
 net/ceph/osdmap.c                  |  290 +++---
 net/ceph/pagevec.c                 |   24 +-
 32 files changed, 2402 insertions(+), 1528 deletions(-)
