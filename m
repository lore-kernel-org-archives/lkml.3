Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841Ab3KIG6L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:58:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758611Ab3KIGwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:52:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Pearce <rob@flitspace.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.11 87/94] drm/i915: No LVDS hardware on Intel D410PT and D425KT
Date: Fri,  8 Nov 2013 22:52:33 -0800
Message-Id: <20131109065210.399516993@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_lvds.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -696,6 +696,22 @@ static const struct dmi_system_id intel_
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


