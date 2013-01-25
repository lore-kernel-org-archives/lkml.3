Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab3AYQV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 11:21:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab3AYQV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 11:21:57 -0500
From: Takashi Iwai <tiwai@suse.de>
To: David Airlie <airlied@linux.ie>
Cc: Stefan Dirsch <sndirsch@suse.de>, Bernhard Wiedemann <bwiedemann@suse.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drm/cirrus: Correct register values for 16bpp
Date: Fri, 25 Jan 2013 17:21:54 +0100
Message-Id: <1359130915-30082-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the mode is set with 16bpp on QEMU, the output gets totally
broken.  The culprit is the bogus register values set for 16bpp,
which was likely copied from from a wrong place.

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=799216

Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
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
1.8.1.1

