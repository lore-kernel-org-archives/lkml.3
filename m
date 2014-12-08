Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbaLHRY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 12:24:29 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:65338 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaLHRY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 12:24:27 -0500
From: Tsung-Han Lin <tsunghan.tw@gmail.com>
To: gregkh@linuxfoundation.org
Cc: grant.likely@linaro.org, robh+dt@kernel.org, horms+renesas@verge.net.au,
        damm+renesas@opensource.se, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH] staging:board: fix build errors and warnings
Date: Tue,  9 Dec 2014 01:24:09 +0800
Message-Id: <1418059449-15108-1-git-send-email-tsunghan.tw@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dummy implementation of 'of_find_all_nodes',
and remove the unnecessary 'of_can_translate_address',
which is already removed in commit
d9c6866be8a145e32da616d8dcbae806032d75b5 ("of: kill off
of_can_translate_address"), to fix the build errors and warnings
found by sparse.

Signed-off-by: Tsung-Han Lin <tsunghan.tw@gmail.com>
---
 drivers/staging/board/board.c | 3 +--
 include/linux/of.h            | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/board/board.c b/drivers/staging/board/board.c
index 6050fbdfd31f..d5a6abc84519 100644
--- a/drivers/staging/board/board.c
+++ b/drivers/staging/board/board.c
@@ -11,8 +11,7 @@ static bool find_by_address(u64 base_address)
 	struct resource res;
 
 	while (dn) {
-		if (of_can_translate_address(dn)
-		    && !of_address_to_resource(dn, 0, &res)) {
+		if (!of_address_to_resource(dn, 0, &res)) {
 			if (res.start == base_address) {
 				of_node_put(dn);
 				return true;
diff --git a/include/linux/of.h b/include/linux/of.h
index dfde07e77a63..c2c5021c1ee4 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -616,6 +616,11 @@ static inline const char *of_prop_next_string(struct property *prop,
 	return NULL;
 }
 
+static inline struct device_node *of_find_all_nodes(struct device_node *prev)
+{
+	return NULL;
+}
+
 #define of_match_ptr(_ptr)	NULL
 #define of_match_node(_matches, _node)	NULL
 #endif /* CONFIG_OF */
-- 
2.1.0

