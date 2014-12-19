Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaLSUNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:13:36 -0500
Received: from mail-bn1bon0140.outbound.protection.outlook.com ([157.56.111.140]:49090
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751165AbaLSUNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:13:32 -0500
X-WSS-ID: 0NGUIUD-07-ZFC-02
X-M-MSG: 
From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
To: <rjw@rjwysocki.net>, <lenb@kernel.org>, <hdegoede@redhat.com>,
        <tj@kernel.org>, <arnd@arndb.de>, <mjg59@srcf.ucam.org>
CC: <hanjun.guo@linaro.org>, <al.stone@linaro.org>,
        <graeme.gregory@linaro.org>, <leo.duran@amd.com>,
        <linux-ide@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linaro-acpi@lists.linaro.org>,
        "Suravee Suthikulpanit" <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/2] Introduce ACPI support for ahci_platform driver
Date: Fri, 19 Dec 2014 14:13:06 -0600
Message-ID: <1419019988-4398-1-git-send-email-Suravee.Suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(209900001)(199003)(189002)(20776003)(48376002)(77156002)(229853001)(68736005)(84676001)(50986999)(62966003)(2201001)(92566001)(87936001)(64706001)(50466002)(86362001)(19580395003)(50226001)(53416004)(4396001)(15395725005)(77096005)(21056001)(97736003)(15975445007)(107046002)(46102003)(106466001)(120916001)(105586002)(19273905006)(19300405004)(101416001)(99396003)(36756003)(89996001)(31966008)(562404015)(563064011)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB198;
X-Forefront-PRVS: 0430FA5CB7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2014 20:13:27.5323
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Changes from RFC (https://lkml.org/lkml/2014/12/17/446)
	* Remove #ifdef and make non-ACPI version of the acpi_match_device_cls
	  as inline. (per Arnd)
	* Simplify logic to retrieve and evaluate _CLS handle. (per Hanjun)

Suravee Suthikulpanit (2):
  ACPI / scan: Add support for ACPI _CLS device matching
  ata: ahci_platform: Add ACPI _CLS matching

 drivers/acpi/scan.c             | 63 +++++++++++++++++++++++++++++++++++++++++
 drivers/ata/Kconfig             |  2 +-
 drivers/ata/ahci_platform.c     |  3 ++
 include/acpi/acnames.h          |  1 +
 include/linux/acpi.h            | 12 +++++++-
 include/linux/device.h          |  1 +
 include/linux/mod_devicetable.h |  6 ++++
 7 files changed, 86 insertions(+), 2 deletions(-)

-- 
1.9.3

