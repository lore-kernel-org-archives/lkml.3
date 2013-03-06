Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab3CFK4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:56:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35015 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237Ab3CFK4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:56:48 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-23-513720ef1a70
From: Thomas Abraham <thomas.abraham@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linus.walleij@linaro.org, kgene.kim@samsung.com, t.figa@samsung.com,
        patches@linaro.org
Subject: [PATCH v2 3/3] arm: exynos: skip wakeup interrupt registration for
 exynos5250 if pinctrl is enabled
Date: Wed, 06 Mar 2013 16:48:32 +0530
Message-id: <1362568712-13586-4-git-send-email-thomas.abraham@linaro.org>
X-Mailer: git-send-email 1.6.6.rc2
In-reply-to: <1362568712-13586-1-git-send-email-thomas.abraham@linaro.org>
References: <1362568712-13586-1-git-send-email-thomas.abraham@linaro.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xoO57BfNAg7Zvyha9C66yWUz5s5zJ
	YtPja6wWl3fNYbOYcX4fk8WUw19YLNbPeM3iwO5x59oeNo/NS+o9+rasYvT4vEkugCWKyyYl
	NSezLLVI3y6BK+Nm+2LWgn3sFTsmXGBvYNzI1sXIySEhYCJx6vo5RghbTOLCvfVAcS4OIYHp
	jBL/pnUxQThtTBJrNjWzgFSxCRhIPFr4jh3EFhFQkNjc+4wVpIhZYAWjxImur2AJYYE8iWWr
	poE1sAioSrx6cx1sHa+Ap8TOG3egVitJbOg9CrSBg4NTwEvi43UjkLAQUMnD+U8ZJzDyLmBk
	WMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHErPpHYwrmywOMQowMGoxMNroWQWKMSaWFZc
	mXuIUYKDWUmEd6u0eaAQb0piZVVqUX58UWlOavEhRmkOFiVxXsZTTwKEBNITS1KzU1MLUotg
	skwcnFINjH0/1kddPRLi8dRpVmNziOfr9pU6z0NzPzLOYTyprfMkarV01qG69aKi29NvZAuu
	6zfePDF7397rBrxf0zmTNDdvVmM/F7z7L2P3R4b8KSrSpdKJ/Qe9fP1Ff7/n4zsrsrRAYGKR
	/iHRVYVVv+b2xWTtXzNHT+7t4/i6aKWyozaFqeETXmYVKrEUZyQaajEXFScCALJeKL8hAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip the wakeup interrupt registration for Exynos5250 if pinctrl support
is enabled for Exynos5250.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-exynos/common.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
index d63d399..bdd9579 100644
--- a/arch/arm/mach-exynos/common.c
+++ b/arch/arm/mach-exynos/common.c
@@ -822,6 +822,7 @@ static int __init exynos_init_irq_eint(void)
 	static const struct of_device_id exynos_pinctrl_ids[] = {
 		{ .compatible = "samsung,exynos4210-pinctrl", },
 		{ .compatible = "samsung,exynos4x12-pinctrl", },
+		{ .compatible = "samsung,exynos5250-pinctrl", },
 	};
 	struct device_node *pctrl_np, *wkup_np;
 	const char *wkup_compat = "samsung,exynos4210-wakeup-eint";
-- 
1.6.6.rc2

