Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbaCNQRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:17:48 -0400
Received: from mail-bn14138.inbound.protection.outlook.com ([207.46.163.138]:52101
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755043AbaCNQRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:17:46 -0400
Date: Fri, 14 Mar 2014 21:43:27 +0530
From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
To: <jejb@kernel.org>, <JBottomley@Parallels.com>
CC: <linux-scsi@vger.kernel.org>, <Sathya.Prakash@lsi.com>,
        <Nagalakshmi.Nandigama@lsi.com>, <sreekanth.reddy@lsi.com>,
        <linux-kernel@vger.kernel.org>, <sreekanthreddy0547@gmail.com>
Subject: [PATCH 7/9][SCSI]mpt3sas: Added OEM branding Strings
Message-ID: <20140314161327.GA8398@lsi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.19.220.100;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(76482001)(4396001)(74366001)(23726002)(16796002)(94316002)(33656001)(19580395003)(31966008)(59766001)(85852003)(97336001)(83072002)(95666003)(74706001)(50466002)(77982001)(63696002)(93136001)(46102001)(46406003)(56776001)(20776003)(47776003)(54316002)(47446002)(94946001)(83506001)(85306002)(97756001)(80976001)(74662001)(74502001)(93516002)(81342001)(77096001)(49866001)(87936001)(90146001)(51856001)(56816005)(47736001)(6806004)(92566001)(81542001)(76796001)(76786001)(81686001)(44976005)(36756003)(53806001)(79102001)(50986001)(54356001)(97186001)(83322001)(19580405001)(95416001)(74876001)(65816001)(80022001)(86362001)(81816001)(69226001)(76176001)(57986002)(47976001)(87266001)(92726001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR07MB075;H:COSEXCH10.lsi.com;FPR:AE09FF48.6BD65CDC.90FD5B6B.9CD75A01.2029E;PTR:cosexch10.lsi.com;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0150F3F97D
X-OriginatorOrg: lsi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added following branding Strings for Intel custom HBAs support.

Driver String:                                  Vendor ID       Device ID       SubSystemVendor ID      SubSystemDevice ID
Intel(R) Integrated RAID Module RMS3JC080       0x1000          0x0097          0x8086                  0x3521
Intel(R) RAID Controller RS3GC008               0x1000          0x0097          0x8086                  0x3522
Intel(R) RAID Controller RS3FC044               0x1000          0x0097          0x8086                  0x3523
Intel(R) RAID Controller RS3UC080               0x1000          0x0097          0x8086                  0x3524

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
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

