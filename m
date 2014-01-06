Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaAFHnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:43:05 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34377 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaAFHnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:43:03 -0500
Message-ID: <1388994173.11037.0.camel@phoenix>
Subject: [PATCH] regulator: act8865: Fix build error when !OF
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Wenyou Yang <wenyou.yang@atmel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 15:42:53 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error when !OF:
  CC [M]  drivers/regulator/act8865-regulator.o
drivers/regulator/act8865-regulator.c: In function 'act8865_pmic_probe':
drivers/regulator/act8865-regulator.c:306:18: error: 'act8865_matches' undeclared (first use in this function)
drivers/regulator/act8865-regulator.c:306:18: note: each undeclared identifier is reported only once for each function it appears in
drivers/regulator/act8865-regulator.c:306:18: error: negative width in bit-field '<anonymous>'
make[2]: *** [drivers/regulator/act8865-regulator.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/act8865-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/act8865-regulator.c b/drivers/regulator/act8865-regulator.c
index 5e3e1d2..084cc08 100644
--- a/drivers/regulator/act8865-regulator.c
+++ b/drivers/regulator/act8865-regulator.c
@@ -303,7 +303,7 @@ static int act8865_pmic_probe(struct i2c_client *client,
 	}
 
 	/* Finally register devices */
-	for (i = 0; i < ARRAY_SIZE(act8865_matches); i++) {
+	for (i = 0; i < ACT8865_REG_NUM; i++) {
 
 		id = pdata->regulators[i].id;
 
-- 
1.8.1.2



