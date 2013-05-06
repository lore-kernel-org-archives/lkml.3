Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab3EFSxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:53:07 -0400
Received: from cobra.newdream.net ([66.33.216.30]:41500 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab3EFSxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:53:05 -0400
Date: Mon, 6 May 2013 11:53:05 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph changes for 3.10
Message-ID: <alpine.DEB.2.00.1305061149210.23590@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph patches from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

This is a big pull.  Most of it is culmination of Alex's work to implement 
RBD image layering, which is now complete (yay!).  There is also some work 
from Yan to fix i_mutex behavior surrounding writes in cephfs, a sync 
write fix, a fix for RBD images that get resized while they are mapped, 
and a few patches from me that resolve annoying auth warnings and fix 
several bugs in the ceph auth code.

Thanks!
sage


----------------------------------------------------------------
Alex Elder (232):
      libceph: fix a osd request memory leak
      libceph: make ceph_msg->bio_seg be unsigned
      libceph: pass object number back to calc_layout() caller
      libceph: format target object name in caller
      libceph: don't pass request to calc_layout()
      libceph: distinguish page array and pagelist count
      libceph: set page alignment in start_request()
      libceph: complete lingering requests only once
      libceph: fix wrong opcode use in osd_req_encode_op()
      libceph: use (void *) for untyped data in osd ops
      libceph: kill ceph_msg->pagelist_count
      libceph: rename ceph_calc_object_layout()
      libceph: drop mutex while allocating a message
      libceph: define mds_alloc_msg() method
      libceph: no need for alignment for mds message
      ceph: use calc_pages_for() in start_read()
      ceph: simplify ceph_sync_write() page_align calculation
      libceph: don't assign page info in ceph_osdc_new_request()
      libceph: separate osd request data info
      libceph: distinguish page and bio requests
      libceph: separate read and write data
      libceph: clean up skipped message logic
      libceph: define CEPH_MSG_MAX_MIDDLE_LEN
      libceph: minor byte order problems in read_partial_message()
      libceph: change type of ceph_tcp_sendpage() "more"
      libceph: kill args in read_partial_message_bio()
      libceph: define and use in_msg_pos_next()
      libceph: advance pagelist with list_rotate_left()
      libceph: simplify new message initialization
      libceph: record byte count not page count
      libceph: isolate message page field manipulation
      libceph: set page info with byte length
      libceph: isolate other message data fields
      ceph: only set message data pointers if non-empty
      libceph: record message data byte length
      libceph: set response data fields earlier
      libceph: activate message data assignment checks
      libceph: don't clear bio_iter in prepare_write_message()
      libceph: use local variables for message positions
      libceph: consolidate message prep code
      libceph: small write_partial_msg_pages() refactor
      libceph: encapsulate reading message data
      libceph: define and use ceph_tcp_recvpage()
      libceph: define and use ceph_crc32c_page()
      libceph: define ceph_msg_has_*() data macros
      libceph: be explicit about message data representation
      libceph: abstract message data
      libceph: start defining message data cursor
      libceph: prepare for other message data item types
      libceph: use data cursor for message pagelist
      libceph: implement bio message data item cursor
      libceph: implement pages array cursor
      libceph: let osd ops determine request data length
      libceph: have osd requests support pagelist data
      libceph: kill osd request r_trail
      libceph: kill message trail
      libceph: more cleanup of write_partial_msg_pages()
      libceph: slightly defer registering osd request
      libceph: no more kick_requests() race
      libceph: requeue only sent requests when kicking
      libceph: keep request lists in tid order
      libceph: send queued requests when starting new one
      libceph: initialize data fields on last msg put
      libceph: drop pages parameter
      libceph: record residual bytes for all message data types
      libceph: use cursor for bio reads
      libceph: kill ceph message bio_iter, bio_seg
      libceph: use cursor for inbound data pages
      libceph: no outbound zero data
      libceph: get rid of read helpers
      libceph: collapse all data items into one
      libceph: use cursor resid for loop condition
      libceph: kill most of ceph_msg_pos
      libceph: kill last of ceph_msg_pos
      libceph: don't add to crc unless data sent
      libceph: use only ceph_msg_data_advance()
      libceph: make message data be a pointer
      libceph: fix broken data length assertions
      libceph: page offset must be less than page size
      libceph: account for alignment in pages cursor
      libceph: be explicit in masking bottom 16 bits
      ceph: move max constant definitions
      libceph: define osd_req_opcode_valid()
      libceph: define source request op functions
      libceph: pass offset and length out of calc_layout()
      libceph: don't update op in calc_layout()
      libceph: clean up ceph_osd_new_request()
      libceph: use osd_req_op_extent_init()
      ceph: set up page array mempool with correct size
      libceph: drop mutex on error in handle_reply()
      libceph: define ceph_decode_pgid() only once
      ceph: use page_offset() in ceph_writepages_start()
      libceph: drop ceph_osd_request->r_con_filling_msg
      libceph: record length of bio list with bio
      libceph: record message data length
      libceph: don't build request in ceph_osdc_new_request()
      ceph: define ceph_writepages_osd_request()
      ceph: kill ceph alloc_page_vec()
      libceph: hold off building osd request
      ceph: build osd request message later for writepages
      libceph: provide data length when preparing message
      rbd: define inbound data size for method ops
      libceph: compute incoming bytes once
      libceph: define osd data initialization helpers
      libceph: define a few more helpers
      libceph: define ceph_osd_data_length()
      libceph: a few more osd data cleanups
      rbd: define rbd_osd_req_format_op()
      libceph: keep source rather than message osd op array
      libceph: rename data out field in osd request op
      libceph: add data pointers in osd op structures
      libceph: specify osd op by index in request
      rbd: don't set data in rbd_osd_req_format_op()
      rbd: separate initialization of osd data
      rbd: rearrange some code for consistency
      libceph: format class info at init time
      libceph: move ceph_osdc_build_request()
      libceph: set message data when building osd request
      libceph: combine initializing and setting osd data
      libceph: set the data pointers when encoding ops
      libceph: kill off osd request r_data_in and r_data_out
      libceph: fix possible CONFIG_BLOCK build problem
      libceph: skip message if too big to receive
      libceph: record bio length
      libceph: move cursor into message
      libceph: have cursor point to data
      libceph: replace message data pointer with list
      libceph: implement multiple data items in a message
      libceph: add, don't set data for a message
      libceph: make method call data be a separate data item
      rbd: update feature bits
      rbd: record overall image request result
      rbd: record aggregate image transfer count
      rbd: record image-relative offset in object requests
      rbd: define image request flags
      rbd: define image request originator flag
      rbd: define image request layered flag
      rbd: encapsulate image object end request handling
      rbd: define an rbd object request flags field
      rbd: add an object request flag for image data objects
      rbd: probe the parent of an image if present
      rbd: implement layered reads
      ceph: let osd client clean up for interrupted request
      libceph: change how "safe" callback is used
      libceph: kill off osd data write_request parameters
      libceph: clean up osd data field access functions
      libceph: support raw data requests
      rbd: adjust image object request ref counting
      rbd: always check IMG_DATA flag
      rbd: add target object existence flags
      rbd: issue stat request before layered write
      libceph: fix two messenger bugs
      libceph: support pages for class request data
      rbd: define separate read and write format funcs
      rbd: encapsulate submission of image object requests
      rbd: define zero_pages()
      rbd: support page array image requests
      rbd: implement full object parent reads
      rbd: issue a copyup for layered writes
      rbd: enforce parent overlap
      libceph: add signed type limits
      libceph: validate timespec conversions
      rbd: give rbd_obj_read_sync() buffer void type
      rbd: void data pointers for rbd_obj_method_sync()
      rbd: have rbd_obj_method_sync() return transfer count
      rbd: get and check striping parameters
      rbd: activate support for layered images
      libceph: fix byte order mismatch
      rbd: don't create sysfs entries for non-mapped snapshots
      rbd: fix leak of snapshots during initial probe
      rbd: make snap_size order parameter optional
      rbd: only update values on snap_info success
      rbd: rename __rbd_add_snap_dev()
      rbd: fix leak of format 2 snapshot names
      rbd: use rbd_obj_method_sync() return value
      rbd: avoid dropping extra reference in rbd_free_disk()
      rbd: have rbd_dev_image_id() set format 1 image id
      rbd: fix image id leak in initial probe
      rbd: have snap_by_name() return a snapshot
      rbd: set snapshot id in rbd_dev_probe_update_spec()
      rbd: make rbd spec names pointer to const
      rbd: move stripe_unit and stripe_count into header
      rbd: use rbd_warn(), not WARN_ON()
      rbd: define rbd snap context routines
      rbd: make rbd_dev_destroy() match rbd_dev_create()
      rbd: rename rbd_dev_probe()
      rbd: refactor rbd_dev_probe_update_spec()
      rbd: fix a bug in resizing a mapping
      rbd: fix up some sysfs stuff
      rbd: only set device exists flag when ready
      rbd: defer setting disk capacity
      rbd: encapsulate probing for parent devices
      rbd: encapsulate removing parent devices
      rbd: set mapping info earlier
      rbd: kill __rbd_remove()
      rbd: fix rbd_dev_remove_parent()
      rbd: remove parent devices on probe error
      rbd: probe for the parent earlier
      rbd: move more initialization into rbd_dev_image_probe()
      rbd: define rbd_header_name()
      rbd: don't clean up watch in device release function
      rbd: don't bother checking whether order changes
      rbd: set up watch in rbd_dev_image_probe()
      rbd: drop module later
      rbd: don't destroy rbd_dev in device release function
      rbd: define rbd_dev_unprobe()
      rbd: don't have device release destroy rbd_dev
      rbd: set up devices only for mapped images
      libceph: create source file "net/ceph/snapshot.c"
      ceph: use ceph_create_snap_context()
      rbd: fix up the layering warning message
      rbd: don't revalidate so much
      rbd: snap names are pointer to constant data
      rbd: stop tracking header object version
      rbd: get rid of some version parameters
      rbd: more version parameter removal
      rbd: drop rbd_obj_method_sync() version parameter
      rbd: drop obj_request->version
      rbd: look up snapshot name in names buffer
      rbd: use snap_id not index to look up snap info
      rbd: define rbd_snap_size() and rbd_snap_features()
      rbd: kill off the snapshot list
      rbd: clear EXISTS flag if mapped snapshot disappears
      rbd: use binary search for snapshot lookup
      rbd: allocate image requests with a slab allocator
      rbd: allocate name separate from obj_request
      rbd: allocate object requests with a slab allocator
      rbd: allocate image object names with a slab allocator
      libceph: allocate ceph messages with a slab allocator
      libceph: allocate ceph message data with a slab allocator
      libceph: use slab cache for osd client requests
      rbd: fix image request leak on parent read

Henry C Chang (1):
      ceph: fix buffer pointer advance in ceph_sync_write

Laurent Barbe (1):
      rbd: revalidate_disk upon rbd resize

Randy Dunlap (1):
      ceph: fix printk format warnings in file.c

Sage Weil (7):
      ceph: revert commit 22cddde104
      libceph: implement RECONNECT_SEQ feature
      libceph: clear messenger auth_retry flag when we authenticate
      libceph: fix authorizer invalidation
      libceph: add update_authorizer auth method
      libceph: wrap auth ops in wrapper functions
      libceph: wrap auth methods in a mutex

Sam Lang (1):
      ceph: Use pseudo-random numbers to choose mds

Yan, Zheng (11):
      ceph: fix LSSNAP regression
      ceph: queue cap release when trimming cap
      ceph: set mds_want according to cap import message
      ceph: use I_COMPLETE inode flag instead of D_COMPLETE flag
      ceph: don't early drop Fw cap
      ceph: acquire i_mutex in __ceph_do_pending_vmtruncate
      ceph: use i_release_count to indicate dir's completeness
      ceph: fix symlink inode operations
      ceph: take i_mutex before getting Fw cap
      ceph: apply write checks in ceph_aio_write
      ceph: fix race between writepages and truncate

 Documentation/ABI/testing/sysfs-bus-rbd |   20 -
 drivers/block/rbd.c                     | 2868 ++++++++++++++++++++-----------
 fs/ceph/addr.c                          |  222 ++-
 fs/ceph/caps.c                          |   33 +-
 fs/ceph/dir.c                           |   65 +-
 fs/ceph/file.c                          |  241 +--
 fs/ceph/inode.c                         |   59 +-
 fs/ceph/ioctl.c                         |    5 +-
 fs/ceph/mds_client.c                    |   79 +-
 fs/ceph/mdsmap.c                        |    8 +-
 fs/ceph/snap.c                          |    3 +-
 fs/ceph/super.c                         |    7 +-
 fs/ceph/super.h                         |   65 +-
 include/linux/ceph/auth.h               |   18 +
 include/linux/ceph/ceph_features.h      |    2 +
 include/linux/ceph/decode.h             |   30 +-
 include/linux/ceph/libceph.h            |   31 +-
 include/linux/ceph/messenger.h          |  104 +-
 include/linux/ceph/msgr.h               |    1 +
 include/linux/ceph/osd_client.h         |  204 ++-
 include/linux/ceph/osdmap.h             |   30 +-
 net/ceph/Makefile                       |    2 +-
 net/ceph/auth.c                         |  117 +-
 net/ceph/auth_x.c                       |   24 +-
 net/ceph/auth_x.h                       |    1 +
 net/ceph/ceph_common.c                  |    7 +
 net/ceph/debugfs.c                      |    4 +-
 net/ceph/messenger.c                    | 1019 +++++++----
 net/ceph/mon_client.c                   |    7 +-
 net/ceph/osd_client.c                   | 1087 ++++++++----
 net/ceph/osdmap.c                       |   45 +-
 net/ceph/snapshot.c                     |   78 +
 32 files changed, 4201 insertions(+), 2285 deletions(-)
 create mode 100644 net/ceph/snapshot.c
