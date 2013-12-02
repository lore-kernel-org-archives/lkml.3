Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3LBTOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:14:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3LBTOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.10 166/173] drm/radeon: use hw generated CTS/N values for audio
Date: Mon,  2 Dec 2013 11:12:29 -0800
Message-Id: <20131202191202.144278608@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit ee0fec312a1c4e26f255955da942562cd8908a4b upstream.

Use the hw generated values rather than calculating
them in the driver.  There may be some older r6xx
asics where this doesn't work correctly.  This remains
to be seen.

See bug:
https://bugs.freedesktop.org/show_bug.cgi?id=69675

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/evergreen_hdmi.c |    3 +--
 drivers/gpu/drm/radeon/r600_hdmi.c      |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/evergreen_hdmi.c
+++ b/drivers/gpu/drm/radeon/evergreen_hdmi.c
@@ -219,8 +219,7 @@ void evergreen_hdmi_setmode(struct drm_e
 	/* fglrx clears sth in AFMT_AUDIO_PACKET_CONTROL2 here */
 
 	WREG32(HDMI_ACR_PACKET_CONTROL + offset,
-	       HDMI_ACR_AUTO_SEND | /* allow hw to sent ACR packets when required */
-	       HDMI_ACR_SOURCE); /* select SW CTS value */
+	       HDMI_ACR_AUTO_SEND); /* allow hw to sent ACR packets when required */
 
 	evergreen_hdmi_update_ACR(encoder, mode->clock);
 
--- a/drivers/gpu/drm/radeon/r600_hdmi.c
+++ b/drivers/gpu/drm/radeon/r600_hdmi.c
@@ -320,8 +320,7 @@ void r600_hdmi_setmode(struct drm_encode
 	}
 
 	WREG32(HDMI0_ACR_PACKET_CONTROL + offset,
-	       HDMI0_ACR_AUTO_SEND | /* allow hw to sent ACR packets when required */
-	       HDMI0_ACR_SOURCE); /* select SW CTS value */
+	       HDMI0_ACR_AUTO_SEND); /* allow hw to sent ACR packets when required */
 
 	WREG32(HDMI0_VBI_PACKET_CONTROL + offset,
 	       HDMI0_NULL_SEND | /* send null packets when required */


