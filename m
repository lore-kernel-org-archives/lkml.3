Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab3HNQO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:14:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16498 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760028Ab3HNQO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:14:26 -0400
Date: Wed, 14 Aug 2013 19:14:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] regulator: 88pm800: forever loop in pm800_regulator_probe()
Message-ID: <20130814161403.GA13601@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is supposed to be testing "i < ARRAY_SIZE()" instead of just
"ARRAY_SIZE()".

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/regulator/88pm800.c b/drivers/regulator/88pm800.c
index 58e9b74..3459f60 100644
--- a/drivers/regulator/88pm800.c
+++ b/drivers/regulator/88pm800.c
@@ -302,7 +302,7 @@ static int pm800_regulator_probe(struct platform_device *pdev)
 		unsigned int count = 0;
 
 		/* Check whether num_regulator is valid. */
-		for (i = 0; ARRAY_SIZE(pdata->regulators); i++) {
+		for (i = 0; i < ARRAY_SIZE(pdata->regulators); i++) {
 			if (pdata->regulators[i])
 				count++;
 		}
