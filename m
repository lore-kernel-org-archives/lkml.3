Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3AOW3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:29:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:41878 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758127Ab3AOW3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:29:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Michel=20D=C3=A4nzer?= <michel@daenzer.net>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Dave Airlie <airlied@redhat.com>
Subject: [ 078/221] drm/nouveau: fix init with agpgart-uninorth
Date: Tue, 15 Jan 2013 10:50:05 -0800
Message-Id: <20130115185003.689916674@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1279,7 +1279,7 @@ nouveau_ttm_io_mem_reserve(struct ttm_bo
 		if (drm->agp.stat == ENABLED) {
 			mem->bus.offset = mem->start << PAGE_SHIFT;
 			mem->bus.base = drm->agp.base;
-			mem->bus.is_iomem = true;
+			mem->bus.is_iomem = !dev->agp->cant_use_aperture;
 		}
 #endif
 		break;


