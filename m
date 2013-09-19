Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3ISM6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:58:32 -0400
Received: from cobra.newdream.net ([66.33.216.30]:44134 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab3ISM6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:58:31 -0400
Date: Thu, 19 Sep 2013 05:58:30 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 3.12-rc2
Message-ID: <alpine.DEB.2.00.1309190551380.23507@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph fixes for

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

These fix several bugs with RBD from 3.11 that didn't get tested in time 
for the merge window: some error handling, a use-after-free, and a 
sequencing issue when unmapping and image races with a notify operation.

There is also a patch fixing a problem with the new ceph + fscache code 
that just went in.

Thanks!
sage


----------------------------------------------------------------
Josh Durgin (6):
      libceph: add function to ensure notifies are complete
      rbd: complete notifies before cleaning up osd_client and rbd_dev
      rbd: make rbd_obj_notify_ack() synchronous
      rbd: fix use-after free of rbd_dev->disk
      rbd: ignore unmapped snapshots that no longer exist
      rbd: fix error handling from rbd_snap_name()

Milosz Tanski (1):
      fscache: check consistency does not decrement refcount

 drivers/block/rbd.c             | 77 +++++++++++++++++++++++++++++++----------
 fs/fscache/cookie.c             |  3 +-
 include/linux/ceph/osd_client.h |  2 ++
 net/ceph/osd_client.c           | 11 ++++++
 4 files changed, 74 insertions(+), 19 deletions(-)
