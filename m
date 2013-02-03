Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3BCPGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:06:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34497 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754793Ab3BCO5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:41 -0500
Message-Id: <20130203144651.788113149@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Avinash Patil <patila@marvell.com>,
        Bing Zhao <bzhao@marvell.com>, "Sergey V." <sftp.mtuci@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 087/128] mwifiex: fix typo in PCIe adapter NULL check
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avinash Patil <patila@marvell.com>

commit 83f0c6d1f502bd75bb4a9e31e8d64e59c6894ad1 upstream.

Add missing "!" as we are supposed to check "!card->adapter"
in PCIe suspend handler.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Reviewed-by: Sergey V. <sftp.mtuci@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


