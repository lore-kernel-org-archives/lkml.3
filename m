Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab3EVVGl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:06:41 -0400
Received: from www17.your-server.de ([213.133.104.17]:40728 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912Ab3EVVGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:06:40 -0400
Message-ID: <1369256790.3865.434.camel@localhost.localdomain>
Subject: [PATCH] drm: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Wed, 22 May 2013 23:06:30 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/gpu/drm/drm_edid_load.c b/drivers/gpu/drm/drm_edid_load.c
--- a/drivers/gpu/drm/drm_edid_load.c
+++ b/drivers/gpu/drm/drm_edid_load.c
@@ -186,12 +186,11 @@ static u8 *edid_load(struct drm_connecto
 		goto relfw_out;
 	}
 
-	edid = kmalloc(fwsize, GFP_KERNEL);
+	edid = kmemdup(fwdata, fwsize, GFP_KERNEL);
 	if (edid == NULL) {
 		err = -ENOMEM;
 		goto relfw_out;
 	}
-	memcpy(edid, fwdata, fwsize);
 
 	if (!drm_edid_block_valid(edid, 0, print_bad_edid)) {
 		connector->bad_edid_counter++;


