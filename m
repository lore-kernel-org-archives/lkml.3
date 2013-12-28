Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114Ab3L1UBN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 15:01:13 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:60956 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab3L1UBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 15:01:09 -0500
X-Sasl-enc: UI7NQ57fD1NVLOCWmnHqC8wtrTa1cUe64gwEUvbKZ4a1 1388260868
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "drm/i915: assume all GM45 Acer laptops use inverted backlight PWM"
Date: Sat, 28 Dec 2013 21:00:39 +0100
Message-Id: <1388260839-3873-2-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388260839-3873-1-git-send-email-heukelum@fastmail.fm>
References: <1388260839-3873-1-git-send-email-heukelum@fastmail.fm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Acer 8510TZ stops displaying anything when X starts with Linus' current
tree. I bisected it down to commit ee1452d74584.

This patch reverts commit ee1452d74584.

After the revert, everything works as before.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---
 drivers/gpu/drm/i915/intel_display.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 54e82a8..769b864 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -10541,11 +10541,20 @@ static struct intel_quirk intel_quirks[] = {
 	/* Sony Vaio Y cannot use SSC on LVDS */
 	{ 0x0046, 0x104d, 0x9076, quirk_ssc_force_disable },
 
-	/*
-	 * All GM45 Acer (and its brands eMachines and Packard Bell) laptops
-	 * seem to use inverted backlight PWM.
-	 */
-	{ 0x2a42, 0x1025, PCI_ANY_ID, quirk_invert_brightness },
+	/* Acer Aspire 5734Z must invert backlight brightness */
+	{ 0x2a42, 0x1025, 0x0459, quirk_invert_brightness },
+
+	/* Acer/eMachines G725 */
+	{ 0x2a42, 0x1025, 0x0210, quirk_invert_brightness },
+
+	/* Acer/eMachines e725 */
+	{ 0x2a42, 0x1025, 0x0212, quirk_invert_brightness },
+
+	/* Acer/Packard Bell NCL20 */
+	{ 0x2a42, 0x1025, 0x034b, quirk_invert_brightness },
+
+	/* Acer Aspire 4736Z */
+	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
 
 	/* Dell XPS13 HD Sandy Bridge */
 	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
-- 
1.8.3.2

