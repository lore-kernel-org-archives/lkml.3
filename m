Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab3BSUTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:19:48 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:33313 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab3BSUTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:19:47 -0500
Date: Tue, 19 Feb 2013 12:19:41 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] workqueue: allow more off-queue flag space
Message-ID: <20130219201941.GU17414@htj.dyndns.org>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
 <1361203940-6300-3-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361203940-6300-3-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4acd43237af61d55ac128bbaf46ca092d560809c Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Tue, 19 Feb 2013 12:17:01 -0800

When a work item is off-queue, its work->data contains WORK_STRUCT_*
and WORK_OFFQ_* flags.  As WORK_OFFQ_* flags are used only while a
work item is off-queue, it can occupy bits of work->data which aren't
used while off-queue.  WORK_OFFQ_* currently only use bits used by
on-queue CWQ pointer.  As color bits aren't used while off-queue,
there's no reason to not use them.

Lower WORK_OFFQ_FLAG_BASE from WORK_STRUCT_FLAG_BITS to
WORK_STRUCT_COLOR_SHIFT thus giving 4 more bits to off-queue flag
space which is also used to record worker_pool ID while off-queue.

This doesn't introduce any visible behavior difference.

tj: Rewrote the description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to wq/for-3.10-tmp.  Note that I'm gonna reabse the branch
once 3.9-rc1 is out.

Thanks.

 include/linux/workqueue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 8afab27..5bd030f 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -68,7 +68,7 @@ enum {
 				  WORK_STRUCT_COLOR_BITS,
 
 	/* data contains off-queue information when !WORK_STRUCT_PWQ */
-	WORK_OFFQ_FLAG_BASE	= WORK_STRUCT_FLAG_BITS,
+	WORK_OFFQ_FLAG_BASE	= WORK_STRUCT_COLOR_SHIFT,
 
 	WORK_OFFQ_CANCELING	= (1 << WORK_OFFQ_FLAG_BASE),
 
-- 
1.8.1

