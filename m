Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248Ab3EIWme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:42:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441Ab3EIWey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:34:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 15/26] drm/radeon/dce6: add missing display reg for tiling setup
Date: Thu,  9 May 2013 15:34:29 -0700
Message-Id: <20130509223424.027627391@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509223422.368544659@linuxfoundation.org>
References: <20130509223422.368544659@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 7c1c7c18fc752b2a1d07597286467ef186312463 upstream.

A new tiling config register for the display blocks was
added on DCE6.

May fix:
https://bugs.freedesktop.org/show_bug.cgi?id=62889
https://bugs.freedesktop.org/show_bug.cgi?id=57919

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ni.c  |    2 ++
 drivers/gpu/drm/radeon/nid.h |    4 ++++
 drivers/gpu/drm/radeon/si.c  |    1 +
 drivers/gpu/drm/radeon/sid.h |    2 ++
 4 files changed, 9 insertions(+)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -911,6 +911,8 @@ static void cayman_gpu_init(struct radeo
 	WREG32(GB_BACKEND_MAP, gb_backend_map);
 	WREG32(GB_ADDR_CONFIG, gb_addr_config);
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
+	if (ASIC_IS_DCE6(rdev))
+		WREG32(DMIF_ADDR_CALC, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
 
 	/* primary versions */
--- a/drivers/gpu/drm/radeon/nid.h
+++ b/drivers/gpu/drm/radeon/nid.h
@@ -42,6 +42,10 @@
 #define CAYMAN_MAX_TCC_MASK          0xFF
 
 #define DMIF_ADDR_CONFIG  				0xBD4
+
+/* DCE6 only */
+#define DMIF_ADDR_CALC  				0xC00
+
 #define	SRBM_GFX_CNTL				        0x0E44
 #define		RINGID(x)					(((x) & 0x3) << 0)
 #define		VMID(x)						(((x) & 0x7) << 0)
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1799,6 +1799,7 @@ static void si_gpu_init(struct radeon_de
 	rdev->config.si.backend_map = gb_backend_map;
 	WREG32(GB_ADDR_CONFIG, gb_addr_config);
 	WREG32(DMIF_ADDR_CONFIG, gb_addr_config);
+	WREG32(DMIF_ADDR_CALC, gb_addr_config);
 	WREG32(HDP_ADDR_CONFIG, gb_addr_config);
 
 	/* primary versions */
--- a/drivers/gpu/drm/radeon/sid.h
+++ b/drivers/gpu/drm/radeon/sid.h
@@ -55,6 +55,8 @@
 
 #define DMIF_ADDR_CONFIG  				0xBD4
 
+#define DMIF_ADDR_CALC  				0xC00
+
 #define	SRBM_STATUS				        0xE50
 
 #define	CC_SYS_RB_BACKEND_DISABLE			0xe80


