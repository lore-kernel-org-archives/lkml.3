Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406Ab3CISPM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:15:12 -0500
Received: from smtp-out-195.synserver.de ([212.40.185.195]:1118 "EHLO
	smtp-out-193.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750881Ab3CISPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:15:08 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31737
From: Lars-Peter Clausen <lars@metafoo.de>
To: Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/6] i2c: i2c_del_adapter: Don't treat removing a non-registered adapter as error
Date: Sat,  9 Mar 2013 19:16:45 +0100
Message-Id: <1362853009-20789-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1362853009-20789-1-git-send-email-lars@metafoo.de>
References: <1362853009-20789-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently i2c_del_adapter() returns -EINVAL when it gets an adapter which is not
registered. But none of the users of i2c_del_adapter() depend on this behavior,
so for the sake of being able to sanitize the return type of i2c_del_adapter
argue, that the purpose of i2c_del_adapter() is to remove an I2C adapter from
the system. If the adapter is not registered in the first place this becomes a
no-op. So we can return success without having to do anything.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/i2c/i2c-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index a853cb3..7727d33 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -1072,7 +1072,7 @@ int i2c_del_adapter(struct i2c_adapter *adap)
 	if (found != adap) {
 		pr_debug("i2c-core: attempting to delete unregistered "
 			 "adapter [%s]\n", adap->name);
-		return -EINVAL;
+		return 0;
 	}
 
 	/* Tell drivers about this removal */
-- 
1.8.0

