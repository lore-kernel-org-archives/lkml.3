Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaFMAJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 20:09:58 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43672 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaFMAJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 20:09:57 -0400
Date: Thu, 12 Jun 2014 17:09:56 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph changes for 3.16-rc1
Message-ID: <alpine.DEB.2.00.1406121007100.7864@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

This pull has a mix of bug fixes and cleanups. Alex's patch fixes a rare 
race in RBD.  Ilya's patches fix an ENOENT check when a second rbd image 
is mapped and a couple memory leaks.  Zheng fixes several issues with 
fragmented directories and multiple MDSs.  Josh fixes a spin/sleep issue, 
and Josh and Guangliang's patches fix setting and unsetting RBD images 
read-only. Naturally there are several other cleanups mixed in for good 
measure.

Thanks!
sage


----------------------------------------------------------------
Alex Elder (1):
      rbd: use reference counts for image requests

Duan Jiong (1):
      rbd: replace IS_ERR and PTR_ERR with PTR_ERR_OR_ZERO

Fengguang Wu (1):
      ceph: ceph_get_parent() can be static

Guangliang Zhao (1):
      rbd: add ioctl for rbd

Ilya Dryomov (6):
      libceph: recognize poolop requests in debugfs
      libceph: mon_get_version request infrastructure
      libceph: add ceph_monc_wait_osdmap()
      rbd: make sure we have latest osdmap on 'rbd map'
      rbd: fix osd_request memory leak in __rbd_dev_header_watch_sync()
      rbd: fix ida/idr memory leak

Josh Durgin (2):
      rbd: move calls that may sleep out of spin lock range
      rbd: only set disk to read-only once

Sage Weil (1):
      ceph: include time stamp in every MDS request

Yan, Zheng (8):
      ceph: queue vmtruncate if necessary when handing cap grant/revoke
      ceph: update inode fields according to issued caps
      ceph: pre-allocate ceph_cap struct for ceph_add_cap()
      ceph: handle cap import atomically
      ceph: introduce ceph_fill_fragtree()
      ceph: remember subtree root dirfrag's auth MDS
      mds: check cap ID when handling cap export message
      ceph: use truncate_pagecache() instead of truncate_inode_pages()

Zhang Zhen (2):
      ceph: remove useless ACL check
      ceph: refactor readpage_nounlock() to make the logic clearer

 drivers/block/rbd.c             | 242 +++++++++++++++++++++++++++++++--------
 fs/ceph/acl.c                   |   6 -
 fs/ceph/addr.c                  |  17 ++-
 fs/ceph/caps.c                  | 246 ++++++++++++++++++++-------------------
 fs/ceph/export.c                |   2 +-
 fs/ceph/inode.c                 | 247 +++++++++++++++++++++++++---------------
 fs/ceph/mds_client.c            |   9 +-
 fs/ceph/mds_client.h            |   1 +
 fs/ceph/super.h                 |  13 ++-
 include/linux/ceph/ceph_fs.h    |   2 +
 include/linux/ceph/mon_client.h |  11 +-
 net/ceph/ceph_common.c          |   2 +
 net/ceph/debugfs.c              |   8 +-
 net/ceph/mon_client.c           | 150 +++++++++++++++++++++++-
 14 files changed, 670 insertions(+), 286 deletions(-)
