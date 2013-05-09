Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab3EIWau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:30:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378Ab3EIW0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 61/73] drm/radeon: fix endian bugs in atom_allocate_fb_scratch()
Date: Thu,  9 May 2013 15:25:51 -0700
Message-Id: <20130509222532.595327035@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit beb71fc61c2cad64e347f164991b8ef476529e64 upstream.

Reviwed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atom.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -1394,10 +1394,10 @@ int atom_allocate_fb_scratch(struct atom
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


