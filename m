Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360Ab3EVVHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:07:21 -0400
Received: from www17.your-server.de ([213.133.104.17]:40873 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab3EVVHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:07:14 -0400
Message-ID: <1369256829.3865.435.camel@localhost.localdomain>
Subject: [PATCH] drm/i915: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: airlied@linux.ie, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Wed, 22 May 2013 23:07:09 +0200
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

diff -u -p a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -2282,11 +2282,10 @@ intel_dp_get_edid(struct drm_connector *
 			return NULL;
 
 		size = (intel_connector->edid->extensions + 1) * EDID_LENGTH;
-		edid = kmalloc(size, GFP_KERNEL);
+		edid = kmemdup(intel_connector->edid, size, GFP_KERNEL);
 		if (!edid)
 			return NULL;
 
-		memcpy(edid, intel_connector->edid, size);
 		return edid;
 	}
 


