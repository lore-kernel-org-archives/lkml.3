Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab3EGOSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:18:13 -0400
Received: from ip4-83-240-18-99.cust.nbox.cz ([83.240.18.99]:59325 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752679Ab3EGOSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:18:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        <stable@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 04/15] drm/cirrus: Correct register values for 16bpp
Date: Tue,  7 May 2013 16:18:12 +0200
Message-Id: <1367936303-13386-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

When the mode is set with 16bpp on QEMU, the output gets totally
broken.  The culprit is the bogus register values set for 16bpp,
which was likely copied from from a wrong place.

References: https://bugzilla.novell.com/show_bug.cgi?id=799216
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/cirrus/cirrus_mode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/cirrus/cirrus_mode.c b/drivers/gpu/drm/cirrus/cirrus_mode.c
index 60685b21..379a47e 100644
--- a/drivers/gpu/drm/cirrus/cirrus_mode.c
+++ b/drivers/gpu/drm/cirrus/cirrus_mode.c
@@ -273,8 +273,8 @@ static int cirrus_crtc_mode_set(struct drm_crtc *crtc,
 		sr07 |= 0x11;
 		break;
 	case 16:
-		sr07 |= 0xc1;
-		hdr = 0xc0;
+		sr07 |= 0x17;
+		hdr = 0xc1;
 		break;
 	case 24:
 		sr07 |= 0x15;
-- 
1.8.2.1

