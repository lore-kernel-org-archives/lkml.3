Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965159Ab3GCTJk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:09:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964988Ab3GCTA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:26 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=EtA9CSJ6-6MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=npMAx7FhKIMA:10 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=IkMwAnDzBfMkziLOFYUA:9 a=FJ74pD1--X4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184103.366829887@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ben Mesman <ben@bnc.nl>, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [100/141] drm/i915: no lvds quirk for hp t5740
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0100-drm-i915-no-lvds-quirk-for-hp-t5740.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ben Mesman <ben@bnc.nl>

[ Upstream commit 45a211d75137b1ac869a8a758a6667f15827a115 ]

Last year, a patch was made for the "HP t5740e Thin Client" (see
http://lists.freedesktop.org/archives/dri-devel/2012-May/023245.html).
This device reports an lvds panel, but does not really have one.

The predecessor of this device is the "hp t5740", which also does not have
an lvds panel. This patch will add the same quirk for this device.

Signed-off-by: Ben Mesman <ben@bnc.nl>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/i915/intel_lvds.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index c78c988..32b6b78 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -742,10 +742,10 @@ static const struct dmi_system_id intel_no_lvds[] = {
 	},
 	{
 		.callback = intel_no_lvds_dmi_callback,
-		.ident = "Hewlett-Packard HP t5740e Thin Client",
+		.ident = "Hewlett-Packard HP t5740",
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP t5740e Thin Client"),
+			DMI_MATCH(DMI_PRODUCT_NAME, " t5740"),
 		},
 	},
 	{
-- 
1.7.10.4


