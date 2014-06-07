Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaFGDTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 23:19:00 -0400
Received: from mail.ispras.ru ([83.149.199.45]:48456 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbaFGDS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 23:18:56 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "John W. Linville" <linville@tuxdriver.com>,
        Fariya Fatima <fariyaf@gmail.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 2/2] rsi_91x_sdio: add error handling into rsi_module_init()
Date: Sat,  7 Jun 2014 07:18:31 +0400
Message-Id: <1402111111-8676-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402111111-8676-1-git-send-email-khoroshilov@ispras.ru>
References: <1402111111-8676-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix rsi_module_init() to propagate sdio_register_driver() errors.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 2e39d38d6a9e..f2991682a66a 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -822,9 +822,11 @@ static struct sdio_driver rsi_driver = {
  */
 static int rsi_module_init(void)
 {
-	sdio_register_driver(&rsi_driver);
+	int ret;
+
+	ret = sdio_register_driver(&rsi_driver);
 	rsi_dbg(INIT_ZONE, "%s: Registering driver\n", __func__);
-	return 0;
+	return ret;
 }
 
 /**
-- 
1.8.3.2

