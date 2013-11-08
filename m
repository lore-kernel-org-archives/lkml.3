Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab3KHCUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:20:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34734 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab3KHCT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:19:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rob Pearce <rob@flitspace.org.uk>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 73/91] drm/i915: No LVDS hardware on Intel D410PT and D425KT
Date: Thu,  7 Nov 2013 18:15:28 -0800
Message-Id: <1383876946-2396-74-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Pearce <rob@flitspace.org.uk>

commit 645378d85ee524e429aa4cf52806047b56cdc596 upstream.

The Intel D410PT(LW) and D425KT Mini-ITX desktop boards both show up as
having LVDS but the hardware is not populated. This patch adds them to
the list of such systems. Patch is against 3.11.4

v2: Patch revised to match the D425KT exactly as the D425KTW does have
LVDS.  According to Intel's documentation, the D410PTL and D410PLTW
don't.

Signed-off-by: Rob Pearce <rob@flitspace.org.uk>
[danvet: Pimp commit message to my liking and add cc: stable.]
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index a4f9f68..db4e9e6 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -799,6 +799,22 @@ static const struct dmi_system_id intel_no_lvds[] = {
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Intel D410PT",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
+			DMI_MATCH(DMI_BOARD_NAME, "D410PT"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Intel D425KT",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "D425KT"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Intel D510MO",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Intel"),
-- 
1.8.1.2

