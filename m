Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab3KHCTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:19:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34699 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab3KHCTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:19:03 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jani Nikula <jani.nikula@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, <annndddrr@gmail.com>,
        Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 72/91] drm/i915: quirk away phantom LVDS on Intel's D525MW mainboard
Date: Thu,  7 Nov 2013 18:15:27 -0800
Message-Id: <1383876946-2396-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit dcf6d294830d46b0e6901477fb4bf455281d90c8 upstream.

This replaceable mainboard only has a VGA-out, yet it claims to also have
a connected LVDS header.

Addresses https://bugs.freedesktop.org/show_bug.cgi?id=65256

Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reported-by: Cornel Panceac <cpanceac@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <annndddrr@gmail.com>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 5cfd10e..a4f9f68 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -805,6 +805,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
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
1.8.1.2

