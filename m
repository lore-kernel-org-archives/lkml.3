Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbaGBJ0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:26:15 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33709 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaGBJ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:26:13 -0400
From: Emil Goode <emilgoode@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrea Merello <andrea.merello@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] Staging: rtl8192e: Fix potential NULL pointer dereference
Date: Wed,  2 Jul 2014 11:25:51 +0200
Message-Id: <1404293151-15804-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to make sure the struct rtllib_device pointer ieee is not NULL
after the goto rx_dropped label since it is dereferenced there.

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/staging/rtl8192e/rtllib_rx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 60de54c..7db3e74 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -1496,7 +1496,8 @@ int rtllib_rx(struct rtllib_device *ieee, struct sk_buff *skb,
 	return ret;
 
  rx_dropped:
-	ieee->stats.rx_dropped++;
+	if (ieee)
+		ieee->stats.rx_dropped++;
 	return 0;
 }
 EXPORT_SYMBOL(rtllib_rx);
-- 
1.7.10.4

