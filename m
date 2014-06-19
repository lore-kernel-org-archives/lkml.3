Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbaFSPql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:46:41 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:56711 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933101AbaFSPqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:46:30 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linus.walleij@linaro.org, gnurou@gmail.com
Cc: lgirdwood@gmail.com, broonie@kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kernel@codethink.co.uk,
        ian.molton@codethink.co.uk, ben.dooks@codethink.co.uk, heiko@sntech.de,
        rob.jones@codethink.co.uk
Subject: [PATCH 3/4] drivers/base: devres.c: use devm_kmemdup() from with devm_kstrdup()
Date: Thu, 19 Jun 2014 16:46:04 +0100
Message-Id: <1403192765-3258-4-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403192765-3258-1-git-send-email-rob.jones@codethink.co.uk>
References: <1403192765-3258-1-git-send-email-rob.jones@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid code duplication by using devm_kmemdup() to copy data instead
of having a separate loop within devm_kstrdup().

Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
---
 drivers/base/devres.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 9d0f64c..cf19664 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -802,17 +802,10 @@ EXPORT_SYMBOL_GPL(devm_kmalloc);
  */
 char *devm_kstrdup(struct device *dev, const char *s, gfp_t gfp)
 {
-	size_t size;
-	char *buf;
-
 	if (!s)
 		return NULL;
 
-	size = strlen(s) + 1;
-	buf = devm_kmalloc(dev, size, gfp);
-	if (buf)
-		memcpy(buf, s, size);
-	return buf;
+	return devm_kmemdup(dev, s, (strlen(s) + 1), gfp);
 }
 EXPORT_SYMBOL_GPL(devm_kstrdup);
 
-- 
1.7.10.4

