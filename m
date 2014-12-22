Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbaLVLHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:07:48 -0500
Received: from mail-bn1bon0138.outbound.protection.outlook.com ([157.56.111.138]:22678
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751173AbaLVLHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:07:45 -0500
X-WSS-ID: 0NGZDKR-07-84U-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, Joerg Roedel <joro@8bytes.org>,
        "Jerome Glisse" <j.glisse@gmail.com>,
        John Bridgman <John.Bridgman@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Dana Elifaz <Dana.Elifaz@amd.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] drivers: Move iommu/ before gpu/ in Makefile
Date: Mon, 22 Dec 2014 13:07:14 +0200
Message-ID: <1419246435-7050-2-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(19580405001)(19580395003)(50226001)(46102003)(120916001)(50466002)(48376002)(20776003)(47776003)(64706001)(68736005)(92566001)(84676001)(76176999)(101416001)(77096005)(2950100001)(21056001)(89996001)(36756003)(50986999)(97736003)(87936001)(31966008)(33646002)(99396003)(105586002)(86362001)(106466001)(107046002)(77156002)(229853001)(62966003)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB200;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR02MB200;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB200;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 11:07:41.3159
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR02MB200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD GPU devices are dependent on AMD IOMMU controller functionality to allow
the GPU to access a process's virtual memory address space, without the need
for pinning the memory.

This patch changes the order in the drivers makefile, so iommu/ subsystem is
linked before gpu/ subsystem. That way, if the gpu and iommu drivers are
compiled inside the kernel image (not as modules), the correct order of device
loading is still maintained (iommu module is loaded before gpu module).

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/Makefile | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/Makefile b/drivers/Makefile
index ebee555..106200f 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -50,7 +50,10 @@ obj-$(CONFIG_RESET_CONTROLLER)	+= reset/
 obj-y				+= tty/
 obj-y				+= char/
 
-# gpu/ comes after char for AGP vs DRM startup
+# iommu/ comes before gpu as gpu are using iommu controllers
+obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
+
+# gpu/ comes after char for AGP vs DRM startup and after iommu
 obj-y				+= gpu/
 
 obj-$(CONFIG_CONNECTOR)		+= connector/
@@ -141,7 +144,6 @@ obj-y				+= clk/
 
 obj-$(CONFIG_MAILBOX)		+= mailbox/
 obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
-obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
 obj-$(CONFIG_REMOTEPROC)	+= remoteproc/
 obj-$(CONFIG_RPMSG)		+= rpmsg/
 
-- 
1.9.1

