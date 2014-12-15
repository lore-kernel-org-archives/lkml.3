Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaLOTeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:34:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41049 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbaLOTeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:34:08 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dmitry Torokhov <dtor@chromium.org>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 75/96] sata_fsl: fix error handling of irq_of_parse_and_map
Date: Mon, 15 Dec 2014 11:26:35 -0800
Message-Id: <1418671616-25482-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dtor@chromium.org>

commit aad0b624129709c94c2e19e583b6053520353fa8 upstream.

irq_of_parse_and_map() returns 0 on error (the result is unsigned int),
so testing for negative result never works.

Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/sata_fsl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index fb0b40a..ee2780d 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1503,7 +1503,7 @@ static int sata_fsl_probe(struct platform_device *ofdev)
 	host_priv->csr_base = csr_base;
 
 	irq = irq_of_parse_and_map(ofdev->dev.of_node, 0);
-	if (irq < 0) {
+	if (!irq) {
 		dev_err(&ofdev->dev, "invalid irq from platform\n");
 		goto error_exit_with_cleanup;
 	}
-- 
1.9.1

