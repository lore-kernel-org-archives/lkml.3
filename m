Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbbAYS7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:59:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbbAYSJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.18 038/183] drm/radeon: adjust default bapm settings for KV
Date: Sun, 25 Jan 2015 10:06:00 -0800
Message-Id: <20150125180811.831859522@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 02ae7af53a451a1b0a51022c4693f5b339133e79 upstream.

Enabling bapm seems to cause clocking problems on some
KV configurations.  Disable it by default for now.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/kv_dpm.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/kv_dpm.c
+++ b/drivers/gpu/drm/radeon/kv_dpm.c
@@ -2745,13 +2745,11 @@ int kv_dpm_init(struct radeon_device *rd
 	pi->enable_auto_thermal_throttling = true;
 	pi->disable_nb_ps3_in_battery = false;
 	if (radeon_bapm == -1) {
-		/* There are stability issues reported on with
-		 * bapm enabled on an asrock system.
-		 */
-		if (rdev->pdev->subsystem_vendor == 0x1849)
-			pi->bapm_enable = false;
-		else
+		/* only enable bapm on KB, ML by default */
+		if (rdev->family == CHIP_KABINI || rdev->family == CHIP_MULLINS)
 			pi->bapm_enable = true;
+		else
+			pi->bapm_enable = false;
 	} else if (radeon_bapm == 0) {
 		pi->bapm_enable = false;
 	} else {


