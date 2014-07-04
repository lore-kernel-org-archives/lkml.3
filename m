Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988AbaGDTR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 15:17:26 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:37206 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759615AbaGDTRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 15:17:25 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvMMAEL9tlNbsGwr/2dsb2JhbABagw6scAUBAQEBAQEFAW4BkiiHP4ELF3WECwJTI4ECBxE3iC4DFQG1TY4qDYZSF4VwhwqCKB2ELQWYCmyCAI14hhSDRTs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/1] drm/omap: remove null test before kfree
Date: Fri,  4 Jul 2014 21:17:15 +0200
Message-Id: <1404501435-22838-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: David Airlie <airlied@linux.ie>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/gpu/drm/omapdrm/omap_gem.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
index 95dbce2..be0c2e8 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -1183,9 +1183,7 @@ int omap_gem_op_sync(struct drm_gem_object *obj, enum omap_gem_op op)
 			}
 		}
 		spin_unlock(&sync_lock);
-
-		if (waiter)
-			kfree(waiter);
+		kfree(waiter);
 	}
 	return ret;
 }
-- 
1.9.1

