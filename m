Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab3FRLoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:44:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56083 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab3FRLoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:37 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Egbert Eich <eich@suse.de>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 43/93] drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for DDC.
Date: Tue, 18 Jun 2013 12:42:51 +0100
Message-Id: <1371555821-12820-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/intel_sdvo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 1af5db5..63b53d2 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1595,7 +1595,7 @@ static void intel_sdvo_get_lvds_modes(struct drm_connector *connector)
 	 * Assume that the preferred modes are
 	 * arranged in priority order.
 	 */
-	intel_ddc_get_modes(connector, intel_sdvo->i2c);
+	intel_ddc_get_modes(connector, &intel_sdvo->ddc);
 	if (list_empty(&connector->probed_modes) == false)
 		goto end;
 
-- 
1.8.1.2

