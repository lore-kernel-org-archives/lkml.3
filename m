Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaBJUMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:12:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34700 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbaBJTnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:43:33 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        David Airlie <airlied@linux.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 085/124] drm/cirrus: correct register values for 16bpp
Date: Mon, 10 Feb 2014 11:40:25 -0800
Message-Id: <1392061264-28124-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 2510538fa000dd13a3e57b79bf073ffb1748976c upstream.

When the mode is set with 16bpp on QEMU, the output gets totally broken.
The culprit is the bogus register values set for 16bpp, which was likely
copied from from a wrong place.

Addresses https://bugzilla.novell.com/show_bug.cgi?id=799216

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.8.3.2

