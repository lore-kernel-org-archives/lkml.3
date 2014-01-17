Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbaAQGrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 01:47:46 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:33721 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaAQGrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 01:47:37 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH RFC 3/6] net: rfkill: gpio: fix reversed clock enable state
Date: Fri, 17 Jan 2014 14:47:28 +0800
Message-Id: <1389941251-32692-4-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389941251-32692-1-git-send-email-wens@csie.org>
References: <1389941251-32692-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rfkill-gpio has clk_enabled = blocked, which is true when rfkill
blocks the device. This results in calling clock enable/disable at
the wrong time. Reversing the value fixes this.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 net/rfkill/rfkill-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index c7081b7..3084fa3 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -59,7 +59,7 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
 		gpiod_set_value(rfkill->shutdown_gpio, 1);
 	}
 
-	rfkill->clk_enabled = blocked;
+	rfkill->clk_enabled = !blocked;
 
 	return 0;
 }
-- 
1.8.5.2

