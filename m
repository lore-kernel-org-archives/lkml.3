Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab3EXRlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 13:41:51 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56701 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab3EXRlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 13:41:50 -0400
Message-ID: <1369417304.9205.1.camel@phoenix>
Subject: [PATCH] power_supply: generic-adc-battery: Fix checking if none of
 the channels are supported
From: Axel Lin <axel.lin@ingics.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Anish Kumar <anish198519851985@gmail.com>, linux-kernel@vger.kernel.org
Date: Sat, 25 May 2013 01:41:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If none of the channels are supported, index is 0.
Also ensure to return error code instead of 0 in goto second_mem_fail path.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/power/generic-adc-battery.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
index 8cb5d7f..59a1421 100644
--- a/drivers/power/generic-adc-battery.c
+++ b/drivers/power/generic-adc-battery.c
@@ -299,8 +299,10 @@ static int gab_probe(struct platform_device *pdev)
 	}
 
 	/* none of the channels are supported so let's bail out */
-	if (index == ARRAY_SIZE(gab_chan_name))
+	if (index == 0) {
+		ret = -ENODEV;
 		goto second_mem_fail;
+	}
 
 	/*
 	 * Total number of properties is equal to static properties
-- 
1.8.1.2



