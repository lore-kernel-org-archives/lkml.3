Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab3I2TzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:55:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59359 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595Ab3I2T2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 25/49] drm/radeon: fix LCD record parsing
Date: Sun, 29 Sep 2013 12:26:59 -0700
Message-Id: <20130929191604.722286843@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 95663948ba22a4be8b99acd67fbf83e86ddffba4 upstream.

If the LCD table contains an EDID record, properly account
for the edid size when walking through the records.

This should fix error messages about unknown LCD records.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_atombios.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -1651,7 +1651,9 @@ struct radeon_encoder_atom_dig *radeon_a
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


