Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab3BFPal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:30:41 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:40289 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab3BFPak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:30:40 -0500
Message-ID: <1360164629.3398.2.camel@phoenix>
Subject: [PATCH] mfd: max8997: Return proper error if pdata is NULL
From: Axel Lin <axel.lin@ingics.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org
Date: Wed, 06 Feb 2013 23:30:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
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
+		ret = -EINVAL;
 		goto err;
+	}
 
 	max8997->pdata = pdata;
 	max8997->ono = pdata->ono;
-- 
1.7.9.5



