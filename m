Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202Ab3LFXOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:14:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48466 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161433Ab3LFXMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ionut Nicu <ioan.nicu.ext@nsn.com>, Wolfram Sang <wsa@the-dreams.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 034/152] i2c: mux: gpio: use gpio_set_value_cansleep()
Date: Fri,  6 Dec 2013 15:09:18 -0800
Message-Id: <1386371476-2477-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ionut Nicu <ioan.nicu.ext@nsn.com>

commit 250ad590d6f12d93f4d85be305b0a598d609232e upstream.

Some gpio chips may have get/set operations that
can sleep. gpio_set_value() only works for chips
which do not sleep, for the others we will get a
kernel warning. Using gpio_set_value_cansleep()
will work for both chips that do sleep and those
who don't.

Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
Acked-by: Peter Korsgaard <peter.korsgaard@barco.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/muxes/i2c-mux-gpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index 9f50ef0..61da6b4 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -31,8 +31,8 @@ static void i2c_mux_gpio_set(const struct gpiomux *mux, unsigned val)
 	int i;
 
 	for (i = 0; i < mux->data.n_gpios; i++)
-		gpio_set_value(mux->gpio_base + mux->data.gpios[i],
-			       val & (1 << i));
+		gpio_set_value_cansleep(mux->gpio_base + mux->data.gpios[i],
+					val & (1 << i));
 }
 
 static int i2c_mux_gpio_select(struct i2c_adapter *adap, void *data, u32 chan)
-- 
1.8.3.2

