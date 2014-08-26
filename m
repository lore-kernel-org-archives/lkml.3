Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbaHZDzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 23:55:06 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:34343 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbaHZDzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 23:55:02 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc: linux-sunxi@googlegroups.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Varka Bhadram <varkabhadram@gmail.com>, Chen-Yu Tsai <wens@csie.org>,
        rtc-linux@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH resend v5 2/2] rtc: sunxi: Depend on platforms sun4i/sun7i that actually have the rtc
Date: Tue, 26 Aug 2014 11:54:56 +0800
Message-Id: <1409025296-6342-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409025296-6342-1-git-send-email-wens@csie.org>
References: <1409025296-6342-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have Kconfig options for individual sunxi platforms, let
the rtc-sunxi driver depend on the platforms that actually have this
hardware, sun4i and sun7i.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/rtc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index f2300b4..6b34bc9 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -1184,7 +1184,7 @@ config RTC_DRV_SUN6I
 
 config RTC_DRV_SUNXI
 	tristate "Allwinner sun4i/sun7i RTC"
-	depends on ARCH_SUNXI
+	depends on MACH_SUN4I || MACH_SUN7I
 	help
 	  If you say Y here you will get support for the RTC found on
 	  Allwinner A10/A20.
-- 
2.1.0

