Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867AbaBVHaM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 02:30:12 -0500
Received: from smtp21.mail.ru ([94.100.176.174]:41650 "EHLO smtp21.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbaBVHaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 02:30:08 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/4] w1: mxc_w1: Fix mxc_w1_ds2_reset_bus() return value
Date: Sat, 22 Feb 2014 11:29:49 +0400
Message-Id: <1393054191-8623-2-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393054191-8623-1-git-send-email-shc_work@mail.ru>
References: <1393054191-8623-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix mxc_w1_ds2_reset_bus() return value.
According to i.MX reference manual, "presence status" reflected
in the bit 6 of control register.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/w1/masters/mxc_w1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 1e5d94c..6525b2c 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -74,7 +74,7 @@ static u8 mxc_w1_ds2_reset_bus(void *data)
 
 		udelay(100);
 	}
-	return (reg_val >> 7) & 0x1;
+	return (reg_val >> 6) & 0x1;
 }
 
 /*
-- 
1.8.3.2

