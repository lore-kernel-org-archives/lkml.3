Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaLQXQ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 18:16:58 -0500
Received: from mail-bn1bon0115.outbound.protection.outlook.com ([157.56.111.115]:53600
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750949AbaLQXQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 18:16:57 -0500
X-WSS-ID: 0NGR200-08-B6G-02
X-M-MSG: 
From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To: <rjw@rjwysocki.net>, <lenb@kernel.org>, <hdegoede@redhat.com>,
        <tj@kernel.org>, <arnd@arndb.de>, <mjg59@srcf.ucam.org>
CC: <hanjun.guo@linaro.org>, <leo.duran@amd.com>, <graeme.gregory@linaro.org>,
        <linux-ide@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-acpi@lists.linaro.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [RFC PATCH 0/2] Introduce ACPI support for ahci_platform driver
Date: Wed, 17 Dec 2014 17:16:33 -0600
Message-ID: <1418858195-22857-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(33646002)(50226001)(20776003)(89996001)(101416001)(2201001)(77156002)(47776003)(46102003)(4396001)(62966003)(31966008)(97736003)(87936001)(53416004)(92566001)(99396003)(86362001)(64706001)(229853001)(107046002)(106466001)(84676001)(105586002)(19580405001)(15975445007)(120916001)(50986999)(36756003)(48376002)(68736005)(19273905006)(50466002)(21056001)(19580395003)(19300405004)(15395725005)(77096005)(562404015)(217873001)(563064011)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB200;
X-Forefront-PRVS: 042857DBB5
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch series introduce ACPI support for non-PCI AHCI platform driver.
Existing ACPI support for AHCI assumes the device controller is a PCI device.

Also, since there is no ACPI _HID/_CID for generic AHCI controller, the driver
could not use them for matching devices. Therefore, this patch introduces a mechanism
for drivers to match devices using ACPI _CLS method.

This patch series is rebased from:

    http://git.linaro.org/leg/acpi/acpi.git acpi-5.1-v6

This topic was discussed earlier here (as part of introducing support for
AMD Seattle SATA controller):

    http://marc.info/?l=linux-arm-kernel&m=141083492521584&w=2

Suravee Suthikulpanit (2):
  ACPI / scan: Add support for ACPI _CLS device matching
  ata: ahci_platform: Add ACPI _CLS matching

 drivers/acpi/scan.c             | 73 +++++++++++++++++++++++++++++++++++++++++
 drivers/ata/Kconfig             |  2 +-
 drivers/ata/ahci_platform.c     | 10 ++++++
 include/acpi/acnames.h          |  1 +
 include/linux/acpi.h            | 12 ++++++-
 include/linux/device.h          |  1 +
 include/linux/mod_devicetable.h |  6 ++++
 7 files changed, 103 insertions(+), 2 deletions(-)

-- 
1.9.3

