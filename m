Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533Ab3LDOHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:07:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17766 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab3LDOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:07:33 -0500
Date: Wed, 4 Dec 2013 17:07:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] mfd: max14577: cleanup an error message
Message-ID: <20131204140712.GA11681@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"pdata" is a NULL not an ERR_PTR so there is no use printing it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 1337c4527028..a5e1c370c609 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -96,8 +96,7 @@ static int max14577_i2c_probe(struct i2c_client *i2c,
 	}
 
 	if (!pdata) {
-		dev_err(&i2c->dev, "No platform data found: %ld\n",
-				PTR_ERR(pdata));
+		dev_err(&i2c->dev, "No platform data found.\n");
 		return -EINVAL;
 	}
 
