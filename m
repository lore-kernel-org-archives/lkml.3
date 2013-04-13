Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3DMN4w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 09:56:52 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:41271 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3DMN4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 09:56:51 -0400
Message-ID: <1365861405.3814.1.camel@phoenix>
Subject: [PATCH RESEND] mfd: max8997: Return proper error if pdata is NULL
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Date: Sat, 13 Apr 2013 21:56:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return proper error instead of 0 if pdata is NULL.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/mfd/max8997.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 1471405..823f34b 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -209,8 +209,10 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 		}
 	}
 
-	if (!pdata)
+	if (!pdata) {
+		ret = -ENOMEM;
 		goto err;
+	}
 
 	max8997->pdata = pdata;
 	max8997->ono = pdata->ono;
-- 
1.7.9.5



