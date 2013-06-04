Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab3FDRBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:01:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab3FDRBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:01:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 30/75] drm/nouveau/bios: fix thinko in ZM_MASK_ADD opcode
Date: Tue,  4 Jun 2013 09:55:14 -0700
Message-Id: <1370364959-9475-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 46b47b8a7d9223b12ddcabf1f3fc6e753e2d84a1 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/init.c b/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
index 690ed43..ad6662c 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
@@ -1921,8 +1921,8 @@ init_zm_mask_add(struct nvbios_init *init)
 	trace("ZM_MASK_ADD\tR[0x%06x] &= 0x%08x += 0x%08x\n", addr, mask, add);
 	init->offset += 13;
 
-	data  =  init_rd32(init, addr) & mask;
-	data |= ((data + add) & ~mask);
+	data =  init_rd32(init, addr);
+	data = (data & mask) | ((data + add) & ~mask);
 	init_wr32(init, addr, data);
 }
 
-- 
1.8.1.2

