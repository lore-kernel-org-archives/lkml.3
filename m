Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbaGHBJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 21:09:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaGGXxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 19:53:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>, Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.15 046/122] drm/i915: default to having backlight if VBT not available
Date: Mon,  7 Jul 2014 16:56:48 -0700
Message-Id: <20140707235735.673233960@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235734.234226883@linuxfoundation.org>
References: <20140707235734.234226883@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 56c4b63aaf4c2cd91966b2a5e69e5367bea60bbe upstream.

Apparently there are Apple laptops with magic smoke for a VBIOS, which
we fail to find and use. Default to having and setting up backlight in
this case.

This fixes a regression introduced by
commit c675949ec58ca50d5a3ae3c757892f1560f6e896
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Wed Apr 9 11:31:37 2014 +0300

    drm/i915: do not setup backlight if not available according to VBT

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=77831
Reported-and-tested-by: Matteo Cypriani <mcy@lm7.fr>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_bios.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -287,9 +287,6 @@ parse_lfp_backlight(struct drm_i915_priv
 	const struct bdb_lfp_backlight_data *backlight_data;
 	const struct bdb_lfp_backlight_data_entry *entry;
 
-	/* Err to enabling backlight if no backlight block. */
-	dev_priv->vbt.backlight.present = true;
-
 	backlight_data = find_section(bdb, BDB_LVDS_BACKLIGHT);
 	if (!backlight_data)
 		return;
@@ -839,6 +836,9 @@ init_vbt_defaults(struct drm_i915_privat
 
 	dev_priv->vbt.crt_ddc_pin = GMBUS_PORT_VGADDC;
 
+	/* Default to having backlight */
+	dev_priv->vbt.backlight.present = true;
+
 	/* LFP panel data */
 	dev_priv->vbt.lvds_dither = 1;
 	dev_priv->vbt.lvds_vbt = 0;


