Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3EJOXM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:23:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57336 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756266Ab3EJOWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:22:11 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Christian Lamparter" <chunkeey@googlemail.com>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.271792312@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [019/118] drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 9e9dd0e889c76c786e8f2e164c825c3c06dea30c upstream.

The "Mobile Sandy Bridge CPUs" in the Fujitsu Esprimo Q900
mini desktop PCs are probably misleading the LVDS detection
code in intel_lvds_supported. Nothing is connected to the
LVDS ports in these systems.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -788,6 +788,14 @@ static const struct dmi_system_id intel_
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

