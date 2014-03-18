Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbaCRVY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:24:58 -0400
Received: from mail-yk0-f170.google.com ([209.85.160.170]:57134 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbaCRVY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:24:56 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH] avr32: replace simple_strtoul() with kstrtoul()
Date: Tue, 18 Mar 2014 17:25:41 -0400
Message-Id: <1395177941-5680-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

simple_strtoul() is marked for obsoletion; use the newer and more
pleasant kstrtoul() in its place.

Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 arch/avr32/kernel/cpu.c | 48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/avr32/kernel/cpu.c b/arch/avr32/kernel/cpu.c
index 2233be7..389e2d1 100644
--- a/arch/avr32/kernel/cpu.c
+++ b/arch/avr32/kernel/cpu.c
@@ -39,11 +39,11 @@ static ssize_t store_pc0event(struct device *dev,
 			      size_t count)
 {
 	unsigned long val;
-	char *endp;
+	int ret;
 
-	val = simple_strtoul(buf, &endp, 0);
-	if (endp == buf || val > 0x3f)
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 	val = (val << 12) | (sysreg_read(PCCR) & 0xfffc0fff);
 	sysreg_write(PCCR, val);
 	return count;
@@ -61,11 +61,11 @@ static ssize_t store_pc0count(struct device *dev,
 				const char *buf, size_t count)
 {
 	unsigned long val;
-	char *endp;
+	int ret;
 
-	val = simple_strtoul(buf, &endp, 0);
-	if (endp == buf)
-		return -EINVAL;
+	ret = kstroul(buf, 0, &val);
+	if (ret)
+		return ret;
 	sysreg_write(PCNT0, val);
 
 	return count;
@@ -84,11 +84,11 @@ static ssize_t store_pc1event(struct device *dev,
 			      size_t count)
 {
 	unsigned long val;
-	char *endp;
+	int ret;
 
-	val = simple_strtoul(buf, &endp, 0);
-	if (endp == buf || val > 0x3f)
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 	val = (val << 18) | (sysreg_read(PCCR) & 0xff03ffff);
 	sysreg_write(PCCR, val);
 	return count;
@@ -106,11 +106,11 @@ static ssize_t store_pc1count(struct device *dev,
 			      size_t count)
 {
 	unsigned long val;
-	char *endp;
+	int ret;
 
-	val = simple_strtoul(buf, &endp, 0);
-	if (endp == buf)
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 	sysreg_write(PCNT1, val);
 
 	return count;
@@ -129,11 +129,11 @@ static ssize_t store_pccycles(struct device *dev,
 			      size_t count)
 {
 	unsigned long val;
-	char *endp;
+	int ret;
 
-	val = simple_strtoul(buf, &endp, 0);
-	if (endp == buf)
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 	sysreg_write(PCCNT, val);
 
 	return count;
@@ -152,11 +152,11 @@ static ssize_t store_pcenable(struct device *dev,
 			      size_t count)
 {
 	unsigned long pccr, val;
-	char *endp;
+	int ret;
 
-	val = simple_strtoul(buf, &endp, 0);
-	if (endp == buf)
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 	if (val)
 		val = 1;
 
-- 
1.9.0.431.g014438b

