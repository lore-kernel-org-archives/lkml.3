Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab3AMRpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:45:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35152 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755658Ab3AMRps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:48 -0500
Message-Id: <20130113174300.648063303@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:18 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 23/49] drm/nouveau: fix init with agpgart-uninorth
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit eda85d6ad490923152544fba0473798b6cc0edf6 upstream.

Check that the AGP aperture can be mapped. This follows a similar change
done for Radeon (commit 365048ff, drm/radeon: AGP memory is only I/O if
the aperture can be mapped by the CPU.).

The patch fixes the following error seen on G5 iMac:

	nouveau E[     DRM] failed to create kernel channel, -12

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=58806
Reviewed-by: Michel Dänzer <michel@daenzer.net>
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -940,7 +940,7 @@ nouveau_ttm_io_mem_reserve(struct ttm_bo
 		if (dev_priv->gart_info.type == NOUVEAU_GART_AGP) {
 			mem->bus.offset = mem->start << PAGE_SHIFT;
 			mem->bus.base = dev_priv->gart_info.aper_base;
-			mem->bus.is_iomem = true;
+			mem->bus.is_iomem = !dev->agp->cant_use_aperture;
 		}
 #endif
 		break;


