Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab3FQRrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:47:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50659 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab3FQRft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:35:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Mesman <ben@bnc.nl>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 43/84] drm/i915: no lvds quirk for hp t5740
Date: Mon, 17 Jun 2013 10:30:47 -0700
Message-Id: <1371490288-23167-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/intel_lvds.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
index 8b383a6..2f0364d 100644
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -743,10 +743,10 @@ static const struct dmi_system_id intel_no_lvds[] = {
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
1.8.1.2

