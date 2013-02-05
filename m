Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab3BEWKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:10:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48054 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab3BEWKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:35 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Avinash Patil <patila@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 47/93] mwifiex: fix typo in PCIe adapter NULL check
Date: Tue,  5 Feb 2013 20:06:36 -0200
Message-Id: <1360102042-10732-48-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avinash Patil <patila@marvell.com>

commit 83f0c6d1f502bd75bb4a9e31e8d64e59c6894ad1 upstream.

Add missing "!" as we are supposed to check "!card->adapter"
in PCIe suspend handler.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Reviewed-by: Sergey V. <sftp.mtuci@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/mwifiex/pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 13fbc4e..b879e13 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -161,7 +161,7 @@ static int mwifiex_pcie_suspend(struct pci_dev *pdev, pm_message_t state)
 
 	if (pdev) {
 		card = (struct pcie_service_card *) pci_get_drvdata(pdev);
-		if (!card || card->adapter) {
+		if (!card || !card->adapter) {
 			pr_err("Card or adapter structure is not valid\n");
 			return 0;
 		}
-- 
1.7.9.5

