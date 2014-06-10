Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936239AbaFJAcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:32:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934535AbaFJAWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Bottomley <JBottomley@Parallels.com>,
        Ben Hutchings <ben@decadent.org.uk>, Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 66/88] hpsa: gen8plus Smart Array IDs
Date: Mon,  9 Jun 2014 17:25:16 -0700
Message-Id: <20140610002426.678899803@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Miller <mike.miller@hp.com>

commit fe0c9610bb68dd0aad1017456f5e3c31264d70c2 upstream.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/hpsa.c     |   32 +++++++++++++++++++++++++-------
 include/linux/pci_ids.h |    1 +
 2 files changed, 26 insertions(+), 7 deletions(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -99,6 +99,15 @@ static const struct pci_device_id hpsa_p
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1920},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1921},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1922},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1923},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1924},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1925},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1926},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1928},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x334d},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -118,13 +127,22 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324a103C, "Smart Array P712m", &SA5_access},
 	{0x324b103C, "Smart Array P711m", &SA5_access},
-	{0x3350103C, "Smart Array", &SA5_access},
-	{0x3351103C, "Smart Array", &SA5_access},
-	{0x3352103C, "Smart Array", &SA5_access},
-	{0x3353103C, "Smart Array", &SA5_access},
-	{0x3354103C, "Smart Array", &SA5_access},
-	{0x3355103C, "Smart Array", &SA5_access},
-	{0x3356103C, "Smart Array", &SA5_access},
+	{0x3350103C, "Smart Array P222", &SA5_access},
+	{0x3351103C, "Smart Array P420", &SA5_access},
+	{0x3352103C, "Smart Array P421", &SA5_access},
+	{0x3353103C, "Smart Array P822", &SA5_access},
+	{0x3354103C, "Smart Array P420i", &SA5_access},
+	{0x3355103C, "Smart Array P220i", &SA5_access},
+	{0x3356103C, "Smart Array P721m", &SA5_access},
+	{0x1920103C, "Smart Array", &SA5_access},
+	{0x1921103C, "Smart Array", &SA5_access},
+	{0x1922103C, "Smart Array", &SA5_access},
+	{0x1923103C, "Smart Array", &SA5_access},
+	{0x1924103C, "Smart Array", &SA5_access},
+	{0x1925103C, "Smart Array", &SA5_access},
+	{0x1926103C, "Smart Array", &SA5_access},
+	{0x1928103C, "Smart Array", &SA5_access},
+	{0x334d103C, "Smart Array P822se", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -752,6 +752,7 @@
 #define PCI_DEVICE_ID_HP_CISSD		0x3238
 #define PCI_DEVICE_ID_HP_CISSE		0x323a
 #define PCI_DEVICE_ID_HP_CISSF		0x323b
+#define PCI_DEVICE_ID_HP_CISSH		0x323c
 #define PCI_DEVICE_ID_HP_ZX2_IOC	0x4031
 
 #define PCI_VENDOR_ID_PCTECH		0x1042


