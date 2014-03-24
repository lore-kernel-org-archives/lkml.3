Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaCXWgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 18:36:48 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61771 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaCXWgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 18:36:46 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: Heiko Stuebner <heiko@sntech.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH] pinctrl: rockchip: fix offset of mux registers for rk3188
Date: Mon, 24 Mar 2014 23:36:01 +0100
Message-Id: <1395700561-3793-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The correct value of .mux_offset for rk3188 seems to be 0x60
instead of 0x68.

Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
---
 drivers/pinctrl/pinctrl-rockchip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 46dddc1..23e8812 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -1534,7 +1534,7 @@ static struct rockchip_pin_ctrl rk3188_pin_ctrl = {
 		.nr_banks		= ARRAY_SIZE(rk3188_pin_banks),
 		.label			= "RK3188-GPIO",
 		.type			= RK3188,
-		.mux_offset		= 0x68,
+		.mux_offset		= 0x60,
 		.pull_calc_reg		= rk3188_calc_pull_reg_and_bit,
 };
 
-- 
1.7.10.4

