Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964934Ab3CLWsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:48:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964871Ab3CLWom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:44:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 12/21] drm/radeon: add primary dac adj quirk for R200 board
Date: Tue, 12 Mar 2013 15:44:14 -0700
Message-Id: <20130312223246.546369831@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223245.109098379@linuxfoundation.org>
References: <20130312223245.109098379@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e8fc41377f5037ff7a661ea06adc05f1daec1548 upstream.

vbios values are wrong leading to colors that are
too bright.  Use the default values instead.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_combios.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -958,6 +958,15 @@ struct radeon_encoder_primary_dac *radeo
 			found = 1;
 	}
 
+	/* quirks */
+	/* Radeon 9100 (R200) */
+	if ((dev->pdev->device == 0x514D) &&
+	    (dev->pdev->subsystem_vendor == 0x174B) &&
+	    (dev->pdev->subsystem_device == 0x7149)) {
+		/* vbios value is bad, use the default */
+		found = 0;
+	}
+
 	if (!found) /* fallback to defaults */
 		radeon_legacy_get_primary_dac_info_from_table(rdev, p_dac);
 


