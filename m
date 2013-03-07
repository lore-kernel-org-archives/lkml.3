Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab3CGVoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:44:25 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:43323 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543Ab3CGVoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:44:22 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, laijs@cn.fujitsu.com, fengguang.wu@intel.com
Cc: linux-kernel@vger.kernel.org, jmoyer@redhat.com, Tejun Heo <tj@kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4/4] writeback: expose the bdi_wq workqueue
Date: Thu,  7 Mar 2013 13:44:09 -0800
Message-Id: <1362692649-25570-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362692649-25570-1-git-send-email-tj@kernel.org>
References: <1362692649-25570-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases where userland wants to tweak the priority and
affinity of writeback flushers.  Expose bdi_wq to userland by setting
WQ_SYSFS.  It appears under /sys/bus/workqueue/devices/writeback/ and
allows adjusting maximum concurrency level, cpumask and nice level.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/backing-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 2857d4f..5025174 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -259,7 +259,7 @@ static int __init default_bdi_init(void)
 	int err;
 
 	bdi_wq = alloc_workqueue("writeback", WQ_MEM_RECLAIM | WQ_FREEZABLE |
-					      WQ_UNBOUND, 0);
+					      WQ_UNBOUND | WQ_SYSFS, 0);
 	if (!bdi_wq)
 		return -ENOMEM;
 
-- 
1.8.1.4

