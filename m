Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaEZPXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:23:10 -0400
Received: from isis.lip6.fr ([132.227.60.2]:57252 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbaEZPVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:21:03 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: David Airlie <airlied@linux.ie>
Cc: benoit.taine@lip6.fr, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 13/18] drm/edid: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:22 +0200
Message-Id: <1401117687-28911-14-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Mon, 26 May 2014 17:20:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/gpu/drm/drm_edid.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 7a4fd2e..d74239f 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -3228,10 +3228,9 @@ int drm_edid_to_speaker_allocation(struct edid *edid, u8 **sadb)
 
 			/* Speaker Allocation Data Block */
 			if (dbl == 3) {
-				*sadb = kmalloc(dbl, GFP_KERNEL);
+				*sadb = kmemdup(&db[1], dbl, GFP_KERNEL);
 				if (!*sadb)
 					return -ENOMEM;
-				memcpy(*sadb, &db[1], dbl);
 				count = dbl;
 				break;
 			}

