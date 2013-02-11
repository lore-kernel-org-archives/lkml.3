Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab3BKOzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 09:55:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab3BKOzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 09:55:47 -0500
Message-ID: <5119066B.2050103@efe-gmbh.de>
Date: Mon, 11 Feb 2013 15:55:39 +0100
From: "Jens Renner (EFE)" <renner@efe-gmbh.de>
Organization: EFE GmbH
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: spi-devel-general@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] spi: spi-xilinx: Use DT information for bits_per_word value
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:oqV98VrwOO/NwYeLVCTP/fr+QYaKKjofs/KzJbMyx+Z
 qR+esTxZDnVI7z8lwZKsz7viSjVu6gtyNGsCMTQ6q7W24K6oKQ
 d1PVfLHislaXiIGhhNXYHEw+8TjZWJLcFrvJ/IsUUoH1f5j+1Y
 +VxYwgTxpICUz77yMjpIRljoAp/hZN/zq4OU2qEpRejySXOLsm
 hQgGzthMG5QkIX0OBa7GQW9UJNunzwYTCbrwhT+RywqqjfN9L1
 hfcuo42eaJvQK1dNK6Zsp/ARmfxlzERTSnKlKfqF6yulioJzeN
 8nk3dG7wP0OIZxkY2CoJAIbeL+kP7lDXzYrkq0qExsOHnvcXx5
 l7c4UaX8dNtK+IgBxza0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Renner <renner@efe-gmbh.de>

This patch overrides the default value of bits_per_word with the actual value of "xlnx,num-transfer-bits" from the DTS file to allow for 16 and 32 bit word lengths.

Signed-off-by: Jens Renner <renner@efe-gmbh.de>
---
diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index e1d7696..03abdfa 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -487,6 +487,12 @@ static int xilinx_spi_probe(struct platform_device *dev)
				       &len);
		if (prop && len >= sizeof(*prop))
			num_cs = __be32_to_cpup(prop);
+
+		/* override default number of bits per word */
+		prop = of_get_property(dev->dev.of_node,
+				       "xlnx,num-transfer-bits", &len);
+		if (prop && len >= sizeof(*prop))
+			bits_per_word = __be32_to_cpup(prop);
	}
 #endif
