Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801Ab3CMX2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:28:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51112 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934421Ab3CMX2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:28:30 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Ram Pai <linuxram@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 05/27] PCI: Update pci_resource_start etc to use pci_dev_resource_n()
Date: Wed, 13 Mar 2013 16:28:00 -0700
Message-Id: <1363217302-14383-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
References: <1363217302-14383-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now pci_resource_start is using dev->resource[n] directly.
Replace it with pci_dev_resource[n] to prepare for addon resource support.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/pci.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index efb348b..94935fc 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1488,9 +1488,9 @@ static inline struct pci_dev *pci_dev_get(struct pci_dev *dev)
 
 /* these helpers provide future and backwards compatibility
  * for accessing popular PCI BAR info */
-#define pci_resource_start(dev, bar)	((dev)->resource[(bar)].start)
-#define pci_resource_end(dev, bar)	((dev)->resource[(bar)].end)
-#define pci_resource_flags(dev, bar)	((dev)->resource[(bar)].flags)
+#define pci_resource_start(dev, bar)	(pci_dev_resource_n(dev, (bar))->start)
+#define pci_resource_end(dev, bar)	(pci_dev_resource_n(dev, (bar))->end)
+#define pci_resource_flags(dev, bar)	(pci_dev_resource_n(dev, (bar))->flags)
 #define pci_resource_len(dev,bar) \
 	((pci_resource_start((dev), (bar)) == 0 &&	\
 	  pci_resource_end((dev), (bar)) ==		\
-- 
1.7.10.4

