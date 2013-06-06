Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3FFNx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 09:53:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:10375 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab3FFNx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:53:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,815,1363158000"; 
   d="scan'208";a="251495020"
From: Jani Nikula <jani.nikula@intel.com>
To: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: chris@chris-wilson.co.uk, daniel@ffwll.ch, jani.nikula@intel.com
Subject: [PATCH 3/3] drm/i915: Quirk away phantom LVDS on Intel's D525MW mainboard
Date: Thu,  6 Jun 2013 16:53:04 +0300
Message-Id: <849174cf874274b488a7a9318b4712c12f64a8e1.1370525922.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1370525922.git.jani.nikula@intel.com>
References: <cover.1370525922.git.jani.nikula@intel.com>
In-Reply-To: <cover.1370525922.git.jani.nikula@intel.com>
References: <cover.1370525922.git.jani.nikula@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaceable mainboard only has a VGA-out, yet it claims to also
have a connected LVDS header.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=65256
Reported-by: Cornel Panceac <cpanceac@gmail.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 76213e4..607c06e 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -698,6 +698,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
 			DMI_EXACT_MATCH(DMI_BOARD_NAME, "D510MO"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Intel D525MW",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "D525MW"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };
-- 
1.7.9.5

