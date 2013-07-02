Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3GBO4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 10:56:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42672 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753227Ab3GBO4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:56:44 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <coelho@ti.com>
Subject: [PATCH v2 5/9] wlcore: always use one-shot IRQ
Date: Tue, 2 Jul 2013 17:55:44 +0300
Message-ID: <1372776948-24840-6-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372776948-24840-1-git-send-email-coelho@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are now using threaded IRQs without the primary handler, we
need to set IRQF_ONESHOT, otherwise our request will fail.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d306cd5..bc1cff3 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5927,7 +5927,8 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 
 	wl->irq = platform_get_irq(pdev, 0);
 	wl->if_ops = pdev_data->if_ops;
-	wl->irq_flags = pdata->irq_flags;
+	/* Since we don't use the primary handler, we must set ONESHOT */
+	wl->irq_flags = pdata->irq_flags | IRQF_ONESHOT;
 
 	ret = request_threaded_irq(wl->irq, NULL, wlcore_irq,
 				   wl->irq_flags, pdev->name, wl);
-- 
1.7.10.4

