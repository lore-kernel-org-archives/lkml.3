Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3FPWZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:25:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46363 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755637Ab3FPWIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:08:55 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ben Mesman" <ben@bnc.nl>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.847977093@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [50/83] drm/i915: no lvds quirk for hp t5740
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Mesman <ben@bnc.nl>

commit 45a211d75137b1ac869a8a758a6667f15827a115 upstream.

Last year, a patch was made for the "HP t5740e Thin Client" (see
http://lists.freedesktop.org/archives/dri-devel/2012-May/023245.html).
This device reports an lvds panel, but does not really have one.

The predecessor of this device is the "hp t5740", which also does not have
an lvds panel. This patch will add the same quirk for this device.

Signed-off-by: Ben Mesman <ben@bnc.nl>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_lvds.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -740,10 +740,10 @@ static const struct dmi_system_id intel_
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

