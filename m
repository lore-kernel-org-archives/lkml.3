Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaKYKlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58505 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaKYKln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Ball <chris@printf.net>, Lee Jones <lee.jones@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 103/254] mfd: rtsx_pcr: Fix MSI enable error handling
Date: Tue, 25 Nov 2014 10:37:33 +0000
Message-Id: <1416912004-5928-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Ball <chris@printf.net>

commit 5152970538a5e16c03bbcb9f1c780489a795ed40 upstream.

pci_enable_msi() can return failure with both positive and negative
integers -- it returns 0 for success -- but is only tested here for
"if (ret < 0)".  This causes us to try to use MSI on the RTS5249 SD
reader in the Dell XPS 11 when enabling MSI failed, causing:

[    1.737110] rtsx_pci: probe of 0000:05:00.0 failed with error -110

Reported-by: D. Jared Dominguez <Jared_Dominguez@Dell.com>
Tested-by: D. Jared Dominguez <Jared_Dominguez@Dell.com>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/rtsx_pcr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 1d15735f9ef9..89b4c4216d0c 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1177,7 +1177,7 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 	pcr->msi_en = msi_en;
 	if (pcr->msi_en) {
 		ret = pci_enable_msi(pcidev);
-		if (ret < 0)
+		if (ret)
 			pcr->msi_en = false;
 	}
 
-- 
2.1.0

