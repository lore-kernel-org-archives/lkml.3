Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaAPEbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:31:20 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:45758 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890AbaAPEbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:31:16 -0500
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, GregKH <greg@kroah.com>
Subject: [PATCH 03/15] w1: Only wake up the search process if it is going to be searching
Date: Wed, 15 Jan 2014 22:29:14 -0600
Message-Id: <1389846566-28862-4-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389846566-28862-1-git-send-email-David@Fries.net>
References: <1389846566-28862-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Wed, 15 Jan 2014 22:31:10 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's valid to set the search count to 0 to stop searching, so don't
wake up the search thread to not search.

Signed-off-by: David Fries <David@Fries.net>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/w1.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index 67b6d5f..92766a9 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -243,7 +243,9 @@ static ssize_t w1_master_attribute_store_search(struct device * dev,
 	mutex_lock(&md->mutex);
 	md->search_count = tmp;
 	mutex_unlock(&md->mutex);
-	wake_up_process(md->thread);
+	/* Only wake if it is going to be searching. */
+	if (tmp)
+		wake_up_process(md->thread);
 
 	return count;
 }
-- 
1.7.10.4

