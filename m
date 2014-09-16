Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaIPUNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:13:49 -0400
Received: from mail-bn1bon0146.outbound.protection.outlook.com ([157.56.111.146]:13502
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752098AbaIPUNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:13:48 -0400
X-WSS-ID: 0NC0ENS-08-IZS-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <herrmann.der.user@googlemail.com>, <linux@roeck-us.net>,
        <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
CC: <boris.ostrovsky@oracle.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH V2 2/2] hwmon, fam15h_power: Add support for two more processors
Date: Tue, 16 Sep 2014 14:58:16 -0500
Message-ID: <1410897496-2600-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(20776003)(50226001)(101416001)(62966002)(19580405001)(50466002)(21056001)(68736004)(95666004)(92726001)(85852003)(90102001)(84676001)(89996001)(31966008)(47776003)(48376002)(107046002)(229853001)(50986999)(53416004)(99396002)(87286001)(83322001)(104166001)(81342003)(102836001)(85306004)(77156001)(83072002)(2201001)(64706001)(36756003)(86362001)(4396001)(105586002)(44976005)(92566001)(19580395003)(74662003)(46102003)(74502003)(87936001)(79102003)(97736003)(80022003)(88136002)(93916002)(77096002)(77982003)(81542003)(76482001)(106466001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB489;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fam16h,M30h(Mullins) and Fam15hM30h(Kaveri) processors can
report 'power_crit' value. So, adding their respective device ids.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 drivers/hwmon/fam15h_power.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 4ee0126..fcdbde4 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -232,7 +232,9 @@ static int fam15h_power_probe(struct pci_dev *pdev,
 
 static const struct pci_device_id fam15h_power_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, fam15h_power_id_table);
-- 
2.0.2

