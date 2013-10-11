Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3JKMRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:17:19 -0400
Received: from demumfd002.nsn-inter.net ([93.183.12.31]:14452 "EHLO
	demumfd002.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3JKMRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:17:18 -0400
Message-ID: <5257EC46.8040603@nsn.com>
Date: Fri, 11 Oct 2013 14:17:10 +0200
From: Ionut Nicu <ioan.nicu.ext@nsn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Korsgaard <peter.korsgaard@barco.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] i2c-mux-gpio: use gpio_set_value_cansleep()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1033
X-purgate-ID: 151667::1381493832-00005753-34CCD993/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some gpio chips may have get/set operations that
can sleep. gpio_set_value() only works for chips
which do not sleep, for the others we will get a
kernel warning. Using gpio_set_value_cansleep()
will work for both chips that do sleep and those
who don't.

Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
---
 drivers/i2c/muxes/i2c-mux-gpio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index a764da7..4ad9e71 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -30,8 +30,8 @@ static void i2c_mux_gpio_set(const struct gpiomux *mux, unsigned val)
 	int i;
 
 	for (i = 0; i < mux->data.n_gpios; i++)
-		gpio_set_value(mux->gpio_base + mux->data.gpios[i],
-			       val & (1 << i));
+		gpio_set_value_cansleep(mux->gpio_base + mux->data.gpios[i],
+					val & (1 << i));
 }
 
 static int i2c_mux_gpio_select(struct i2c_adapter *adap, void *data, u32 chan)
-- 
1.7.1

