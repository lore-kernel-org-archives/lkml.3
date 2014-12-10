Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaLJPuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:50:04 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8794 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066AbaLJPtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:49:21 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-be-54886b7f4456
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/CLKDEV SUPPORT),
        linux-gpio@vger.kernel.org (open list:GPIO SUBSYSTEM),
        dri-devel@lists.freedesktop.org (open list:DRM PANEL DRIVERS),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        boris.brezillon@free-electrons.com
Subject: [RFC 14/15] drm/panel/ld9040: do not power off panel on removal
Date: Wed, 10 Dec 2014 16:48:32 +0100
Message-id: <1418226513-14105-15-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xy7r12R0hBocecVvcWneO1eLAi4Us
	FlMfPmGzmH8EyL3y9T2bxblXj1gsDvzZwWjRvHg9m8Wk+xNYLC487WGz+Halg8liyp/lTBab
	Hl9jtdg8/w+jxeVdc9gsZpzfx2Rx+zKvxdojd9ktnk64yGbRuvcIu8XPXfNYHEQ9Wpp72Dye
	bLrI6LFz1l12j02rOtk87lzbw+axf+4ado/73ceZPDYvqffo27KK0eP4je1MHp83yQVwR3HZ
	pKTmZJalFunbJXBlnL3zn63gJ0vFvykXWRoYZ7J0MXJySAiYSKxYs5QNwhaTuHBvPZDNxSEk
	sJRRYv/yLmYIp49JYsrZvYwgVWwCmhJ/N98E6xAR0JG43tMNVsQssIFdYt30fWAJYQEPidn7
	ToHZLAKqEmt/vgeyOTh4BVwken+4QWyTkzh5bDIriM0JFP77HGK+kICzxJJt71knMPIuYGRY
	xSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESG193MC49ZnWIUYCDUYmHd4diW4gQa2JZcWXu
	IUYJDmYlEd6FyR0hQrwpiZVVqUX58UWlOanFhxiZODilGhjV/klMnOPy4NvLp10Tq0Xr2jdJ
	fkj58E62LzC4d+o67/KoigPmPidPKBuf/nUgWk0yW2+py7wzOvLxU/bqrJ/z55dE5zXBEyEi
	B+8oLPU/fHni109Z7vfmsDx4KnvR8HWJm1f76T+qejNU1t1Ofd4x2y649u+B5/uFf60LTIw/
	fvJD6/G7iswKSizFGYmGWsxFxYkArelwPmsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Panel is powered off already by connector during drm_panel_remove call.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/gpu/drm/panel/panel-ld9040.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-ld9040.c b/drivers/gpu/drm/panel/panel-ld9040.c
index 08cf2c5..3337f30 100644
--- a/drivers/gpu/drm/panel/panel-ld9040.c
+++ b/drivers/gpu/drm/panel/panel-ld9040.c
@@ -361,7 +361,6 @@ static int ld9040_remove(struct spi_device *spi)
 {
 	struct ld9040 *ctx = spi_get_drvdata(spi);
 
-	ld9040_power_off(ctx);
 	drm_panel_remove(&ctx->panel);
 
 	return 0;
-- 
1.9.1

