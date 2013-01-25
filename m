Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab3AYWqV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:46:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54445 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3AYWqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:46:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Subject: [PATCH 14/19] spi/atmel: remove incorrect __exit_p()
Date: Fri, 25 Jan 2013 22:44:13 +0000
Message-Id: <1359153858-31992-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:xRzsLCxLc/jnDPphlq+P9w7vDCSO0jgfaCDtHHuOvE8
 eb3nc+W2nJr67jdBt98ZvuhezHmhnq8/7RQZbHuWA7WcFJj2n6
 WfhN88Ty8LdVaTUXdFG6mY8e+WGtNmjkVZ1VgYtHRTLVfP+MeD
 cwEei5W6A+GB6KRCTrVxckOsg57s8TLj7gUwVHHUaIXlktiEGT
 3IHFCFHRlXurd3u+GlQ76MlKp+GXhC1RLrzVwJuE96biwwPyac
 owuf04M32+/RnOMbLZwsprQZrQO3qIMVhnaQszE6dyuZDYGib+
 g1EYHlbdfzNIb+/eLCZc40eAoZYxXSpsWm0dvObmuD7t00wHQ3
 EqRKOOTeTKobIVZdvNP/bL+EJIu4CIEsVydlWAHzP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we no longer allow building without hotplug, the
atmel_spi_remove function is always present and we should
not use __exit_p() to refer to it.

Without this patch, building at91_dt_defconfig results in:

drivers/spi/spi-atmel.c:1006:12: warning: 'atmel_spi_remove' defined but not used [-Wunused-function]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net
---
 drivers/spi/spi-atmel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index ab34497..656d137 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1088,7 +1088,7 @@ static struct platform_driver atmel_spi_driver = {
 	.suspend	= atmel_spi_suspend,
 	.resume		= atmel_spi_resume,
 	.probe		= atmel_spi_probe,
-	.remove		= __exit_p(atmel_spi_remove),
+	.remove		= atmel_spi_remove,
 };
 module_platform_driver(atmel_spi_driver);
 
-- 
1.8.0

