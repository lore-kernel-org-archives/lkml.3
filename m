Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125AbaBYEQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 23:16:06 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:52965 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaBYEQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 23:16:04 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>, linux-xtensa@linux-xtensa.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] xtensa: export ccount_freq
Date: Mon, 24 Feb 2014 20:07:44 -0800
Message-Id: <1393301264-5228-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xtensa:allmodconfig fails to build with hundreds of messages such as

ERROR: "ccount_freq" [drivers/ata/pata_hpt3x2n.ko] undefined!

Exporting ccount_freq solves the problem.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/xtensa/kernel/time.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/xtensa/kernel/time.c b/arch/xtensa/kernel/time.c
index 08b769d..2a1823d 100644
--- a/arch/xtensa/kernel/time.c
+++ b/arch/xtensa/kernel/time.c
@@ -30,6 +30,7 @@
 #include <asm/platform.h>
 
 unsigned long ccount_freq;		/* ccount Hz */
+EXPORT_SYMBOL(ccount_freq);
 
 static cycle_t ccount_read(struct clocksource *cs)
 {
-- 
1.7.9.7

