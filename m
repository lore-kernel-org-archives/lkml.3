Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab3BFUML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:12:11 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:58637 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098Ab3BFTte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:34 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 08/77] remoteproc: don't use idr_remove_all()
Date: Wed,  6 Feb 2013 11:39:40 -0800
Message-Id: <1360179649-22465-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
---
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

