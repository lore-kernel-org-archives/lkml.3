Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaFDLOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:14:05 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58659 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbaFDLNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:13:38 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 04/21] omap-sham: use devm_irq_of_parse_and_map()
Date: Wed,  4 Jun 2014 15:13:04 +0400
Message-Id: <1401880402-30091-5-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This avoids leak of IRQ mapping on error paths, and makes it possible
to use devm_request_irq() without facing unmap-while-handler-installed
issues.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/crypto/omap-sham.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 710d863..2975f61 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1830,8 +1830,8 @@ static int omap_sham_get_res_of(struct omap_sham_dev *dd,
 		goto err;
 	}
 
-	dd->irq = irq_of_parse_and_map(node, 0);
-	if (!dd->irq) {
+	dd->irq = devm_irq_of_parse_and_map(dev, node, 0);
+	if (dd->irq <= 0) {
 		dev_err(dev, "can't translate OF irq value\n");
 		err = -EINVAL;
 		goto err;
-- 
1.7.10.4

