Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab3EIWfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:35:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758425Ab3EIWew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:34:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 12/26] drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900
Date: Thu,  9 May 2013 15:34:26 -0700
Message-Id: <20130509223423.705659913@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509223422.368544659@linuxfoundation.org>
References: <20130509223422.368544659@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 9e9dd0e889c76c786e8f2e164c825c3c06dea30c upstream.

The "Mobile Sandy Bridge CPUs" in the Fujitsu Esprimo Q900
mini desktop PCs are probably misleading the LVDS detection
code in intel_lvds_supported. Nothing is connected to the
LVDS ports in these systems.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -793,6 +793,14 @@ static const struct dmi_system_id intel_
 			DMI_MATCH(DMI_PRODUCT_NAME, "X7SPA-H"),
 		},
 	},
+	{
+		.callback = intel_no_lvds_dmi_callback,
+		.ident = "Fujitsu Esprimo Q900",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ESPRIMO Q900"),
+		},
+	},
 
 	{ }	/* terminating entry */
 };


