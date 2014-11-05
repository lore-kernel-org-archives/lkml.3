Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaKEGKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 01:10:00 -0500
Received: from mail-bn1bon0131.outbound.protection.outlook.com ([157.56.111.131]:28919
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751369AbaKEGJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 01:09:58 -0500
X-WSS-ID: 0NEJYGC-07-A9X-02
X-M-MSG: 
From: Vincent Wan <vincent.wan@amd.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Arindam Nath <arindam.nath@amd.com>, Huang Rui <ray.huang@amd.com>,
        Wan Zongshun <mcuos.com@gmail.com>, Vincent Wan <vincent.wan@amd.com>
Subject: [PATCH v3 3/3] mmc:sdhci-pci: enable sdhci doesn't support hs200 quirk for AMD sdhci
Date: Wed, 5 Nov 2014 14:09:28 +0800
Message-ID: <1415167768-5839-1-git-send-email-vincent.wan@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(19580395003)(19580405001)(36756003)(93916002)(110136001)(50986999)(33646002)(87936001)(87286001)(53416004)(50466002)(50226001)(89996001)(77156002)(97736003)(84676001)(4396001)(77096003)(48376002)(86362001)(44976005)(88136002)(68736004)(31966008)(102836001)(99396003)(21056001)(106466001)(105586002)(92726001)(120916001)(101416001)(92566001)(104166001)(95666004)(107046002)(62966003)(64706001)(229853001)(47776003)(20776003)(46102003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Vincent.Wan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD SD controller supports the SDR104 mode, but caps2 can not
be promoted to support hs200 for eMMC.

Signed-off-by: Vincent Wan <vincent.wan@amd.com>
Signed-off-by: Wan Zongshun <mcuos.com@gmail.com>
---
 drivers/mmc/host/sdhci-pci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 5a77f18..c1ecd20 100644
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

