Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3BANJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:09:48 -0500
Received: from mail.kernel.org ([198.145.19.201]:44627 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123Ab3BANJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:09:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Avinash Patil <patila@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "Sergey V." <sftp.mtuci@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 27/89] mwifiex: fix typo in PCIe adapter NULL check
Date: Fri,  1 Feb 2013 14:07:42 +0100
Message-Id: <20130201130209.457027166@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avinash Patil <patila@marvell.com>

commit 83f0c6d1f502bd75bb4a9e31e8d64e59c6894ad1 upstream.

Add missing "!" as we are supposed to check "!card->adapter"
in PCIe suspend handler.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Reviewed-by: Sergey V. <sftp.mtuci@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -161,7 +161,7 @@ static int mwifiex_pcie_suspend(struct p
 
 	if (pdev) {
 		card = (struct pcie_service_card *) pci_get_drvdata(pdev);
-		if (!card || card->adapter) {
+		if (!card || !card->adapter) {
 			pr_err("Card or adapter structure is not valid\n");
 			return 0;
 		}


