Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab3KIGxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:53:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758589Ab3KIGwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: [PATCH 3.11 84/94] drm/radeon: make missing smc ucode non-fatal (r7xx-SI)
Date: Fri,  8 Nov 2013 22:52:30 -0800
Message-Id: <20131109065210.171487173@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d83671126dc8e7c0b56c9970ea5ffd08c3b0c645 upstream.

Prevent driver load problems if the smc is missing.

bug:
https://bugzilla.kernel.org/show_bug.cgi?id=63011

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Mikko Rapeli <mikko.rapeli@iki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/ni.c   |    1 +
 drivers/gpu/drm/radeon/r600.c |    1 +
 drivers/gpu/drm/radeon/si.c   |    1 +
 3 files changed, 3 insertions(+)

--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -800,6 +800,7 @@ int ni_init_microcode(struct radeon_devi
 			       fw_name);
 			release_firmware(rdev->smc_fw);
 			rdev->smc_fw = NULL;
+			err = 0;
 		} else if (rdev->smc_fw->size != smc_req_size) {
 			printk(KERN_ERR
 			       "ni_mc: Bogus length %zu in firmware \"%s\"\n",
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2310,6 +2310,7 @@ int r600_init_microcode(struct radeon_de
 			       fw_name);
 			release_firmware(rdev->smc_fw);
 			rdev->smc_fw = NULL;
+			err = 0;
 		} else if (rdev->smc_fw->size != smc_req_size) {
 			printk(KERN_ERR
 			       "smc: Bogus length %zu in firmware \"%s\"\n",
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -1669,6 +1669,7 @@ static int si_init_microcode(struct rade
 		       fw_name);
 		release_firmware(rdev->smc_fw);
 		rdev->smc_fw = NULL;
+		err = 0;
 	} else if (rdev->smc_fw->size != smc_req_size) {
 		printk(KERN_ERR
 		       "si_smc: Bogus length %zu in firmware \"%s\"\n",


