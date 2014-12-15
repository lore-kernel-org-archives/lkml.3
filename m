Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaLOQT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:19:29 -0500
Received: from mx02.posteo.de ([89.146.194.165]:32856 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbaLOQTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:19:12 -0500
From: Martin Kepplinger <martink@posteo.de>
To: peterz@infradead.org
Cc: mingo@kernel.org, tytso@mit.edu, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 3/6] hwmon: jc42: use bitops' sign_extend16
Date: Mon, 15 Dec 2014 17:18:34 +0100
Message-Id: <1418660317-21750-4-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418660317-21750-1-git-send-email-martink@posteo.de>
References: <1418660317-21750-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/hwmon/jc42.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index 388f8bc..335a2de 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -31,6 +31,7 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/bitops.h>
 
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = {
@@ -215,9 +216,7 @@ static int jc42_temp_from_reg(s16 reg)
 {
 	reg &= 0x1fff;
 
-	/* sign extend register */
-	if (reg & 0x1000)
-		reg |= 0xf000;
+	reg = sign_extend16(reg, 12);
 
 	/* convert from 0.0625 to 0.001 resolution */
 	return reg * 125 / 2;
-- 
2.1.3

