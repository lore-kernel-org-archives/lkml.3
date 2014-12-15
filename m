Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaLOO3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:29:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38921 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbaLOO3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Torokhov <dtor@chromium.org>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 139/168] sata_fsl: fix error handling of irq_of_parse_and_map
Date: Mon, 15 Dec 2014 14:26:33 +0000
Message-Id: <1418653622-21105-140-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dtor@chromium.org>

commit aad0b624129709c94c2e19e583b6053520353fa8 upstream.

irq_of_parse_and_map() returns 0 on error (the result is unsigned int),
so testing for negative result never works.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/sata_fsl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index 616a6d2ac20c..db3c29d6a105 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1489,7 +1489,7 @@ static int sata_fsl_probe(struct platform_device *ofdev)
 	host_priv->csr_base = csr_base;
 
 	irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
-	if (irq < 0) {
+	if (!irq) {
 		dev_err(&ofdev->dev, "invalid irq from platform\n");
 		goto error_exit_with_cleanup;
 	}
-- 
2.1.3

