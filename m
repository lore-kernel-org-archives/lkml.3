Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab3ERCaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:30:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14848 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab3ERCQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:46 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mRShZj8i1CAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=2hk_DU1mHRoA:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=9RRF0ttvEvMA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021643.557231543@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Avinash Patil <patila@marvell.com>, Amitkumar Karwar <akarwar@marvell.com>,
        Yogesh Ashok Powar <yogeshp@marvell.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 011/136 ] mwifiex: Call pci_release_region after calling pci_disable_device
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0011-mwifiex-Call-pci_release_region-after-calling-pci_di.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Yogesh Ashok Powar <yogeshp@marvell.com>

[ Upstream commit 5b0d9b218b74042ff72bf4bfda6eeb2e4bf98397 ]

"drivers should call pci_release_region() AFTER
calling pci_disable_device()"

Please refer section 3.2 Request MMIO/IOP resources
in Documentation/PCI/pci.txt

Cc: <stable@vger.kernel.org> # 3.2+
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/mwifiex/pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 93ee5be..8f352b4 100644
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
1.7.10.4


