Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3FGCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 22:16:57 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:64127 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab3FGCQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 22:16:56 -0400
MIME-Version: 1.0
Date: Fri, 7 Jun 2013 10:16:54 +0800
Message-ID: <CAPgLHd-1y9xLM_0roXvO0ASOWSOWZHWB+MUTfHL2s3m-RO9T1g@mail.gmail.com>
Subject: [PATCH] pcmcia: pd6729: fix error return code in pd6729_pci_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: wfp5p@virginia.edu, gregkh@linuxfoundation.org, eric.y.miao@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-pcmcia@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pcmcia/pd6729.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index b29d97e..a4c16ee 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -644,6 +644,7 @@ static int pd6729_pci_probe(struct pci_dev *dev,
 	if (!pci_resource_start(dev, 0)) {
 		dev_warn(&dev->dev, "refusing to load the driver as the "
 			"io_base is NULL.\n");
+		ret = -ENOMEM;
 		goto err_out_disable;
 	}
 
@@ -673,6 +674,7 @@ static int pd6729_pci_probe(struct pci_dev *dev,
 	mask = pd6729_isa_scan();
 	if (irq_mode == 0 && mask == 0) {
 		dev_warn(&dev->dev, "no ISA interrupt is available.\n");
+		ret = -ENODEV;
 		goto err_out_free_res;
 	}
 

