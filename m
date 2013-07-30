Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3G3Mkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:40:36 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:45035 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab3G3Mke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:40:34 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: shli@kernel.org
Subject: [PATCHSET wq/for-3.12] workqueue: WQ_NON_REENTRANT is meaningless and going away
Date: Tue, 30 Jul 2013 08:40:19 -0400
Message-Id: <1375188028-11910-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

dbf2576e37 ("workqueue: make all workqueues non-reentrant") made
WQ_NON_REENTRANT no-op but the following patches didn't remove the
flag or update the documentation.  Let's mark the flag deprecated and
update the documentation accordingly and remove the existing usages.
We can remove the flag after the next merge window.

This patchset contains the following nine patches.

 0001-workqueue-mark-WQ_NON_REENTRANT-deprecated.patch
 0002-dm-WQ_NON_REENTRANT-is-meaningless-and-going-away.patch
 0003-mmc-WQ_NON_REENTRANT-is-meaningless-and-going-away.patch
 0004-firewire-WQ_NON_REENTRANT-is-meaningless-and-going-a.patch
 0005-dlm-WQ_NON_REENTRANT-is-meaningless-and-going-away.patch
 0006-gfs2-WQ_NON_REENTRANT-is-meaningless-and-going-away.patch
 0007-xfs-WQ_NON_REENTRANT-is-meaningless-and-going-away.patch
 0008-ceph-WQ_NON_REENTRANT-is-meaningless-and-going-away.patch
 0009-l2tp-WQ_NON_REENTRANT-is-meaningless-and-going-away.patch

0001 marks the flag deprecated.  The rest remove the exising usages.
This patchset as a whole doesn't introduce any behavior changes.

0001 is already applied to wq/for-3.12.  The rest will be routed
through the respective trees.  The patches are also available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-WQ_NON_REENTRANT-removal

 Documentation/workqueue.txt         |   18 ++++++------------
 drivers/firewire/core-transaction.c |    3 +--
 drivers/md/dm-crypt.c               |   10 ++--------
 drivers/md/dm-kcopyd.c              |    3 +--
 drivers/md/dm-raid1.c               |    3 +--
 drivers/md/dm.c                     |    3 +--
 drivers/mmc/host/dw_mmc.c           |    2 +-
 fs/dlm/ast.c                        |    5 +----
 fs/gfs2/main.c                      |    2 +-
 fs/xfs/xfs_super.c                  |    6 +++---
 include/linux/workqueue.h           |    7 ++++++-
 net/ceph/messenger.c                |    2 +-
 net/l2tp/l2tp_core.c                |    2 +-
 13 files changed, 26 insertions(+), 40 deletions(-)

Thanks.

--
tejun
