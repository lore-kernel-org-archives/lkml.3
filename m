Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3IWVpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:45:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47481 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3IWVmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:42:38 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Tony Lindgren <tony@atomide.com>, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        openezx-devel@lists.openezx.org, linux-samsung-soc@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] ARM: OMAP: Initialize PWM backlight enable_gpio field
Date: Mon, 23 Sep 2013 23:41:00 +0200
Message-Id: <1379972467-11243-4-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379972467-11243-1-git-send-email-treding@nvidia.com>
References: <1379972467-11243-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO API defines 0 as being a valid GPIO number, so this field needs
to be initialized explicitly.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm/mach-omap2/board-zoom-peripherals.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index a90375d..5ed2884 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -227,6 +227,7 @@ static struct platform_pwm_backlight_data zoom_backlight_data = {
 	.max_brightness = 127,
 	.dft_brightness = 127,
 	.pwm_period_ns = 7812500,
+	.enable_gpio = -1,
 };
 
 static struct platform_device zoom_backlight_pwm = {
-- 
1.8.4

