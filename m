Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaKUUyF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:54:05 -0500
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:26400
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751097AbaKUUyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:54:03 -0500
X-WSS-ID: 0NFEQ1X-07-E5V-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <dri-devel@lists.freedesktop.org>
CC: <bp@alien8.de>, <pebolle@tiscali.nl>, <linux-kernel@vger.kernel.org>,
        <airlied@linux.ie>, <alexander.deucher@amd.com>, <j.glisse@gmail.com>,
        <John.Bridgman@amd.com>
Subject: [PATCH resend] amdkfd: Remove DRM_AMDGPU dependency from Kconfig
Date: Fri, 21 Nov 2014 22:53:48 +0200
Message-ID: <1416603228-8918-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(36756003)(33646002)(68736004)(105586002)(104166001)(89996001)(4396001)(88136002)(107046002)(87936001)(2351001)(31966008)(229853001)(106466001)(77096003)(97736003)(92566001)(95666004)(87286001)(50226001)(62966003)(50986999)(77156002)(21056001)(84676001)(48376002)(93916002)(86362001)(102836001)(92726001)(19580405001)(19580395003)(64706001)(101416001)(47776003)(50466002)(46102003)(20776003)(44976005)(99396003)(110136001)(53416004)(120916001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Forefront-PRVS: 0402872DA1
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the dependency of amdkfd upon DRM_AMDGPU symbol in amdkfd's
Kconfig file.

This is done because amdgpu driver is not yet upstreamed and therefore,
DRM_AMDGPU symbol is not present in any Kconfig file.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/Kconfig b/drivers/gpu/drm/amd/amdkfd/Kconfig
index e13c67c..8dfac37 100644
--- a/drivers/gpu/drm/amd/amdkfd/Kconfig
+++ b/drivers/gpu/drm/amd/amdkfd/Kconfig
@@ -4,6 +4,6 @@
 
 config HSA_AMD
 	tristate "HSA kernel driver for AMD GPU devices"
-	depends on (DRM_RADEON || DRM_AMDGPU) && AMD_IOMMU_V2 && X86_64
+	depends on DRM_RADEON && AMD_IOMMU_V2 && X86_64
 	help
 	  Enable this if you want to use HSA features on AMD GPU devices.
-- 
2.1.0

