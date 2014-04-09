Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924AbaDITg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 15:36:28 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:55493 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbaDITg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 15:36:27 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Andreas Noever <andreas.noever@gmail.com>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, Martin Peres <martin.peres@free.fr>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/nouveau/bios: fix bug introduced in 457e77b2
Date: Wed,  9 Apr 2014 21:33:30 +0200
Message-Id: <1397072012-9475-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

457e77b2 effectively replaces (... & 0xffffff00) << 8 with (... >> 8) << 8.
Which does not do the same and breaks boot on my machine.

Restore the old behaviour and remove the unnecessary cast.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
index e9df94f..2885b7c 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
@@ -109,7 +109,7 @@ nouveau_bios_shadow_pramin(struct nouveau_bios *bios)
 			return;
 		}
 
-		addr = (u64)(addr >> 8) << 8;
+		addr = (addr >> 8) << 16;
 		if (!addr) {
 			addr  = (u64)nv_rd32(bios, 0x001700) << 16;
 			addr += 0xf0000;
-- 
1.9.1

