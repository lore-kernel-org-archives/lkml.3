Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab3HQU7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 16:59:14 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56099 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab3HQU7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 16:59:10 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v3 8/8] watchdog: w83627hf_wdt: Reset watchdog trigger during initialization
Date: Sat, 17 Aug 2013 13:58:46 -0700
Message-Id: <1376773126-2717-9-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
References: <1376773126-2717-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the watchdog has already triggered for whatever reason, it won't restart
unless the trigger is reset.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/watchdog/w83627hf_wdt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 4c9f27a..5979c1c 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -211,8 +211,8 @@ static int w83627hf_init(struct watchdog_device *wdog, enum chips chip)
 	t = superio_inb(cr_wdt_control) & ~0x0C;
 	superio_outb(cr_wdt_control, t);
 
-	/* disable keyboard & mouse turning off watchdog */
-	t = superio_inb(0xF7) & ~0xC0;
+	/* reset trigger, disable keyboard & mouse turning off watchdog */
+	t = superio_inb(0xF7) & ~0xD0;
 	superio_outb(0xF7, t);
 
 	superio_exit();
-- 
1.7.9.7

