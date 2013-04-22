Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3DVO37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:29:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51507 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754790Ab3DVO35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jani Nikula" <jani.nikula@intel.com>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Carsten Emde" <C.Emde@osadl.org>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.245288113@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [58/75] drm/i915: panel: invert brightness acer aspire 5734z
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Carsten Emde <C.Emde@osadl.org>

commit 5a15ab5b93e4a3ebcd4fa6c76cf646a45e9cf806 upstream.

Mark the Acer Aspire 5734Z that this machines requires the module to
invert the panel backlight brightness value after reading from and prior
to writing to the PCI configuration space.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8832,7 +8832,8 @@ static void quirk_ssc_force_disable(stru
 }
 
 /*
- * A machine may need to invert the panel backlight brightness value
+ * A machine (e.g. Acer Aspire 5734Z) may need to invert the panel backlight
+ * brightness value
  */
 static void quirk_invert_brightness(struct drm_device *dev)
 {
@@ -8874,6 +8875,9 @@ struct intel_quirk intel_quirks[] = {
 
 	/* Sony Vaio Y cannot use SSC on LVDS */
 	{ 0x0046, 0x104d, 0x9076, quirk_ssc_force_disable },
+
+	/* Acer Aspire 5734Z must invert backlight brightness */
+	{ 0x2a42, 0x1025, 0x0459, quirk_invert_brightness },
 };
 
 static void intel_init_quirks(struct drm_device *dev)

