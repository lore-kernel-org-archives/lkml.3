Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422690AbaD3OEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:04:11 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53179 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933754AbaD3ODt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:03:49 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-d6-536102c4b4ff
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Tomasz Stansislawski <t.stanislaws@samsung.com>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/S5P EXYNOS
	AR...),
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: [RFC PATCH 4/4] drm/panel/ld9040: do not power off panel on removal
Date: Wed, 30 Apr 2014 16:02:54 +0200
Message-id: <1398866574-27001-5-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1398866574-27001-1-git-send-email-a.hajda@samsung.com>
References: <1398866574-27001-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xy7pHmBKDDd68l7S4te4cq0XvuZNM
	Fn8nHWO3uPL1PZtF8+L1bBaT7k9gsTjb9IbdYtPja6wWl3fNYbPo2bCV1WLG+X1MFrcv81qs
	PXKX3WL9jNcsFvPaX7Ja/Nw1j8VBwKOluYfN4/evSYweO2fdZffY/u0Bq8f+uWvYPe53H2fy
	2Lyk3qNvyypGj8+b5AI4o7hsUlJzMstSi/TtErgy3pxaw17wm6Xi97an7A2Ms1m6GDk5JARM
	JA7PaIeyxSQu3FvP1sXIxSEksJRRYsnlN+wQTh+TRNvmPWBVbAKaEn8332QDsUUEdCSu93Qz
	gxQxC6xmlTjweRIzSEJYwEdiwvt7YA0sAqoSE/f3gzXwCjhL3Nm7kQlinYLEsi9rweo5BVwk
	Wn7uA6sRAqqZMXER0wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQsL6yw7Gxces
	DjEKcDAq8fAKbI0PFmJNLCuuzD3EKMHBrCTCe/RfQrAQb0piZVVqUX58UWlOavEhRiYOTqkG
	Rj/D0qfuBVwH3AXm37y6b+7ndTa+rycIvWt83ahXo331wyLdhjzWQDdHpldbsz+d9uz519Ao
	mfn46MTXLXZ351pZimiuK3zCtTCjP+Pv/hucHU8eVL5pFqr+qLhyvrTaBEelc1Y7fkwKn7Yv
	w3Fvk47ybVWRzRPYNR3jm6UeHg62MX37z+yVjhJLcUaioRZzUXEiAJ78X0pJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Panel is powered off already by connector during drm_panel_remove call.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/panel/panel-ld9040.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-ld9040.c b/drivers/gpu/drm/panel/panel-ld9040.c
index 1f1f837..1def4b0 100644
--- a/drivers/gpu/drm/panel/panel-ld9040.c
+++ b/drivers/gpu/drm/panel/panel-ld9040.c
@@ -348,7 +348,6 @@ static int ld9040_remove(struct spi_device *spi)
 {
 	struct ld9040 *ctx = spi_get_drvdata(spi);
 
-	ld9040_power_off(ctx);
 	drm_panel_remove(&ctx->panel);
 
 	return 0;
-- 
1.8.3.2

