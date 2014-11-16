Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbaKPKVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:21:37 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:54008 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754961AbaKPKVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:21:36 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcNAG55aFRbsk2U/2dsb2JhbABbgw6BLrhMBQF1mhWBChcBAQEBAX2EMC8jgRo3iEUBwG6PQCyGPopkHYQ1BZ5MlnqBRwGCNTwwgksBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 1/1 linux-next] drm: remove unnecessary sizeof(u8)
Date: Sun, 16 Nov 2014 11:21:25 +0100
Message-Id: <1416133285-16026-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof(u8) is always 1.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/gpu/drm/r128/r128_state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/r128/r128_state.c b/drivers/gpu/drm/r128/r128_state.c
index 575e986..8fd2d9f 100644
--- a/drivers/gpu/drm/r128/r128_state.c
+++ b/drivers/gpu/drm/r128/r128_state.c
@@ -905,7 +905,7 @@ static int r128_cce_dispatch_write_span(struct drm_device *dev,
 	if (IS_ERR(buffer))
 		return PTR_ERR(buffer);
 
-	mask_size = depth->n * sizeof(u8);
+	mask_size = depth->n;
 	if (depth->mask) {
 		mask = memdup_user(depth->mask, mask_size);
 		if (IS_ERR(mask)) {
@@ -1010,7 +1010,7 @@ static int r128_cce_dispatch_write_pixels(struct drm_device *dev,
 	}
 
 	if (depth->mask) {
-		mask_size = depth->n * sizeof(u8);
+		mask_size = depth->n;
 		mask = memdup_user(depth->mask, mask_size);
 		if (IS_ERR(mask)) {
 			kfree(x);
-- 
1.9.3

