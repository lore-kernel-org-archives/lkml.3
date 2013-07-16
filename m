Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab3GPFKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 01:10:31 -0400
Received: from mail-gh0-f178.google.com ([209.85.160.178]:62885 "EHLO
	mail-gh0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3GPFKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 01:10:25 -0400
From: Fabio Estevam <festevam@gmail.com>
To: broonie@kernel.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] regmap: Provide __acquires/__releases annotations
Date: Tue, 16 Jul 2013 02:10:11 -0300
Message-Id: <1373951411-8932-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the following sparse warnings:

drivers/base/regmap/regmap.c:305:13: warning: context imbalance in 'regmap_lock_spinlock' - wrong count at exit
drivers/base/regmap/regmap.c:314:13: warning: context imbalance in 'regmap_unlock_spinlock' - unexpected unlock

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/base/regmap/regmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e0d0c7d..d7144cf 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -303,6 +303,7 @@ static void regmap_unlock_mutex(void *__map)
 }
 
 static void regmap_lock_spinlock(void *__map)
+__acquires(&map->spinlock)
 {
 	struct regmap *map = __map;
 	unsigned long flags;
@@ -312,6 +313,7 @@ static void regmap_lock_spinlock(void *__map)
 }
 
 static void regmap_unlock_spinlock(void *__map)
+__releases(&map->spinlock)
 {
 	struct regmap *map = __map;
 	spin_unlock_irqrestore(&map->spinlock, map->spinlock_flags);
-- 
1.8.1.2

