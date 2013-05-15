Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab3EOPBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 11:01:01 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35847 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3EOPBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 11:01:00 -0400
From: Leon Romanovsky <leon@leon.nu>
To: sbkim73@samsung.com, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Leon Romanovsky <leon@leon.nu>
Subject: [PATCH] drivers: mfd: sec-core: Remove explicit call to mfd_remove_devices
Date: Wed, 15 May 2013 18:00:48 +0300
Message-Id: <1368630048-27007-1-git-send-email-leon@leon.nu>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case mfd_add_devices will fail, it will call to mfd_remove_devices
by itself and return non-zero value.

Signed-off-by: Leon Romanovsky <leon@leon.nu>
---
 drivers/mfd/sec-core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 5b740a3..c93ed3d 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -230,13 +230,12 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 		BUG();
 	}
 
-	if (ret < 0)
+	if (ret)
 		goto err;
 
 	return ret;
 
 err:
-	mfd_remove_devices(sec_pmic->dev);
 	sec_irq_exit(sec_pmic);
 	i2c_unregister_device(sec_pmic->rtc);
 	return ret;
-- 
1.8.1.5

