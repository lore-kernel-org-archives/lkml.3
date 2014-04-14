Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaDNWAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:00:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35548 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755830AbaDNWAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:00:24 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCHv2 08/11] ARM: shmobile: Armadillo 800 EVA: use PWM_LOOKUP to initialize struct pwm_lookup
Date: Mon, 14 Apr 2014 23:59:50 +0200
Message-Id: <1397512793-10325-9-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1397512793-10325-1-git-send-email-alexandre.belloni@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/mach-shmobile/board-armadillo800eva.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-shmobile/board-armadillo800eva.c b/arch/arm/mach-shmobile/board-armadillo800eva.c
index 1bf61dad9a35..ca82b1e2ebab 100644
--- a/arch/arm/mach-shmobile/board-armadillo800eva.c
+++ b/arch/arm/mach-shmobile/board-armadillo800eva.c
@@ -407,14 +407,8 @@ static struct platform_device pwm_device = {
 };
 
 static struct pwm_lookup pwm_lookup[] = {
-	{
-		.provider = "renesas-tpu-pwm",
-		.index = 2,
-		.dev_id = "pwm-backlight.0",
-		.con_id = NULL,
-		.period = 33333,
-		.polarity = PWM_POLARITY_INVERSED,
-	},
+	PWM_LOOKUP("renesas-tpu-pwm", 2, "pwm-backlight.0", NULL,
+		   33333, PWM_POLARITY_INVERSED),
 };
 
 /* LCDC and backlight */
-- 
1.8.3.2

