Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab3HARkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 13:40:31 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:8004 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab3HARk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 13:40:27 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 3/6] staging: ozwpan: Use kernel strncmp function.
Date: Thu, 1 Aug 2013 18:40:02 +0100
Message-ID: <1375378806-17948-4-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375378806-17948-1-git-send-email-rupesh.gujare@atmel.com>
References: <1375378806-17948-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kernel's strncmp() function instead of defining same within driver.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozproto.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 2dbaba6..ec60286 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -669,21 +669,6 @@ void oz_binding_add(const char *net_dev)
 /*------------------------------------------------------------------------------
  * Context: process
  */
-static int compare_binding_name(const char *s1, const char *s2)
-{
-	int i;
-	for (i = 0; i < OZ_MAX_BINDING_LEN; i++) {
-		if (*s1 != *s2)
-			return 0;
-		if (!*s1++)
-			return 1;
-		s2++;
-	}
-	return 1;
-}
-/*------------------------------------------------------------------------------
- * Context: process
- */
 static void pd_stop_all_for_device(struct net_device *net_dev)
 {
 	struct list_head h;
@@ -715,7 +700,7 @@ void oz_binding_remove(const char *net_dev)
 	oz_dbg(ON, "Removing binding: %s\n", net_dev);
 	spin_lock_bh(&g_binding_lock);
 	list_for_each_entry(binding, &g_binding, link) {
-		if (compare_binding_name(binding->name, net_dev)) {
+		if (strncmp(binding->name, net_dev, OZ_MAX_BINDING_LEN) == 0) {
 			oz_dbg(ON, "Binding '%s' found\n", net_dev);
 			found = 1;
 			break;
-- 
1.7.9.5

