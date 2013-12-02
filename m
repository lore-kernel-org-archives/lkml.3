Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab3LBVOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:14:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966Ab3LBTNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ionut Nicu <ioan.nicu.ext@nsn.com>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.10 028/173] i2c: mux: gpio: use gpio_set_value_cansleep()
Date: Mon,  2 Dec 2013 11:10:11 -0800
Message-Id: <20131202191146.015226082@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/muxes/i2c-mux-gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -31,8 +31,8 @@ static void i2c_mux_gpio_set(const struc
 	int i;
 
 	for (i = 0; i < mux->data.n_gpios; i++)
-		gpio_set_value(mux->gpio_base + mux->data.gpios[i],
-			       val & (1 << i));
+		gpio_set_value_cansleep(mux->gpio_base + mux->data.gpios[i],
+					val & (1 << i));
 }
 
 static int i2c_mux_gpio_select(struct i2c_adapter *adap, void *data, u32 chan)


