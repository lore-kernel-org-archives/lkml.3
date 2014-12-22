Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbaLVLHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:07:51 -0500
Received: from mail-by2on0135.outbound.protection.outlook.com ([207.46.100.135]:63680
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754446AbaLVLHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:07:49 -0500
X-WSS-ID: 0NGZDKV-07-84Y-02
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
Subject: [PATCH 2/2] drm: Put amdkfd before radeon in drm Makefile
Date: Mon, 22 Dec 2014 13:07:15 +0200
Message-ID: <1419246435-7050-3-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.20.0.84]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(64706001)(84676001)(105586002)(19580395003)(19580405001)(20776003)(47776003)(50466002)(48376002)(92566001)(89996001)(86362001)(87936001)(4396001)(50226001)(99396003)(229853001)(107046002)(77096005)(68736005)(36756003)(33646002)(50986999)(31966008)(101416001)(97736003)(62966003)(106466001)(76176999)(77156002)(46102003)(120916001)(21056001)(2950100001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp01.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CO1PR02MB205;
X-Forefront-PRVS: 0433DB2766
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-OriginatorOrg: amd4.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2014 11:07:46.2139
 (UTC)
X-MS-Exchange-CrossTenant-Id: fde4dada-be84-483f-92cc-e026cbee8e96
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=fde4dada-be84-483f-92cc-e026cbee8e96;Ip=[165.204.84.221]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR02MB205
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When amdkfd and radeon are compiled inside the kernel image (not as modules),
radeon will load before amdkfd, which will cause a bug when radeon will probe
the GPUs.

When the two drivers are compiled as modules, amdkfd is loaded after radeon is
loaded but before radeon starts probing the GPUs. This is done because radeon
loads the amdkfd module through symbol_request function.

This patch makes amdkfd load before radeon when they are both compiled inside
the kernel image, which makes the behavior similar to the case when they are
modules, and prevents the kernel bug.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 66e4039..e620807 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_DRM_MIPI_DSI) += drm_mipi_dsi.o
 obj-$(CONFIG_DRM_TTM)	+= ttm/
 obj-$(CONFIG_DRM_TDFX)	+= tdfx/
 obj-$(CONFIG_DRM_R128)	+= r128/
+obj-$(CONFIG_HSA_AMD) += amd/amdkfd/
 obj-$(CONFIG_DRM_RADEON)+= radeon/
 obj-$(CONFIG_DRM_MGA)	+= mga/
 obj-$(CONFIG_DRM_I810)	+= i810/
@@ -67,4 +68,3 @@ obj-$(CONFIG_DRM_IMX) += imx/
 obj-y			+= i2c/
 obj-y			+= panel/
 obj-y			+= bridge/
-obj-$(CONFIG_HSA_AMD) += amd/amdkfd/
-- 
1.9.1

