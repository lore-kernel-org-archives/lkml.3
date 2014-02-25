Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaBYO71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:59:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59897 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbaBYO7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:59:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: <chris@printf.net>
CC: <jh80.chung@samsung.com>, <tgih.jun@samsung.com>,
        <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH] mmc: host: dw: fix possible build error
Date: Tue, 25 Feb 2014 08:57:44 -0600
Message-ID: <1393340264-22687-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build errors:

drivers/mmc/host/dw_mmc-k3.c: In function ‘dw_mci_k3_suspend’:
drivers/mmc/host/dw_mmc-k3.c:58:2: error: implicit declaration of
	function ‘dw_mci_suspend’ [-Werror=implicit-function-declaration]
  ret = dw_mci_suspend(host);
  ^
drivers/mmc/host/dw_mmc-k3.c: In function ‘dw_mci_k3_resume’:
drivers/mmc/host/dw_mmc-k3.c:76:2: error: implicit declaration of
	function ‘dw_mci_resume’ [-Werror=implicit-function-declaration]
  return dw_mci_resume(host);
  ^
drivers/mmc/host/dw_mmc-k3.c: At top level:
drivers/mmc/host/dw_mmc-k3.c:53:12: warning: ‘dw_mci_k3_suspend’ defined
	but not used [-Wunused-function]
 static int dw_mci_k3_suspend(struct device *dev)
            ^
drivers/mmc/host/dw_mmc-k3.c:65:12: warning: ‘dw_mci_k3_resume’ defined
	but not used [-Wunused-function]
 static int dw_mci_k3_resume(struct device *dev)
            ^

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/mmc/host/dw_mmc-k3.c | 2 ++
 drivers/mmc/host/dw_mmc.h    | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc-k3.c b/drivers/mmc/host/dw_mmc-k3.c
index f567c21..650f9cc 100644
--- a/drivers/mmc/host/dw_mmc-k3.c
+++ b/drivers/mmc/host/dw_mmc-k3.c
@@ -50,6 +50,7 @@ static int dw_mci_k3_probe(struct platform_device *pdev)
 	return dw_mci_pltfm_register(pdev, drv_data);
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int dw_mci_k3_suspend(struct device *dev)
 {
 	struct dw_mci *host = dev_get_drvdata(dev);
@@ -75,6 +76,7 @@ static int dw_mci_k3_resume(struct device *dev)
 
 	return dw_mci_resume(host);
 }
+#endif /* CONFIG_PM_SLEEP */
 
 static SIMPLE_DEV_PM_OPS(dw_mci_k3_pmops, dw_mci_k3_suspend, dw_mci_k3_resume);
 
diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
index 6bf24ab..1f7a745 100644
--- a/drivers/mmc/host/dw_mmc.h
+++ b/drivers/mmc/host/dw_mmc.h
@@ -185,7 +185,7 @@
 
 extern int dw_mci_probe(struct dw_mci *host);
 extern void dw_mci_remove(struct dw_mci *host);
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 extern int dw_mci_suspend(struct dw_mci *host);
 extern int dw_mci_resume(struct dw_mci *host);
 #endif
-- 
1.9.0

