Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbaHOP0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:26:25 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42377 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaHOP0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:26:23 -0400
From: Arjun Sreedharan <arjun024@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: lejun.zhu@linux.intel.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] remove explicit devm_kfree
Date: Fri, 15 Aug 2014 20:56:05 +0530
Message-Id: <1408116365-3013-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory allocated with devm_kzalloc() is freed automatically when device
out of scope.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 drivers/input/misc/soc_button_array.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
index 5a6334b..123e59f 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -131,7 +131,6 @@ soc_button_device_create(struct pnp_dev *pdev,
 err_free_pdev:
 	platform_device_put(pd);
 err_free_mem:
-	devm_kfree(&pdev->dev, gpio_keys_pdata);
 	return ERR_PTR(error);
 }
 
-- 
1.7.11.7

