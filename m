Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495Ab3I3KXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:23:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43680 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab3I3KNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:13:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 068/104] drm/radeon: fix LCD record parsing
Date: Mon, 30 Sep 2013 11:10:45 +0100
Message-Id: <1380535881-9239-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 95663948ba22a4be8b99acd67fbf83e86ddffba4 upstream.

If the LCD table contains an EDID record, properly account
for the edid size when walking through the records.

This should fix error messages about unknown LCD records.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 38d87e1..fa9b022 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1622,7 +1622,9 @@ struct radeon_encoder_atom_dig *radeon_atombios_get_lvds_info(struct
 								kfree(edid);
 						}
 					}
-					record += sizeof(ATOM_FAKE_EDID_PATCH_RECORD);
+					record += fake_edid_record->ucFakeEDIDLength ?
+						fake_edid_record->ucFakeEDIDLength + 2 :
+						sizeof(ATOM_FAKE_EDID_PATCH_RECORD);
 					break;
 				case LCD_PANEL_RESOLUTION_RECORD_TYPE:
 					panel_res_record = (ATOM_PANEL_RESOLUTION_PATCH_RECORD *)record;
-- 
1.8.3.2

