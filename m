Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaFEEgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:36:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbaFEEVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Dave Airlie <airlied@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 164/214] drm/nouveau: fix init with agpgart-uninorth
Date: Wed,  4 Jun 2014 21:18:47 -0700
Message-Id: <20140605041701.581732626@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -946,7 +946,7 @@ nouveau_ttm_io_mem_reserve(struct ttm_bo
 		if (dev_priv->gart_info.type == NOUVEAU_GART_AGP) {
 			mem->bus.offset = mem->start << PAGE_SHIFT;
 			mem->bus.base = dev_priv->gart_info.aper_base;
-			mem->bus.is_iomem = true;
+			mem->bus.is_iomem = !dev->agp->cant_use_aperture;
 		}
 #endif
 		break;


