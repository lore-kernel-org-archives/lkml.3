Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3G3LrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:47:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38699 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3G3LrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:47:07 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>, Chris Ball <cjb@laptop.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Date: Tue, 30 Jul 2013 12:46:17 +0100
Message-Id: <1375184777-25404-5-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375184777-25404-1-git-send-email-broonie@kernel.org>
References: <1375184777-25404-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 5/5] mmc: pxamci: Indicate that regulators may be absent
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

Use regulator_get_optional() to tell the core that requests for regulators
can fail in a real system.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/mmc/host/pxamci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index 2c5a91b..1956a3d 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -83,7 +83,7 @@ struct pxamci_host {
 static inline void pxamci_init_ocr(struct pxamci_host *host)
 {
 #ifdef CONFIG_REGULATOR
-	host->vcc = regulator_get(mmc_dev(host->mmc), "vmmc");
+	host->vcc = regulator_get_optional(mmc_dev(host->mmc), "vmmc");
 
 	if (IS_ERR(host->vcc))
 		host->vcc = NULL;
-- 
1.8.3.2

