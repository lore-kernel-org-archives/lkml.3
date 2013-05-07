Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab3EGNvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:51:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42584 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933040Ab3EGNmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:23 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Avinash Patil <patila@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
        Yogesh Ashok Powar <yogeshp@marvell.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 105/118] mwifiex: Call pci_release_region after calling pci_disable_device
Date: Tue,  7 May 2013 14:39:11 +0100
Message-Id: <1367933964-1564-106-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yogesh Ashok Powar <yogeshp@marvell.com>

commit 5b0d9b218b74042ff72bf4bfda6eeb2e4bf98397 upstream.

"drivers should call pci_release_region() AFTER
calling pci_disable_device()"

Please refer section 3.2 Request MMIO/IOP resources
in Documentation/PCI/pci.txt

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index ce2c101..b7a5387 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1831,9 +1831,9 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 	if (pdev) {
 		pci_iounmap(pdev, card->pci_mmap);
 		pci_iounmap(pdev, card->pci_mmap1);
+		pci_disable_device(pdev);
 		pci_release_region(pdev, 2);
 		pci_release_region(pdev, 0);
-		pci_disable_device(pdev);
 		pci_set_drvdata(pdev, NULL);
 	}
 }
-- 
1.8.1.2

