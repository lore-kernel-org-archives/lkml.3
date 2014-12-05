Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaLEXBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:01:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbaLEW4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.14 66/73] drm/radeon: fix endian swapping in vbios fetch for tdp table
Date: Fri,  5 Dec 2014 14:45:12 -0800
Message-Id: <20141205224435.902569295@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 28731d5818ae25b92d1fb82fe0ac196e97102c1b upstream.

Value needs to be swapped on BE.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_dpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/r600_dpm.c
+++ b/drivers/gpu/drm/radeon/r600_dpm.c
@@ -1209,7 +1209,7 @@ int r600_parse_extended_power_table(stru
 					(mode_info->atom_context->bios + data_offset +
 					 le16_to_cpu(ext_hdr->usPowerTuneTableOffset));
 				rdev->pm.dpm.dyn_state.cac_tdp_table->maximum_power_delivery_limit =
-					ppt->usMaximumPowerDeliveryLimit;
+					le16_to_cpu(ppt->usMaximumPowerDeliveryLimit);
 				pt = &ppt->power_tune_table;
 			} else {
 				ATOM_PPLIB_POWERTUNE_Table *ppt = (ATOM_PPLIB_POWERTUNE_Table *)


