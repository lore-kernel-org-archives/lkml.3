Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab3ETLSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:18:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56068 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3ETKwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 034/115] drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
Date: Mon, 20 May 2013 11:50:34 +0100
Message-Id: <1369047116-9378-35-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit beb71fc61c2cad64e347f164991b8ef476529e64 upstream.

Reviwed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/atom.c | 6 +++---
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
1.8.1.2

