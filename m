Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbbADRed (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 12:34:33 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:56401 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbbADReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 12:34:31 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Sebastian Reichel <sre@kernel.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH] hsi: nokia-modem: fix uninitialized device pointer
Date: Sun,  4 Jan 2015 19:34:13 +0200
Message-Id: <1420392853-5242-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

modem->device was never initialized. This resulted in logs such as:

[  241.386322] (NULL device *): CMT rst line change detected

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/hsi/clients/nokia-modem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hsi/clients/nokia-modem.c b/drivers/hsi/clients/nokia-modem.c
index f0c2145..eb4dc63 100644
--- a/drivers/hsi/clients/nokia-modem.c
+++ b/drivers/hsi/clients/nokia-modem.c
@@ -162,6 +162,7 @@ static int nokia_modem_probe(struct device *dev)
 		return -ENOMEM;
 	}
 	dev_set_drvdata(dev, modem);
+	modem->device = dev;
 
 	irq = irq_of_parse_and_map(np, 0);
 	if (!irq) {
-- 
2.2.0

