Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab3AZBb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:31:56 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39356 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab3AZBbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:31:31 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 07/14] remoteproc: don't use idr_remove_all()
Date: Fri, 25 Jan 2013 17:31:05 -0800
Message-Id: <1359163872-1949-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359163872-1949-1-git-send-email-tj@kernel.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
---
This patch depends on an earlier idr patch and given the trivial
nature of the patch, I think it would be best to route these together
through -mm.  Please holler if there's any objection.

Thanks.

 drivers/remoteproc/remoteproc_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index dd3bfaf..634d367 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1180,7 +1180,6 @@ static void rproc_type_release(struct device *dev)
 
 	rproc_delete_debug_dir(rproc);
 
-	idr_remove_all(&rproc->notifyids);
 	idr_destroy(&rproc->notifyids);
 
 	if (rproc->index >= 0)
-- 
1.8.1

