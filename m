Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaD1BbD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42978 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785AbaD1B3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jani Nikula" <jani.nikula@intel.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Ville =?UTF-8?Q?Syrj=C3=A4l=C3=A4?=" <ville.syrjala@linux.intel.com>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.398044179@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 22/94] drm/i915: quirk invert brightness for Acer
 Aspire 5336
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 0f540c3a7cfb91c9d7a19eb0c95c24c5de1197d5 upstream.

Since
commit ee1452d7458451a7508e0663553ce88d63958157
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Fri Sep 20 15:05:30 2013 +0300

    drm/i915: assume all GM45 Acer laptops use inverted backlight PWM

failed and was later reverted in
commit be505f643925e257087247b996cd8ece787c12af
Author: Alexander van Heukelum <heukelum@fastmail.fm>
Date:   Sat Dec 28 21:00:39 2013 +0100

    Revert "drm/i915: assume all GM45 Acer laptops use inverted backlight PWM"

fix the individual broken machine instead.

Note to backporters:

http://patchwork.freedesktop.org/patch/17837/

is the patch you want for 3.13 and older.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=54171
Reference: http://mid.gmane.org/DUB115-W7628C7C710EA51AA110CD4A5000@phx.gbl
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
[danvet: Patch mangling for 3.14 plus adding the link to the original
for 3.13.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8949,6 +8949,9 @@ struct intel_quirk intel_quirks[] = {
 	/* Acer Aspire 4736Z */
 	{ 0x2a42, 0x1025, 0x0260, quirk_invert_brightness },
 
+	/* Acer Aspire 5336 */
+	{ 0x2a42, 0x1025, 0x048a, quirk_invert_brightness },
+
 	/* Dell XPS13 HD Sandy Bridge */
 	{ 0x0116, 0x1028, 0x052e, quirk_no_pcm_pwm_enable },
 	/* Dell XPS13 HD and XPS13 FHD Ivy Bridge */

