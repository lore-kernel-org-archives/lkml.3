Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3DYHSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 03:18:06 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:43987 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab3DYHSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 03:18:04 -0400
MIME-Version: 1.0
Date: Thu, 25 Apr 2013 15:18:02 +0800
Message-ID: <CAPgLHd-QZXdb39icvhUKWm+hCT4O2dnF5kPAmPeaxXPsU8MMNA@mail.gmail.com>
Subject: [PATCH] spi-topcliff-pch: missing platform_driver_unregister() on
 error in pch_spi_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: broonie@kernel.org, grant.likely@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing platform_driver_unregister() before return
from pch_spi_init() in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/spi/spi-topcliff-pch.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index f756481..c8b672e 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -1789,8 +1789,10 @@ static int __init pch_spi_init(void)
 		return ret;
 
 	ret = pci_register_driver(&pch_spi_pcidev_driver);
-	if (ret)
+	if (ret) {
+		platform_driver_unregister(&pch_spi_pd_driver);
 		return ret;
+	}
 
 	return 0;
 }

