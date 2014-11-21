Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaKUT2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:28:48 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:43269 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaKUT2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:28:47 -0500
From: Arjun Sreedharan <arjun024@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm: early_printk: do bound check independent of @n
Date: Sat, 22 Nov 2014 00:58:36 +0530
Message-Id: <1416598116-2461-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 arch/arm/kernel/early_printk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/early_printk.c b/arch/arm/kernel/early_printk.c
index 4307653..9e05f8a 100644
--- a/arch/arm/kernel/early_printk.c
+++ b/arch/arm/kernel/early_printk.c
@@ -16,7 +16,7 @@ extern void printch(int);
 
 static void early_write(const char *s, unsigned n)
 {
-	while (n-- > 0) {
+	while (*s && n-- > 0) {
 		if (*s == '\n')
 			printch('\r');
 		printch(*s);
-- 
1.7.11.7

