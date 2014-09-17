Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaIQMAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:00:17 -0400
Received: from gloria.sntech.de ([95.129.55.99]:34047 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbaIQMAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:00:16 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: broonie@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: [PATCH] regulator: fan53555: fix wrong cast in probe
Date: Wed, 17 Sep 2014 13:21:48 +0200
Message-ID: <2443447.AFyh6VXdN9@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vendor-id gathered from the dt match-data was cast to int but assigned
to an unsigned long, producing warnings on at least sparc, like

   drivers/regulator/fan53555.c: In function 'fan53555_regulator_probe':
>> drivers/regulator/fan53555.c:373:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
      di->vendor = (int) match->data;

Fix this by using an appropriate cast.

Reported-by: kbuild test robot
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/regulator/fan53555.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index f2f5535..6ca6e26 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -370,7 +370,7 @@ static int fan53555_regulator_probe(struct i2c_client *client,
 		if (!match)
 			return -ENODEV;
 
-		di->vendor = (int) match->data;
+		di->vendor = (unsigned long) match->data;
 	} else {
 		/* if no ramp constraint set, get the pdata ramp_delay */
 		if (!di->regulator->constraints.ramp_delay) {
-- 
2.0.1


