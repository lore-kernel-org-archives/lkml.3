Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175Ab3L2GxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 01:53:01 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:56779 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3L2GxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 01:53:00 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Dec 2013 01:53:00 EST
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>, Marcin Jurkowski <marcin1j@gmail.com>,
        Josh Boyer <jwboyer@gmail.com>,
        Sven Geggus <lists@fuchsschwanzdomain.de>
Subject: [PATCH 03/14] w1: Only wake up the search process if it is going to be searching
Date: Sun, 29 Dec 2013 00:45:45 -0600
Message-Id: <1388299556-12669-4-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1388299556-12669-1-git-send-email-David@Fries.net>
References: <1388299556-12669-1-git-send-email-David@Fries.net>
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sun, 29 Dec 2013 00:46:36 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's valid to set the search count to 0 to stop searching, so don't
wake up the search thread to not search.

Signed-off-by: David Fries <David@Fries.net>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
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

