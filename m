Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136Ab3K0Bla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:41:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab3K0A6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Pearce <rob@flitspace.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.10 80/80] drm/i915: No LVDS hardware on Intel D410PT and D425KT
Date: Tue, 26 Nov 2013 16:57:49 -0800
Message-Id: <20131127005646.464129317@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -871,6 +871,22 @@ static const struct dmi_system_id intel_
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


