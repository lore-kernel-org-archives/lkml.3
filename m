Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaJKMv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 08:51:26 -0400
Received: from wp038.webpack.hosteurope.de ([80.237.132.45]:45796 "EHLO
	wp038.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070AbaJKMvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 08:51:25 -0400
X-Greylist: delayed 788 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Oct 2014 08:51:25 EDT
From: Henning Schild <henning@hennsch.de>
To: linux-kernel@vger.kernel.org
Cc: Henning Schild <henning@hennsch.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] drm/radeon: remove code that can never get executed
Date: Sat, 11 Oct 2014 14:51:15 +0200
Message-Id: <1413031875-28053-1-git-send-email-henning@hennsch.de>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1413031067-26961-1-git-send-email-henning@hennsch.de>
References: <1413031067-26961-1-git-send-email-henning@hennsch.de>
X-bounce-key: webpack.hosteurope.de;henning@hennsch.de;1413031885;38d7e403;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing a code-path that can never be executed ... and its copies. If
drm_edid_to_speaker_allocation returns 0 the callers return. There is no
need to check that condition again.

Signed-off-by: Henning Schild <henning@hennsch.de>
---
 drivers/gpu/drm/radeon/dce3_1_afmt.c    | 5 +----
 drivers/gpu/drm/radeon/dce6_afmt.c      | 5 +----
 drivers/gpu/drm/radeon/evergreen_hdmi.c | 5 +----
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/radeon/dce3_1_afmt.c b/drivers/gpu/drm/radeon/dce3_1_afmt.c
index cb76074..6d31ed8 100644
--- a/drivers/gpu/drm/radeon/dce3_1_afmt.c
+++ b/drivers/gpu/drm/radeon/dce3_1_afmt.c
@@ -58,10 +58,7 @@ static void dce3_2_afmt_write_speaker_allocation(struct drm_encoder *encoder)
 	tmp &= ~(DP_CONNECTION | SPEAKER_ALLOCATION_MASK);
 	/* set HDMI mode */
 	tmp |= HDMI_CONNECTION;
-	if (sad_count)
-		tmp |= SPEAKER_ALLOCATION(sadb[0]);
-	else
-		tmp |= SPEAKER_ALLOCATION(5); /* stereo */
+	tmp |= SPEAKER_ALLOCATION(sadb[0]);
 	WREG32(AZ_F0_CODEC_PIN0_CONTROL_CHANNEL_SPEAKER, tmp);
 
 	kfree(sadb);
diff --git a/drivers/gpu/drm/radeon/dce6_afmt.c b/drivers/gpu/drm/radeon/dce6_afmt.c
index ab29f95..e6b2750 100644
--- a/drivers/gpu/drm/radeon/dce6_afmt.c
+++ b/drivers/gpu/drm/radeon/dce6_afmt.c
@@ -186,10 +186,7 @@ void dce6_afmt_write_speaker_allocation(struct drm_encoder *encoder)
 	tmp &= ~(DP_CONNECTION | SPEAKER_ALLOCATION_MASK);
 	/* set HDMI mode */
 	tmp |= HDMI_CONNECTION;
-	if (sad_count)
-		tmp |= SPEAKER_ALLOCATION(sadb[0]);
-	else
-		tmp |= SPEAKER_ALLOCATION(5); /* stereo */
+	tmp |= SPEAKER_ALLOCATION(sadb[0]);
 	WREG32_ENDPOINT(offset, AZ_F0_CODEC_PIN_CONTROL_CHANNEL_SPEAKER, tmp);
 
 	kfree(sadb);
diff --git a/drivers/gpu/drm/radeon/evergreen_hdmi.c b/drivers/gpu/drm/radeon/evergreen_hdmi.c
index 278c7a1..11a6b65 100644
--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -128,10 +128,7 @@ static void dce4_afmt_write_speaker_allocation(struct drm_encoder *encoder)
 	tmp &= ~(DP_CONNECTION | SPEAKER_ALLOCATION_MASK);
 	/* set HDMI mode */
 	tmp |= HDMI_CONNECTION;
-	if (sad_count)
-		tmp |= SPEAKER_ALLOCATION(sadb[0]);
-	else
-		tmp |= SPEAKER_ALLOCATION(5); /* stereo */
+	tmp |= SPEAKER_ALLOCATION(sadb[0]);
 	WREG32(AZ_F0_CODEC_PIN0_CONTROL_CHANNEL_SPEAKER, tmp);
 
 	kfree(sadb);
-- 
2.0.4

