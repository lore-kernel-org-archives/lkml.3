Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbaFYKqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:46:00 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:46281
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753872AbaFYKp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:45:58 -0400
Date: Wed, 25 Jun 2014 16:11:10 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@avagotech.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@avagotech.com>,
        <Nagalakshmi.Nandigama@avagotech.com>, <sreekanth.reddy@avagotech.com>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <martin.petersen@oracle.com>
Subject: [RESEND][PATCH 6/8][SCSI]mpt3sas: Added OEM branding Strings
Message-ID: <20140625104110.GA13027@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130481667562500999;(f081dce6-2920-4dfc-23e8-08d07091c5e3);()
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(99396002)(95666004)(46102001)(54356999)(76482001)(81542001)(83506001)(50986999)(21056001)(4396001)(97756001)(74502001)(74662001)(16796002)(31966008)(33656002)(102836001)(83072002)(85852003)(19580395003)(44976005)(83322001)(19580405001)(6806004)(23726002)(107046001)(36756003)(50466002)(106466001)(105596002)(79102001)(77982001)(80022001)(57986006)(47776003)(20776003)(64706001)(76506005)(77096002)(46406003)(85306003)(81342001)(26826002)(86362001)(92566001)(87936001)(92726001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR07MB026;H:COSEXCH10.lsi.com;FPR:;MLV:ovrnspm;PTR:cosexch10.lsi.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02530BD3AA
Authentication-Results: spf=softfail (sender IP is 192.19.220.100)
 smtp.mailfrom=Sreekanth.Reddy@avagotech.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added following branding Strings for Intel custom HBAs support.

Driver String:                                  Vendor ID       Device ID       SubSystemVendor ID      SubSystemDevice ID
Intel(R) Integrated RAID Module RMS3JC080       0x1000          0x0097          0x8086                  0x3521
Intel(R) RAID Controller RS3GC008               0x1000          0x0097          0x8086                  0x3522
Intel(R) RAID Controller RS3FC044               0x1000          0x0097          0x8086                  0x3523
Intel(R) RAID Controller RS3UC080               0x1000          0x0097          0x8086                  0x3524

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |   49 +++++++++++++++++++++++++++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.h |   18 +++++++++++++
 2 files changed, 67 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8c77cd4..f1406cc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2219,6 +2219,53 @@ mpt3sas_base_put_smid_default(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 	    &ioc->scsi_lookup_lock);
 }
 
+/**
+ * _base_display_intel_branding - Display branding string
+ * @ioc: per adapter object
+ *
+ * Return nothing.
+ */
+static void
+_base_display_intel_branding(struct MPT3SAS_ADAPTER *ioc)
+{
+	if (ioc->pdev->subsystem_vendor != PCI_VENDOR_ID_INTEL)
+		return;
+
+	switch (ioc->pdev->device) {
+	case MPI25_MFGPAGE_DEVID_SAS3008:
+		switch (ioc->pdev->subsystem_device) {
+		case MPT3SAS_INTEL_RMS3JC080_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_INTEL_RMS3JC080_BRANDING);
+			break;
+
+		case MPT3SAS_INTEL_RS3GC008_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_INTEL_RS3GC008_BRANDING);
+			break;
+		case MPT3SAS_INTEL_RS3FC044_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_INTEL_RS3FC044_BRANDING);
+			break;
+		case MPT3SAS_INTEL_RS3UC080_SSDID:
+			pr_info(MPT3SAS_FMT "%s\n", ioc->name,
+				MPT3SAS_INTEL_RS3UC080_BRANDING);
+			break;
+		default:
+			pr_info(MPT3SAS_FMT
+				"Intel(R) Controller: Subsystem ID: 0x%X\n",
+				ioc->name, ioc->pdev->subsystem_device);
+			break;
+		}
+		break;
+	default:
+		pr_info(MPT3SAS_FMT
+			"Intel(R) Controller: Subsystem ID: 0x%X\n",
+			ioc->name, ioc->pdev->subsystem_device);
+		break;
+	}
+}
+
 
 
 /**
@@ -2250,6 +2297,8 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 	   (bios_version & 0x0000FF00) >> 8,
 	    bios_version & 0x000000FF);
 
+	_base_display_intel_branding(ioc);
+
 	pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
 
 	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_INITIATOR) {
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index f163423..f61765c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -130,7 +130,25 @@
 #define MPT_TARGET_FLAGS_DELETED	0x04
 #define MPT_TARGET_FASTPATH_IO		0x08
 
+/*
+ * Intel HBA branding
+ */
+#define MPT3SAS_INTEL_RMS3JC080_BRANDING       \
+	"Intel(R) Integrated RAID Module RMS3JC080"
+#define MPT3SAS_INTEL_RS3GC008_BRANDING       \
+	"Intel(R) RAID Controller RS3GC008"
+#define MPT3SAS_INTEL_RS3FC044_BRANDING       \
+	"Intel(R) RAID Controller RS3FC044"
+#define MPT3SAS_INTEL_RS3UC080_BRANDING       \
+	"Intel(R) RAID Controller RS3UC080"
 
+/*
+ * Intel HBA SSDIDs
+ */
+#define MPT3SAS_INTEL_RMS3JC080_SSDID	0x3521
+#define MPT3SAS_INTEL_RS3GC008_SSDID	0x3522
+#define MPT3SAS_INTEL_RS3FC044_SSDID	0x3523
+#define MPT3SAS_INTEL_RS3UC080_SSDID    0x3524
 
 /*
  * status bits for ioc->diag_buffer_status
-- 
1.7.1

