Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbaIPPVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:21:30 -0400
Received: from mail-by2on0134.outbound.protection.outlook.com ([207.46.100.134]:58784
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754512AbaIPPVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:21:25 -0400
X-WSS-ID: 0NC02NJ-08-6OF-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <herrmann.der.user@googlemail.com>, <linux@roeck-us.net>,
        <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
CC: <boris.ostrovsky@oracle.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 2/2] hwmon, fam15h_power: Add support for two more processors
Date: Tue, 16 Sep 2014 10:38:55 -0500
Message-ID: <1410881935-1431-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(64706001)(50466002)(105586002)(229853001)(89996001)(76482001)(97736003)(92726001)(87936001)(81542003)(48376002)(46102003)(99396002)(85306004)(74662003)(74502003)(79102003)(85852003)(81342003)(95666004)(80022003)(77982003)(77156001)(101416001)(104166001)(19580395003)(21056001)(92566001)(47776003)(107046002)(102836001)(88136002)(68736004)(83322001)(36756003)(19580405001)(106466001)(4396001)(77096002)(20776003)(90102001)(84676001)(93916002)(86362001)(62966002)(87286001)(50226001)(2201001)(31966008)(83072002)(44976005)(53416004)(50986999)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR02MB493;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
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
index 5ca24de..1e3b83a 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -233,7 +233,9 @@ static int fam15h_power_probe(struct pci_dev *pdev,
 
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

