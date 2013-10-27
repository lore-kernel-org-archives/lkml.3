Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3J0QNs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 12:13:48 -0400
Received: from mail.ukfsn.org ([5.9.116.23]:55256 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab3J0QNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 12:13:47 -0400
Message-ID: <526D3BB6.6020902@flitspace.org.uk>
Date: Sun, 27 Oct 2013 16:13:42 +0000
From: Rob Pearce <rob@flitspace.org.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131014 Thunderbird/17.0.9
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>
CC: David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] INTEL DRM DRIVERS : No LVDS hardware on Intel D410PT and
 D425KT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun Oct 27 16:13:44 2013
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 526d3bb846961641145564
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Pearce <rob@flitspace.org.uk>

The Intel D410PT(LW) and D425KT Mini-ITX desktop boards both show up as
having LVDS but the hardware is not populated. This patch adds them to
the list of such systems. Patch is against 3.11.4

Signed-off-by: Rob Pearce <rob@flitspace.org.uk>
---
Patch revised to match the D425KT exactly as the D425KTW does have LVDS. 
According to Intel's documentation, the D410PTL and D410PLTW don't.


diff -uprN -X linux-3.11.4/Documentation/dontdiff linux-3.11.4/drivers/gpu/drm/i915/intel_lvds.c linux-3.11.4-ovs/drivers/gpu/drm/i915/intel_lvds.c
--- linux-3.11.4/drivers/gpu/drm/i915/intel_lvds.c       2013-10-22 19:00:30.000000000 +0100
+++ linux-3.11.4-ovs/drivers/gpu/drm/i915/intel_lvds.c   2013-10-27 15:51:25.000000000 +0000
@@ -696,6 +696,22 @@
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
 			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),

