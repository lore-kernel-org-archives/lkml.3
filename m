Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab3AYOPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:15:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49352 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509Ab3AYOPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:15:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Subject: [PATCH 14/19] spi/atmel: remove incorrect __exit_p()
Date: Fri, 25 Jan 2013 14:14:31 +0000
Message-Id: <1359123276-15833-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:+fhEfaipIjDYlCDXM0tVJm8Y8eMPXeQBW/S9EIupRD7
 WHUW+t2viLr/CLtkMEzHSHnyb+oj3lSklJDhod2LLjjHD9vrNZ
 nDVDnTzNUAMwlWg422UQJSZy03k/nuG9SQQucc0hoXf/tpIcY+
 1EhQ2Oft8DGacdwaG813R1sQRsDQpAKR09ap753NEODR4NL898
 sSPlW37BeKaG289uHIar3L6Xdhu0QnTmqylRdLhDcc3QEZex06
 m4L1y1/LXzZTFgssPs7je130J8wEuJ+4hans/yxrDdl+1l/NcL
 DjUAwMvTYzWa/17BA2mlgevxDlg+mudSKuv9nS+9oX8O2oLRAH
 nPXATeTTd1lQLC1jGva3otU+bRv2DjCGm0m87I28b
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

