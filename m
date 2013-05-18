Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab3ERDAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:00:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758659Ab3ERDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:14 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=rS4Za1bS8aoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=LGfML--cv78A:10 a=zd2uoN0lAAAA:8 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=TXmISBuIXQS5DBrPwsUA:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021700.554484740@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [ 118/136 ] drm/radeon/dce6: add missing display reg for tiling setup
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0118-drm-radeon-dce6-add-missing-display-reg-for-tiling-s.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 7c1c7c18fc752b2a1d07597286467ef186312463 ]

A new tiling config register for the display blocks was
added on DCE6.

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=62889
https://bugs.freedesktop.org/show_bug.cgi?id=57919

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/ni.c  |    2 ++
 drivers/gpu/drm/radeon/nid.h |    4 ++++
 drivers/gpu/drm/radeon/si.c  |    1 +
 drivers/gpu/drm/radeon/sid.h |    2 ++
 4 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index eecf30f..338b71f 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -619,6 +619,8 @@ static void cayman_gpu_init(struct radeon_device *rdev)
 
 	WREG32(GB_ADDR_CONFIG, gb_addr_config);
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
+	if (ASIC_IS_DCE6(rdev))
+		WREG32(DMIF_ADDR_CALC, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
 
 	tmp = gb_addr_config & NUM_PIPES_MASK;
diff --git a/drivers/gpu/drm/radeon/nid.h b/drivers/gpu/drm/radeon/nid.h
index 870db34..e17d4dd 100644
--- a/drivers/gpu/drm/radeon/nid.h
+++ b/drivers/gpu/drm/radeon/nid.h
@@ -45,6 +45,10 @@
 #define ARUBA_GB_ADDR_CONFIG_GOLDEN        0x12010001
 
 #define DMIF_ADDR_CONFIG  				0xBD4
+
+/* DCE6 only */
+#define DMIF_ADDR_CALC  				0xC00
+
 #define	SRBM_GFX_CNTL				        0x0E44
 #define		RINGID(x)					(((x) & 0x3) << 0)
 #define		VMID(x)						(((x) & 0x7) << 0)
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 6ab4a90..992e60c 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1659,6 +1659,7 @@ static void si_gpu_init(struct radeon_device *rdev)
 
 	WREG32(GB_ADDR_CONFIG, gb_addr_config);
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
+	WREG32(DMIF_ADDR_CALC, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
 
 	si_tiling_mode_table_init(rdev);
diff --git a/drivers/gpu/drm/radeon/sid.h b/drivers/gpu/drm/radeon/sid.h
index 6f0083a..778b7de 100644
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -60,6 +60,8 @@
 
 #define DMIF_ADDR_CONFIG  				0xBD4
 
+#define DMIF_ADDR_CALC  				0xC00
+
 #define	SRBM_STATUS				        0xE50
 
 #define	CC_SYS_RB_BACKEND_DISABLE			0xe80
-- 
1.7.10.4


