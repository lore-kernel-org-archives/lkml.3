Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3FQRsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:48:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50648 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab3FQRfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:35:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Egbert Eich <eich@suse.de>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 47/84] drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC.
Date: Mon, 17 Jun 2013 10:30:51 -0700
Message-Id: <1371490288-23167-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Egbert Eich <eich@suse.de>

commit 53d3b4d7778daf15900867336c85d3f8dd70600c upstream.

In intel_sdvo_get_lvds_modes() the wrong i2c adapter record is used
for DDC. Thus the code will always have to rely on a LVDS panel
mode supplied by VBT.
In most cases this succeeds, so this didn't get detected for quite
a while.

This regression seems to have been introduced in

commit f899fc64cda8569d0529452aafc0da31c042df2e
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Tue Jul 20 15:44:45 2010 -0700

    drm/i915: use GMBUS to manage i2c links

Signed-off-by: Egbert Eich <eich@suse.de>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
[danvet: Add note about which commit likely introduced this issue.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_sdvo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 506c331..601dc05 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1745,7 +1745,7 @@ static void intel_sdvo_get_lvds_modes(struct drm_connector *connector)
 	 * Assume that the preferred modes are
 	 * arranged in priority order.
 	 */
-	intel_ddc_get_modes(connector, intel_sdvo->i2c);
+	intel_ddc_get_modes(connector, &intel_sdvo->ddc);
 	if (list_empty(&connector->probed_modes) == false)
 		goto end;
 
-- 
1.8.1.2

