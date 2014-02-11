Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbaBKTY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:24:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbaBKTII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        David Airlie <airlied@linux.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.10 63/79] drm/cirrus: correct register values for 16bpp
Date: Tue, 11 Feb 2014 11:06:07 -0800
Message-Id: <20140211184722.791875228@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/cirrus/cirrus_mode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/cirrus/cirrus_mode.c
+++ b/drivers/gpu/drm/cirrus/cirrus_mode.c
@@ -273,8 +273,8 @@ static int cirrus_crtc_mode_set(struct d
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


