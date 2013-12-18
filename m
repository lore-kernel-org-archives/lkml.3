Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3LRWCG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:02:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab3LRVMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 45/78] drm/radeon: program DCE2 audio dto just like DCE3
Date: Wed, 18 Dec 2013 13:11:13 -0800
Message-Id: <20131218211113.174050245@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 55d4e020fb8ddd3896a8cd3351028f5c3a2c4bd3 upstream.

Seems to work like the DCE3 version despite what
the register spec says.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=71975

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r600_hdmi.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -279,9 +279,9 @@ void r600_audio_set_dto(struct drm_encod
 			WREG32(DCCG_AUDIO_DTO1_MODULE, clock * 100);
 			WREG32(DCCG_AUDIO_DTO_SELECT, 1); /* select DTO1 */
 		}
-	} else if (ASIC_IS_DCE3(rdev)) {
+	} else {
 		/* according to the reg specs, this should DCE3.2 only, but in
-		 * practice it seems to cover DCE3.0/3.1 as well.
+		 * practice it seems to cover DCE2.0/3.0/3.1 as well.
 		 */
 		if (dig->dig_encoder == 0) {
 			WREG32(DCCG_AUDIO_DTO0_PHASE, base_rate * 100);
@@ -292,10 +292,6 @@ void r600_audio_set_dto(struct drm_encod
 			WREG32(DCCG_AUDIO_DTO1_MODULE, clock * 100);
 			WREG32(DCCG_AUDIO_DTO_SELECT, 1); /* select DTO1 */
 		}
-	} else {
-		/* according to the reg specs, this should be DCE2.0 and DCE3.0/3.1 */
-		WREG32(AUDIO_DTO, AUDIO_DTO_PHASE(base_rate / 10) |
-		       AUDIO_DTO_MODULE(clock / 10));
 	}
 }
 


