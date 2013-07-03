Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965244Ab3GCTIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:08:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964991Ab3GCTA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:27 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=GEK23SSp30gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=bCEeunf2EiIA:10 a=taGs_qngAAAA:8 a=VwQbUJbxAAAA:8 a=hFRkqG2su3F0-HQ2DhEA:9 a=0kPLrQdw3YYA:10 a=n7Cch7CHiCMA:10 a=jeBq3FmKZ4MA:10 a=AQ2K1Fxa2HnSuDj4:21 a=vKcMYX5YTN0p0dK0:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184103.193654077@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Egbert Eich <eich@suse.de>, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [099/141] drm/i915/sdvo: Use &intel_sdvo->ddc instead of intel_sdvo->i2c for
 DDC.
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0099-drm-i915-sdvo-Use-intel_sdvo-ddc-instead-of-intel_sd.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Egbert Eich <eich@suse.de>

[ Upstream commit 53d3b4d7778daf15900867336c85d3f8dd70600c ]

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
Cc: stable@vger.kernel.org
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[danvet: Add note about which commit likely introduced this issue.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/intel_sdvo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index d554f64..95c0433 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1603,7 +1603,7 @@ static void intel_sdvo_get_lvds_modes(struct drm_connector *connector)
 	 * Assume that the preferred modes are
 	 * arranged in priority order.
 	 */
-	intel_ddc_get_modes(connector, intel_sdvo->i2c);
+	intel_ddc_get_modes(connector, &intel_sdvo->ddc);
 	if (list_empty(&connector->probed_modes) == false)
 		goto end;
 
-- 
1.7.10.4


