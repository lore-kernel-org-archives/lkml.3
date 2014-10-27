Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaJ0TAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:00:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52514 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaJ0TAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:00:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Ball <chris@printf.net>, Lee Jones <lee.jones@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 050/105] mfd: rtsx_pcr: Fix MSI enable error handling
Date: Mon, 27 Oct 2014 11:56:25 -0700
Message-Id: <1414436240-13879-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/rtsx_pcr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 705698f..eb45a42 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1172,7 +1172,7 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 	pcr->msi_en = msi_en;
 	if (pcr->msi_en) {
 		ret = pci_enable_msi(pcidev);
-		if (ret < 0)
+		if (ret)
 			pcr->msi_en = false;
 	}
 
-- 
1.9.1

