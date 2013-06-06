Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3FFNwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:52:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:47560 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab3FFNws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:52:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,815,1363158000"; 
   d="scan'208";a="325240177"
From: Jani Nikula <jani.nikula@intel.com>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: chris@chris-wilson.co.uk, daniel@ffwll.ch, jani.nikula@intel.com
Subject: [PATCH 2/3] drm/i915: Quirk away phantom LVDS on Intel's D510MO mainboard
Date: Thu,  6 Jun 2013 16:53:03 +0300
Message-Id: <fe363340f9b89200b4b4df70e72f0b671893be0e.1370525922.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1370525922.git.jani.nikula@intel.com>
References: <cover.1370525922.git.jani.nikula@intel.com>
In-Reply-To: <cover.1370525922.git.jani.nikula@intel.com>
References: <cover.1370525922.git.jani.nikula@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

This replaceable mainboard only has a VGA-out, yet it claims to also
have a connected LVDS header.

Reported-by: annndddrr@gmail.com
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=63860
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
[Jani: Use DMI_EXACT_MATCH for board name.]
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 10c3d56..76213e4 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -690,6 +690,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "ESPRIMO Q900"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Intel D510MO",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "D510MO"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };
-- 
1.7.9.5

