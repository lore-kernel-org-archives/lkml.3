Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab3APQCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:02:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36002 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757774Ab3APQCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:02:09 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Diego Calleja <diegocg@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 074/222] Input: wacom - fix touch support for Bamboo Fun CTH-461
Date: Wed, 16 Jan 2013 13:54:34 -0200
Message-Id: <1358351822-7675-75-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diego Calleja <diegocg@gmail.com>

commit e12b3cecf221644ccab64d7c30a6df58b7630cb0 upstream.

Commit f393ee2b814e3291c12565000210b3cf10aa5c1d forgot to add the
touch_max property for Wacom Bamboo Fun CTH-461/S, ID 056a:00d2.

This broke the touch functionality for that device. This patch,
(done with help of Ping Cheng), adds the correct value and makes
touch work again.

Signed-off-by: Diego Calleja <diegocg@gmail.com>
Reviewed-by: Ping Cheng <pinglinux@gmail.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/input/tablet/wacom_wac.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index 05e8cb3..0aba107 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -1918,7 +1918,8 @@ static const struct wacom_features wacom_features_0xD1 =
 	  .touch_max = 2 };
 static const struct wacom_features wacom_features_0xD2 =
 	{ "Wacom Bamboo Craft",   WACOM_PKGLEN_BBFUN,     14720,  9200, 1023,
-	  31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
+	  31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES,
+	  .touch_max = 2 };
 static const struct wacom_features wacom_features_0xD3 =
 	{ "Wacom Bamboo 2FG 6x8", WACOM_PKGLEN_BBFUN,     21648, 13700, 1023,
 	  31, BAMBOO_PT, WACOM_INTUOS_RES, WACOM_INTUOS_RES,
-- 
1.7.9.5

