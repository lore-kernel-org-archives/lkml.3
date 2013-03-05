Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab3CEUDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:03:03 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:44356 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3CEUDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:03:01 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, bfields@fieldses.org,
        jackm@dev.mellanox.co.il, ogerlitz@mellanox.com,
        roland@purestorage.com, dan.magenheimer@oracle.com,
        gregkh@linuxfoundation.org, vjaquez@igalia.com, rene.sapiens@ti.com,
        x0095078@ti.com, omar.ramirez@ti.com
Subject: [PATCHSET 3.9-rc1] idr: final idr_alloc() conversions and deprecation of old interface
Date: Tue,  5 Mar 2013 12:02:45 -0800
Message-Id: <1362513772-15174-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

These are the final pieces of idr_alloc() conversion and deprecation
of idr_pre_get() and idr_get_new*().

This patchset contains the following seven patches.

 0001-nfsd-remove-unused-get_new_stid.patch
 0002-nfsd-convert-to-idr_alloc.patch
 0003-workqueue-convert-to-idr_alloc.patch
 0004-mlx4-remove-leftover-idr_pre_get-call.patch
 0005-zcache-convert-to-idr_alloc.patch
 0006-tidspbridge-convert-to-idr_alloc.patch
 0007-idr-deprecate-idr_pre_get-and-idr_get_new-_above.patch

The patches based on top of v3.9-rc1 and are also available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git idr_alloc-final

Andrew, can you please route these through -mm?

diffstat follows, thanks.

 drivers/infiniband/hw/mlx4/cm.c        |    1 
 drivers/staging/tidspbridge/rmgr/drv.c |   70 ++++++++++++---------------------
 drivers/staging/zcache/ramster/tcp.c   |   25 ++++-------
 fs/nfsd/nfs4state.c                    |   36 ----------------
 include/linux/idr.h                    |   66 +++++++++++++++++++++++--------
 kernel/workqueue.c                     |    7 +--
 lib/idr.c                              |   41 ++-----------------
 7 files changed, 97 insertions(+), 149 deletions(-)

--
tejun
