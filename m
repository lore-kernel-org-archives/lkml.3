Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab3ERCbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:31:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14784 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab3ERCQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:45 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=2chDJwu0YOUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=MGXItwFeaMkA:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=9RRF0ttvEvMA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021643.400949493@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Yogesh Ashok Powar <yogeshp@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Avinash Patil <patila@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 010/136 ] mwifiex: Use pci_release_region() instead of a pci_release_regions()
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0010-mwifiex-Use-pci_release_region-instead-of-a-pci_rele.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Yogesh Ashok Powar <yogeshp@marvell.com>

[ Upstream commit c380aafb77b7435d010698fe3ca6d3e1cd745fde ]

PCI regions are associated with the device using
pci_request_region() call. Hence use pci_release_region()
instead of pci_release_regions().

Cc: <stable@vger.kernel.org> # 3.2+
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/mwifiex/pcie.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 13fbc4e..93ee5be 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1831,8 +1831,8 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 	if (pdev) {
 		pci_iounmap(pdev, card->pci_mmap);
 		pci_iounmap(pdev, card->pci_mmap1);
-
-		pci_release_regions(pdev);
+		pci_release_region(pdev, 2);
+		pci_release_region(pdev, 0);
 		pci_disable_device(pdev);
 		pci_set_drvdata(pdev, NULL);
 	}
-- 
1.7.10.4


