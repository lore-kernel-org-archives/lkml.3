Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab3EVM6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 08:58:42 -0400
Received: from ip4-83-240-18-99.cust.nbox.cz ([83.240.18.99]:50078 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754087Ab3EVM6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 08:58:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, <stable@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH -resend 3/6] drm/cirrus: Correct register values for 16bpp
Date: Wed, 22 May 2013 14:59:09 +0200
Message-Id: <1369227552-11743-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2.3
In-Reply-To: <1369227552-11743-1-git-send-email-jslaby@suse.cz>
References: <1369227552-11743-1-git-send-email-jslaby@suse.cz>
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
index 60685b2..379a47e 100644
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
1.8.2.3

