Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3KGJHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:07:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59154 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816Ab3KGJHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:07:39 -0500
From: Jisheng Zhang <jszhang@marvell.com>
To: <bhelgaas@google.com>, <thomas.petazzoni@free-electrons.com>,
        <jason@lakedaemon.net>, <ezequiel.garcia@free-electrons.com>
CC: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH] PCI: mvebu: staticize mvebu_pcie_align_resource
Date: Thu, 7 Nov 2013 17:05:55 +0800
Message-ID: <1383815155-5318-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_03:2013-11-06,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311070013
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following sparse warning:
drivers/pci/host/pci-mvebu.c:676:17: warning: symbol
'mvebu_pcie_align_resource' was not declared. Should it be static?

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/pci/host/pci-mvebu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 729d5a1..bf4ff23 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -673,11 +673,11 @@ static struct pci_bus *mvebu_pcie_scan_bus(int nr, struct pci_sys_data *sys)
 	return bus;
 }
 
-resource_size_t mvebu_pcie_align_resource(struct pci_dev *dev,
-					  const struct resource *res,
-					  resource_size_t start,
-					  resource_size_t size,
-					  resource_size_t align)
+static resource_size_t mvebu_pcie_align_resource(struct pci_dev *dev,
+						 const struct resource *res,
+						 resource_size_t start,
+						 resource_size_t size,
+						 resource_size_t align)
 {
 	if (dev->bus->number != 0)
 		return start;
-- 
1.8.4.2

