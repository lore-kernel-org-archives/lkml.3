Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab3CREiO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:38:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33660 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752219Ab3CREbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:07 -0400
Message-Id: <20130318042146.960354416@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:11 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Deucher <alexander.deucher@amd.com>
Subject: [ 27/82] drm/radeon: add primary dac adj quirk for R200 board
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit e8fc41377f5037ff7a661ea06adc05f1daec1548 upstream.

vbios values are wrong leading to colors that are
too bright.  Use the default values instead.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
 


