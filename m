Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbaIRTjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:39:16 -0400
Received: from mail-bn1bn0104.outbound.protection.outlook.com ([157.56.110.104]:65372
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756525AbaIRTjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:39:14 -0400
X-WSS-ID: 0NC43X7-07-PQ1-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <bp@suse.de>,
        <dan.carpenter@oracle.com>, <dougthompson@xmission.com>,
        <bp@alien8.de>, <m.chehab@samsung.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 3/4] edac: Add DDR3 LRDIMM support, entries in edac_mem_types[]
Date: Thu, 18 Sep 2014 14:56:58 -0500
Message-ID: <1411070218-10258-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(2201001)(93916002)(99396002)(47776003)(92726001)(95666004)(87936001)(104166001)(36756003)(83072002)(83322001)(101416001)(85852003)(74502003)(92566001)(106466001)(44976005)(19580395003)(20776003)(89996001)(85306004)(90102001)(21056001)(81342003)(74662003)(77982003)(64706001)(50226001)(88136002)(50986999)(68736004)(19580405001)(81542003)(53416004)(105586002)(79102003)(86362001)(76482002)(46102003)(62966002)(50466002)(97736003)(229853001)(107046002)(77096002)(31966008)(48376002)(77156001)(80022003)(87286001)(4396001)(84676001)(1121002)(921003)(83996005)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

F15hM60h adds support for DDR4 and DDR3 LRDIMMS. Adding them here.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 drivers/edac/edac_mc.c | 3 +++
 include/linux/edac.h   | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 9f134823..71fd9fb 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -146,6 +146,9 @@ const char *edac_mem_types[] = {
 	"Rambus XDR",
 	"Unbuffered DDR3 RAM",
 	"Registered DDR3 RAM",
+	"Load-Reduce DDR3 RAM",
+	"Unbuffered DDR4 RAM",
+	"Registered DDR4 RAM",
 };
 EXPORT_SYMBOL_GPL(edac_mem_types);
 
diff --git a/include/linux/edac.h b/include/linux/edac.h
index e1e68da..7a80100 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -194,6 +194,7 @@ static inline char *mc_event_error_type(const unsigned int err_type)
  * @MEM_DDR3:		DDR3 RAM
  * @MEM_RDDR3:		Registered DDR3 RAM
  *			This is a variant of the DDR3 memories.
+ * @MEM_LRDDR3		Load-Reduce DDR3 memory
  * @MEM_DDR4:		DDR4 RAM
  * @MEM_RDDR4:		Registered DDR4 RAM
  *			This is a variant of the DDR4 memories.
@@ -216,6 +217,7 @@ enum mem_type {
 	MEM_XDR,
 	MEM_DDR3,
 	MEM_RDDR3,
+	MEM_LRDDR3,
 	MEM_DDR4,
 	MEM_RDDR4,
 };
-- 
2.0.2

