Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3AZBbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:31:51 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:44070 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab3AZBb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:31:29 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com
Subject: [PATCH 06/14] dm: don't use idr_remove_all()
Date: Fri, 25 Jan 2013 17:31:04 -0800
Message-Id: <1359163872-1949-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359163872-1949-1-git-send-email-tj@kernel.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
This patch depends on an earlier idr patch and given the trivial
nature of the patch, I think it would be best to route these together
through -mm.  Please holler if there's any objection.

Thanks.

 drivers/md/dm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c72e4d5..ea1a6ca 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -318,7 +318,6 @@ static void __exit dm_exit(void)
 	/*
 	 * Should be empty by this point.
 	 */
-	idr_remove_all(&_minor_idr);
 	idr_destroy(&_minor_idr);
 }
 
-- 
1.8.1

