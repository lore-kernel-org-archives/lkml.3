Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbbALR2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:28:45 -0500
Received: from mx02.posteo.de ([89.146.194.165]:45165 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbbALR2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:28:43 -0500
From: Martin Kepplinger <martink@posteo.de>
To: mingo@kernel.org
Cc: peterz@infradead.org, paulmck@linux.vnet.ibm.com, tytso@mit.edu,
        maxime.coquelin@st.com, linux@roeck-us.net,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [RFC] hwmon: jc42: use bitops' sign_extend16
Date: Mon, 12 Jan 2015 18:28:20 +0100
Message-Id: <1421083700-25258-4-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421083700-25258-1-git-send-email-martink@posteo.de>
References: <1421083370-24924-1-git-send-email-martink@posteo.de>
 <1421083700-25258-1-git-send-email-martink@posteo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Example change, using new sign_extend functions.
---
 drivers/hwmon/jc42.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index 388f8bc..d0582a3 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -31,6 +31,7 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/bitops.h>
 
 /* Addresses to scan */
 static const unsigned short normal_i2c[] = {
@@ -213,11 +214,7 @@ static u16 jc42_temp_to_reg(int temp, bool extended)
 
 static int jc42_temp_from_reg(s16 reg)
 {
-	reg &= 0x1fff;
-
-	/* sign extend register */
-	if (reg & 0x1000)
-		reg |= 0xf000;
+	reg = sign_extend16(reg, 12);
 
 	/* convert from 0.0625 to 0.001 resolution */
 	return reg * 125 / 2;
-- 
2.1.4

