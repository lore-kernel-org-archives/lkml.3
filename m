Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab3ERDNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:13:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8107 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687Ab3ERDAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:16 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=mS9-5_p_Mw0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=RQrulOtUxXoA:10 a=mK_AVkanAAAA:8 a=VwQbUJbxAAAA:8 a=bjMPATZ-EPx3wx6zAHQA:9 a=9xyTavCNlvEA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021659.507053375@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 111/136 ] drm/i915: Add no-lvds quirk for Fujitsu Esprimo Q900
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0111-drm-i915-Add-no-lvds-quirk-for-Fujitsu-Esprimo-Q900.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

[ Upstream commit 9e9dd0e889c76c786e8f2e164c825c3c06dea30c ]

The "Mobile Sandy Bridge CPUs" in the Fujitsu Esprimo Q900
mini desktop PCs are probably misleading the LVDS detection
code in intel_lvds_supported. Nothing is connected to the
LVDS ports in these systems.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/intel_lvds.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 0c52448..c78c988 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -796,6 +796,14 @@ static const struct dmi_system_id intel_no_lvds[] = {
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
-- 
1.7.10.4


