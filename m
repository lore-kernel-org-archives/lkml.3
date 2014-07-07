Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaGGSpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 14:45:46 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:61057 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbaGGSpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 14:45:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmQNAMzpulNXQCU9/2dsb2JhbABZgw6segUBAQEBAQEFAW4BkiiHRYEbF3WECwJTI4ECBxE3iC4DFQHDPQ2FfReFcIcKgigdhC0FmApsggCLTIIshhSDRTsv
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Airlie <airlied@linux.ie>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/1] drm/gma500: replace ALIGN(PAGE_SIZE) by PAGE_ALIGN
Date: Mon,  7 Jul 2014 20:44:16 +0200
Message-Id: <1404758656-8615-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use mm.h definition

Cc: David Airlie <airlied@linux.ie>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/gpu/drm/gma500/framebuffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index e7fcc14..fc1f4e8 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -369,7 +369,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
         	mode_cmd.pitches[0] =  ALIGN(mode_cmd.width * ((bpp + 7) / 8), 4096 >> pitch_lines);
 
         	size = mode_cmd.pitches[0] * mode_cmd.height;
-        	size = ALIGN(size, PAGE_SIZE);
+		size = PAGE_ALIGN(size);
 
 		/* Allocate the fb in the GTT with stolen page backing */
 		backing = psbfb_alloc(dev, size);
@@ -397,7 +397,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 		mode_cmd.pitches[0] =  ALIGN(mode_cmd.width * ((bpp + 7) / 8), 64);
 
 		size = mode_cmd.pitches[0] * mode_cmd.height;
-		size = ALIGN(size, PAGE_SIZE);
+		size = PAGE_ALIGN(size);
 
 		/* Allocate the framebuffer in the GTT with stolen page backing */
 		backing = psbfb_alloc(dev, size);
-- 
1.8.4.5

