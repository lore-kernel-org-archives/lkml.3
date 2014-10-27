Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaJ0S7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:59:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52464 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaJ0S70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:59:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, Mark Brown <broonie@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 053/105] regmap: fix NULL pointer dereference in _regmap_write/read
Date: Mon, 27 Oct 2014 11:56:28 -0700
Message-Id: <1414436240-13879-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pankaj Dubey <pankaj.dubey@samsung.com>

commit 5336be8416a71b5568d2cf54a2f2066abe9f2a53 upstream.

If LOG_DEVICE is defined and map->dev is NULL it will lead to NULL
pointer dereference. This patch fixes this issue by adding check for
dev->NULL in all such places in regmap.c

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/regmap/regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index f8214ec..1ac3c9a 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1308,7 +1308,7 @@ int _regmap_write(struct regmap *map, unsigned int reg,
 	}
 
 #ifdef LOG_DEVICE
-	if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
+	if (map->dev && strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
 		dev_info(map->dev, "%x <= %x\n", reg, val);
 #endif
 
@@ -1727,7 +1727,7 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 	ret = map->reg_read(context, reg, val);
 	if (ret == 0) {
 #ifdef LOG_DEVICE
-		if (strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
+		if (map->dev && strcmp(dev_name(map->dev), LOG_DEVICE) == 0)
 			dev_info(map->dev, "%x => %x\n", reg, *val);
 #endif
 
-- 
1.9.1

