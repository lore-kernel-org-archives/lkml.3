Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaHWL1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 07:27:41 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:21752 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752520AbaHWLY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 07:24:59 -0400
X-IronPort-AV: E=Sophos;i="5.04,386,1406584800"; 
   d="scan'208";a="90829924"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: josh@joshtriplett.org, kernel-janitors@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] rtc: use c99 initializers in structures
Date: Sat, 23 Aug 2014 13:20:31 +0200
Message-Id: <1408792831-25615-10-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use c99 initializers for structures.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@decl@
identifier i1,fld;
type T;
field list[n] fs;
@@

struct i1 {
 fs
 T fld;
 ...};

@bad@
identifier decl.i1,i2;
expression e;
initializer list[decl.n] is;
@@

struct i1 i2 = { is,
+ .fld = e
- e
 ,...};
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The patches in this series do not depend on each other.

 drivers/rtc/rtc-pcf8583.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8583.c b/drivers/rtc/rtc-pcf8583.c
index c263984..5911a6d 100644
--- a/drivers/rtc/rtc-pcf8583.c
+++ b/drivers/rtc/rtc-pcf8583.c
@@ -176,7 +176,11 @@ static int pcf8583_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	unsigned char ctrl, year[2];
-	struct rtc_mem mem = { CMOS_YEAR, sizeof(year), year };
+	struct rtc_mem mem = {
+		.loc = CMOS_YEAR,
+		.nr = sizeof(year),
+		.data = year
+	};
 	int real_year, year_offset, err;
 
 	/*
@@ -222,8 +226,16 @@ static int pcf8583_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	unsigned char year[2], chk;
-	struct rtc_mem cmos_year  = { CMOS_YEAR, sizeof(year), year };
-	struct rtc_mem cmos_check = { CMOS_CHECKSUM, 1, &chk };
+	struct rtc_mem cmos_year  = {
+		.loc = CMOS_YEAR,
+		.nr = sizeof(year),
+		.data = year
+	};
+	struct rtc_mem cmos_check = {
+		.loc = CMOS_CHECKSUM,
+		.nr = 1,
+		.data = &chk
+	};
 	unsigned int proper_year = tm->tm_year + 1900;
 	int ret;
 

