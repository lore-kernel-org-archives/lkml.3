Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab3ISVo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:44:28 -0400
Received: from www17.your-server.de ([213.133.104.17]:55685 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3ISVo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:44:27 -0400
Subject: [PATCH 3/10] iio: at91_adc: Cocci spatch "noderef"
From: Thomas Meyer <thomas@m3y3r.de>
To: jic23@cam.ac.uk, grant.likely@linaro.org, rob.herring@calxeda.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Message-ID: <1379604755852-604229709-3-diffsplit-thomas@m3y3r.de>
References: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
In-Reply-To: <1379604755850-858421494-0-diffsplit-thomas@m3y3r.de>
Date: Thu, 19 Sep 2013 23:42:22 +0200
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sizeof when applied to a pointer typed expression gives the size of the
pointer.
Found by coccinelle spatch "misc/noderef.cocci"

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
--- a/drivers/iio/adc/at91_adc.c
+++ b/drivers/iio/adc/at91_adc.c
@@ -279,7 +279,7 @@ static int at91_adc_trigger_init(struct
 	int i, ret;
 
 	st->trig = devm_kzalloc(&idev->dev,
-				st->trigger_number * sizeof(st->trig),
+				st->trigger_number * sizeof(*st->trig),
 				GFP_KERNEL);
 
 	if (st->trig == NULL) {
