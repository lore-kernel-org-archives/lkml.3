Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaAQGrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 01:47:40 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:33723 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaAQGrh (ORCPT
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
Subject: [PATCH RFC 1/6] net: rfkill: gpio: fix gpio name buffer size off by 1
Date: Fri, 17 Jan 2014 14:47:26 +0800
Message-Id: <1389941251-32692-2-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389941251-32692-1-git-send-email-wens@csie.org>
References: <1389941251-32692-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snprintf should be passed the complete size of the buffer, including
the space for '\0'. The previous code resulted in the *_reset and
*_shutdown strings being truncated.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 net/rfkill/rfkill-gpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index bd2a5b9..97ec12a 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -117,8 +117,8 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
 	if (!rfkill->shutdown_name)
 		return -ENOMEM;
 
-	snprintf(rfkill->reset_name, len + 6 , "%s_reset", rfkill->name);
-	snprintf(rfkill->shutdown_name, len + 9, "%s_shutdown", rfkill->name);
+	snprintf(rfkill->reset_name, len + 7 , "%s_reset", rfkill->name);
+	snprintf(rfkill->shutdown_name, len + 10, "%s_shutdown", rfkill->name);
 
 	rfkill->clk = devm_clk_get(&pdev->dev, clk_name);
 
-- 
1.8.5.2

