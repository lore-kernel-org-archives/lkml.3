Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107Ab3FSCmi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 22:42:38 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:47978 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933861Ab3FSCmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 22:42:37 -0400
MIME-Version: 1.0
Date: Wed, 19 Jun 2013 10:42:35 +0800
Message-ID: <CAPgLHd_sYVPQQkx7y4L=i_-GMjSmFGAbgY0bP7M1sr_02WtPvA@mail.gmail.com>
Subject: [PATCH] vme: vme_tsi148.c: fix error return code in tsi148_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: martyn.welch@ge.com, manohar.vanga@gmail.com, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code in the tsi148_crcsr_init() error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/vme/bridges/vme_tsi148.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vme/bridges/vme_tsi148.c b/drivers/vme/bridges/vme_tsi148.c
index 9c1aa4d..95c9b54 100644
--- a/drivers/vme/bridges/vme_tsi148.c
+++ b/drivers/vme/bridges/vme_tsi148.c
@@ -2582,7 +2582,8 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev_info(&pdev->dev, "VME Write and flush and error check is %s\n",
 		err_chk ? "enabled" : "disabled");
 
-	if (tsi148_crcsr_init(tsi148_bridge, pdev)) {
+	retval = tsi148_crcsr_init(tsi148_bridge, pdev);
+	if (retval) {
 		dev_err(&pdev->dev, "CR/CSR configuration failed.\n");
 		goto err_crcsr;
 	}

