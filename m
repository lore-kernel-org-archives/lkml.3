Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab3FLOd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 10:33:27 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:45260 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3FLOd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 10:33:26 -0400
From: Emil Goode <emilgoode@gmail.com>
To: omar.ramirez@copitl.com, gregkh@linuxfoundation.org,
        justinmattock@gmail.com, andriy.shevchenko@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] staging: tidspbridge: Fix potential NULL pointer dereference
Date: Wed, 12 Jun 2013 16:33:15 +0200
Message-Id: <1371047595-11702-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We free dcd_key on line 897 and then dereference it a few lines below.
This patch adds a NULL check to make sure we can use dcd_key.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/staging/tidspbridge/rmgr/dbdcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/tidspbridge/rmgr/dbdcd.c b/drivers/staging/tidspbridge/rmgr/dbdcd.c
index 3d2a26f..21ce3b7 100644
--- a/drivers/staging/tidspbridge/rmgr/dbdcd.c
+++ b/drivers/staging/tidspbridge/rmgr/dbdcd.c
@@ -899,7 +899,7 @@ int dcd_register_object(struct dsp_uuid *uuid_obj,
 			}
 		}
 		spin_unlock(&dbdcd_lock);
-		if (&dcd_key->link == &reg_key_list)
+		if (dcd_key && (&dcd_key->link == &reg_key_list))
 			status = -EPERM;
 	}
 
-- 
1.7.10.4

