Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab3BFTtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:49:35 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:51940 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757777Ab3BFTtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:32 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: [PATCH 07/77] dm: don't use idr_remove_all()
Date: Wed,  6 Feb 2013 11:39:39 -0800
Message-Id: <1360179649-22465-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 808f712..c644eb6 100644
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

