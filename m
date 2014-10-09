Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757794AbaJIVlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:41:14 -0400
Received: from hauke-m.de ([5.39.93.123]:59715 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbaJIVkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:40:00 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: zajec5@gmail.com, arend@broadcom.com, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux@roeck-us.net,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] bcma: fix build when CONFIG_OF_ADDRESS is not set
Date: Thu,  9 Oct 2014 23:39:41 +0200
Message-Id: <1412890781-24160-1-git-send-email-hauke@hauke-m.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <5436D3CF.2030506@hauke-m.de>
References: <5436D3CF.2030506@hauke-m.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2101e533f41a ("bcma: register bcma as device tree driver")
introduces a hard dependency on OF_ADDRESS into the bcma driver.
OF_ADDRESS is specifically disabled for the sparc architecture.
This results in the following error when building sparc64:allmodconfig.

drivers/bcma/main.c: In function 'bcma_of_find_child_device':
drivers/bcma/main.c:150:3: error: implicit declaration of function 'of_translate_address'

Fixes: 2101e533f41a ("bcma: register bcma as device tree driver")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index d1656c2..1000955 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -132,7 +132,7 @@ static bool bcma_is_core_needed_early(u16 core_id)
 	return false;
 }
 
-#ifdef CONFIG_OF
+#if defined(CONFIG_OF) && defined(CONFIG_OF_ADDRESS)
 static struct device_node *bcma_of_find_child_device(struct platform_device *parent,
 						     struct bcma_device *core)
 {
-- 
1.9.1

