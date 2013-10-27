Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3J0Nlu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:41:50 -0400
Received: from mail.ukfsn.org ([5.9.116.23]:52270 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab3J0Nls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:41:48 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Oct 2013 09:41:48 EDT
Message-ID: <526D16A2.60804@flitspace.org.uk>
Date: Sun, 27 Oct 2013 13:35:30 +0000
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
X-DSPAM-Processed: Sun Oct 27 13:35:33 2013
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 526d16a546961261017813
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Pearce <rob@flitspace.org.uk> 

These Intel D410PT and D425KT Mini-ITX desktop boards both show up as
having LVDS but the hardware is not populated. This patch adds them to
the list of such systems. Tested against 3.9.10 and 3.11.4

Signed-off-by: Rob Pearce <rob@flitspace.org.uk>
---
diff -uprN -X linux-3.9.10/Documentation/dontdiff linux-3.9.10/drivers/gpu/drm/i915/intel_lvds.c linux-3.9.10-ovs/drivers/gpu/drm/i915/intel_lvds.c
--- linux-3.9.10/drivers/gpu/drm/i915/intel_lvds.c       2013-10-22 19:00:30.000000000 +0100
+++ linux-3.9.10-ovs/drivers/gpu/drm/i915/intel_lvds.c   2013-10-22 18:58:56.000000000 +0100
@@ -843,6 +843,22 @@
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
+			DMI_MATCH(DMI_BOARD_NAME, "D425KT"),
+		},
+	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
 		.ident = "Supermicro X7SPA-H",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Supermicro"),

