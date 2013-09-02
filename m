Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab3IBBMN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 21:12:13 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:45196 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3IBBML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 21:12:11 -0400
From: Fabio Estevam <festevam@gmail.com>
To: gregkh@linuxfoundation.org
Cc: s.hauer@pengutronix.de, p.zabel@pengutronix.de,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] imx-drm: imx-ldb: Staticize of_get_data_mapping()
Date: Sun,  1 Sep 2013 22:11:55 -0300
Message-Id: <1378084315-18154-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Staticize of_get_data_mapping() in order to fix the following sparse warning:

drivers/staging/imx-drm/imx-ldb.c:424:11: warning: symbol 'of_get_data_mapping' was not declared. Should it be static?

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/staging/imx-drm/imx-ldb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/imx-drm/imx-ldb.c b/drivers/staging/imx-drm/imx-ldb.c
index af733ea..b81ed41 100644
--- a/drivers/staging/imx-drm/imx-ldb.c
+++ b/drivers/staging/imx-drm/imx-ldb.c
@@ -421,7 +421,7 @@ static const char *imx_ldb_bit_mappings[] = {
 	[LVDS_BIT_MAP_JEIDA] = "jeida",
 };
 
-const int of_get_data_mapping(struct device_node *np)
+static const int of_get_data_mapping(struct device_node *np)
 {
 	const char *bm;
 	int ret, i;
-- 
1.8.1.2

