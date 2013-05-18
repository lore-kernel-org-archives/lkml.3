Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab3ERDAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:00:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab3ERDAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:06 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=WomMouZADaYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=0tSqJiJxTfQA:10 a=zd2uoN0lAAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021702.120937827@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:18:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [ 128/136 ] drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0128-drm-radeon-fix-endian-bugs-in-atom_allocate_fb_scrat.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit beb71fc61c2cad64e347f164991b8ef476529e64 ]

Reviwed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/atom.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index 5ce9bf5..43672b6 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1389,10 +1389,10 @@ int atom_allocate_fb_scratch(struct atom_context *ctx)
 		firmware_usage = (struct _ATOM_VRAM_USAGE_BY_FIRMWARE *)(ctx->bios + data_offset);
 
 		DRM_DEBUG("atom firmware requested %08x %dkb\n",
-			  firmware_usage->asFirmwareVramReserveInfo[0].ulStartAddrUsedByFirmware,
-			  firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb);
+			  le32_to_cpu(firmware_usage->asFirmwareVramReserveInfo[0].ulStartAddrUsedByFirmware),
+			  le16_to_cpu(firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb));
 
-		usage_bytes = firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb * 1024;
+		usage_bytes = le16_to_cpu(firmware_usage->asFirmwareVramReserveInfo[0].usFirmwareUseInKb) * 1024;
 	}
 	ctx->scratch_size_bytes = 0;
 	if (usage_bytes == 0)
-- 
1.7.10.4


