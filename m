Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab3CGVoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:44:17 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:59823 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3CGVoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:44:16 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, laijs@cn.fujitsu.com, fengguang.wu@intel.com
Cc: linux-kernel@vger.kernel.org, jmoyer@redhat.com
Subject: [PATCHSET] writeback: convert writeback to unbound workqueue
Date: Thu,  7 Mar 2013 13:44:05 -0800
Message-Id: <1362692649-25570-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

There's no reason for writeback to implement its own worker pool when
using workqueue is much simpler and more efficient.  This patchset
replaces writeback's custom worker pool with unbound workqueue and
also exports it to userland using WQ_SYSFS so that it can be tuned
from userland as requested a couple releases ago.

This patchset contains the following four patches.

 0001-implement-current_is_workqueue_rescuer.patch
 0002-writeback-remove-unused-bdi_pending_list.patch
 0003-writeback-replace-custom-worker-pool-implementation-.patch
 0004-writeback-expose-the-bdi_wq-workqueue.patch

0001-0002 are prep patches.  0003 does the conversion.  0004 makes
bdi_wq visible to userland.

This patchset is on top of v3.9-rc1 + "workqueue: implement workqueue
with custom worker attributes" patchset[1] and available in the
following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-writeback-conversion

diffstat follows.  Thanks.

 fs/fs-writeback.c                |  102 ++++-----------
 include/linux/backing-dev.h      |   16 --
 include/linux/workqueue.h        |    1
 include/trace/events/writeback.h |    5
 kernel/workqueue.c               |   13 +
 mm/backing-dev.c                 |  259 ++++-----------------------------------
 6 files changed, 80 insertions(+), 316 deletions(-)

--
tejun

[1] http://thread.gmane.org/gmane.linux.kernel/1449826

