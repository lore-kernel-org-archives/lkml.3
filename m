Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019Ab3ETT4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:56:30 -0400
Received: from mout.gmx.net ([212.227.17.20]:49647 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757943Ab3ETT43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:56:29 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19tGaJku+ltRfSZ90dtsne49YYqqbjyXO8KQcUE7e
	xCiw6hyPmUlrG/
From: Peter Huewe <peterhuewe@gmx.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Jean Delvare <khali@linux-fr.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Huewe <peterhuewe@gmx.de>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] video/matrox/matroxfb_maven: Use module_i2c_driver to register driver
Date: Mon, 20 May 2013 22:01:37 +0200
Message-Id: <1369080097-6856-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130520214206.078bc580@endymion.delvare>
References: <20130520214206.078bc580@endymion.delvare>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing some boilerplate by using module_i2c_driver instead of calling
register and unregister in the otherwise empty init/exit functions.
Also removed a useless comment as suggested by Jean Delvare

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Reviewed-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/video/matrox/matroxfb_maven.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/video/matrox/matroxfb_maven.c b/drivers/video/matrox/matroxfb_maven.c
index 217678e..6360796 100644
--- a/drivers/video/matrox/matroxfb_maven.c
+++ b/drivers/video/matrox/matroxfb_maven.c
@@ -1283,19 +1283,7 @@ static struct i2c_driver maven_driver={
 	.id_table	= maven_id,
 };
 
-static int __init matroxfb_maven_init(void)
-{
-	return i2c_add_driver(&maven_driver);
-}
-
-static void __exit matroxfb_maven_exit(void)
-{
-	i2c_del_driver(&maven_driver);
-}
-
+module_i2c_driver(maven_driver);
 MODULE_AUTHOR("(c) 1999-2002 Petr Vandrovec <vandrove@vc.cvut.cz>");
 MODULE_DESCRIPTION("Matrox G200/G400 Matrox MGA-TVO driver");
 MODULE_LICENSE("GPL");
-module_init(matroxfb_maven_init);
-module_exit(matroxfb_maven_exit);
-/* we do not have __setup() yet */
-- 
1.8.1.5

