Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaLQSdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:33:37 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53040 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaLQSdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:33:35 -0500
From: Tsung-Han Lin <tsunghan.tw@gmail.com>
To: gregkh@linuxfoundation.org
Cc: grant.likely@linaro.org, robh+dt@kernel.org, horms+renesas@verge.net.au,
        damm+renesas@opensource.se, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v2] staging:board: remove unnecessary function
Date: Thu, 18 Dec 2014 02:33:24 +0800
Message-Id: <1418841204-25271-1-git-send-email-tsunghan.tw@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unnecessary 'of_can_translate_address',
which is already removed in commit
d9c6866be8a145e32da616d8dcbae806032d75b5 ("of: kill off
of_can_translate_address").

Signed-off-by: Tsung-Han Lin <tsunghan.tw@gmail.com>
---
 drivers/staging/board/board.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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
-- 
2.1.0

