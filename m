Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbaF3L44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 07:56:56 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52074 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753967AbaF3Lx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 098/181] extcon: max8997: Fix NULL pointer exception on missing pdata
Date: Mon, 30 Jun 2014 13:51:59 +0200
Message-Id: <4e8f12577fa4da651e1d99d3c56dcfd0066ce180.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Kozlowski <k.kozlowski@samsung.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit dfee4111febf3d9ef3a640b2cd6205c75f4e7e3d upstream.

Fix NULL pointer exception when platform data is not supplied. The
driver dereferenced pdata pointer where it could be NULL.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Fixes: 810d601f07c
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/extcon/extcon-max8997.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 67d6738d85a0..09f4a9374cf5 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -712,7 +712,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	if (pdata->muic_pdata) {
+	if (pdata && pdata->muic_pdata) {
 		struct max8997_muic_platform_data *muic_pdata
 			= pdata->muic_pdata;
 
-- 
2.0.0

