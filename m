Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3FPW2N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:28:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46410 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755664Ab3FPWIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Egbert Eich" <eich@suse.de>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.870093511@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [55/83] drm/i915/sdvo: Use &intel_sdvo->ddc instead of
 intel_sdvo->i2c for DDC.
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_sdvo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1582,7 +1582,7 @@ static void intel_sdvo_get_lvds_modes(st
 	 * Assume that the preferred modes are
 	 * arranged in priority order.
 	 */
-	intel_ddc_get_modes(connector, intel_sdvo->i2c);
+	intel_ddc_get_modes(connector, &intel_sdvo->ddc);
 	if (list_empty(&connector->probed_modes) == false)
 		goto end;
 

