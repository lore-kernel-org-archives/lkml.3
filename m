Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaKDJ2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:28:10 -0500
Received: from mail-bl2on0143.outbound.protection.outlook.com ([65.55.169.143]:55424
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750985AbaKDJ2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:28:06 -0500
X-Greylist: delayed 3452 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2014 04:28:06 EST
X-WSS-ID: 0NEICYM-08-YX6-02
X-M-MSG: 
From: Vincent Wan <vincent.wan@amd.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Arindam Nath <arindam.nath@amd.com>, Huang Rui <ray.huang@amd.com>,
        Vincent Wan <vincent.wan@amd.com>
Subject: [PATCH] mmc: Add a quirk for AMD SD controller doesn't support HS200
Date: Tue, 4 Nov 2014 17:27:39 +0800
Message-ID: <1415093259-5076-1-git-send-email-vincent.wan@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(21056001)(64706001)(53416004)(84676001)(33646002)(46102003)(4396001)(99396003)(104166001)(87936001)(31966008)(105586002)(50226001)(110136001)(47776003)(20776003)(106466001)(120916001)(102836001)(107046002)(95666004)(229853001)(86362001)(89996001)(101416001)(36756003)(50466002)(87286001)(77096003)(19580395003)(92726001)(62966003)(44976005)(19580405001)(50986999)(77156002)(68736004)(88136002)(48376002)(97736003)(93916002)(92566001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03853D523D
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Vincent.Wan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD SD controller support the SDR104 mode, but caps2 can not
be promoted to support hs200 for eMMC.

Signed-off-by: Vincent Wan <vincent.wan@amd.com>
---
 drivers/mmc/host/sdhci-pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 8f5c998..6b4e84c 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -652,8 +652,10 @@ static int amd_probe(struct sdhci_pci_chip *chip)
 	smbus_dev = pci_get_device(PCI_VENDOR_ID_AMD,
 			PCI_DEVICE_ID_AMD_HUDSON2_SMBUS, NULL);
 
-	if (smbus_dev && (smbus_dev->revision < 0x51))
+	if (smbus_dev && (smbus_dev->revision < 0x51)) {
 		chip->quirks2 |= SDHCI_QUIRK2_CLEAR_TRANSFERMODE_REG_BEFORE_CMD;
+		chip->quirks2 |= SDHCI_QUIRK2_BROKEN_HS200;
+	}
 
 	return 0;
 }
-- 
1.8.1.2

