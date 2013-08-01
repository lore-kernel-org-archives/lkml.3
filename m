Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab3HAMK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 08:10:58 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:35715 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab3HAMK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 08:10:56 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: add sanity check to i2c_put_adapter
Date: Thu,  1 Aug 2013 14:10:46 +0200
Message-Id: <1375359046-17472-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_put_adapter dereferences i2c_adapter pointer passed without check
for NULL. This adds a check for non-NULL pointer to allow i2c_put_adapter
called with NULL and behave the same way i2c_release_client does already.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/i2c/i2c-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index f32ca29..d075df6 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1825,7 +1825,8 @@ EXPORT_SYMBOL(i2c_get_adapter);
 
 void i2c_put_adapter(struct i2c_adapter *adap)
 {
-	module_put(adap->owner);
+	if (adap)
+		module_put(adap->owner);
 }
 EXPORT_SYMBOL(i2c_put_adapter);
 
-- 
1.7.10.4

