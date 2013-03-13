Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964975Ab3CMXdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:33:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17586 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964869Ab3CMX2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:37 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 18/27] PCI: Use for_each_pci_resource() in pci bases reading
Date: Wed, 13 Mar 2013 16:28:13 -0700
Message-Id: <1363217302-14383-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace those open code, and make code more readable.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/pci/probe.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ac751a6..263a575 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -354,9 +354,11 @@ out:
 static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 {
 	unsigned int pos, reg;
+	struct resource *res;
 
-	for (pos = 0; pos < howmany; pos++) {
-		struct resource *res = &dev->resource[pos];
+	for_each_pci_resource(dev, res, pos, PCI_STD_RES) {
+		if (pos >= howmany)
+			break;
 		reg = PCI_BASE_ADDRESS_0 + (pos << 2);
 		pos += __pci_read_base(dev, pci_bar_unknown, res, reg);
 	}
-- 
1.7.10.4

