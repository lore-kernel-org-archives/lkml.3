Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3I2Tff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:35:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59833 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab3I2T3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 34/71] drm/radeon/dpm: add reclocking quirk for ASUS K70AF
Date: Sun, 29 Sep 2013 12:27:46 -0700
Message-Id: <20130929192645.834412379@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit f75195cac32bfd2ef07764bd370d3b788bd8b003 upstream.

The LCD has a relatively short vblank time (216us), but
the card is able to reclock memory fine in that time.

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Reported-by: normalrawr@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/rv770_dpm.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/rv770_dpm.c
+++ b/drivers/gpu/drm/radeon/rv770_dpm.c
@@ -2517,8 +2517,16 @@ u32 rv770_dpm_get_mclk(struct radeon_dev
 bool rv770_dpm_vblank_too_short(struct radeon_device *rdev)
 {
 	u32 vblank_time = r600_dpm_get_vblank_time(rdev);
+	u32 switch_limit = 300;
 
-	if (vblank_time < 300)
+	/* quirks */
+	/* ASUS K70AF */
+	if ((rdev->pdev->device == 0x9553) &&
+	    (rdev->pdev->subsystem_vendor == 0x1043) &&
+	    (rdev->pdev->subsystem_device == 0x1c42))
+		switch_limit = 200;
+
+	if (vblank_time < switch_limit)
 		return true;
 	else
 		return false;


