Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbaK0Vh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 16:37:26 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:41337 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaK0VhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 16:37:24 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/9] staging: panel: Set default parport module param value
Date: Thu, 27 Nov 2014 22:36:45 +0100
Message-Id: <1417124213-23409-2-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
References: <1417124213-23409-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set default parport module param value to DEFAULT_PARPORT so that
a if-block can be avoided.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
Acked-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/panel/panel.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index c6eeddf..3dd318a 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -429,7 +429,7 @@ static struct timer_list scan_timer;
 
 MODULE_DESCRIPTION("Generic parallel port LCD/Keypad driver");
 
-static int parport = -1;
+static int parport = DEFAULT_PARPORT;
 module_param(parport, int, 0000);
 MODULE_PARM_DESC(parport, "Parallel port index (0=lpt1, 1=lpt2, ...)");
 
@@ -2231,9 +2231,6 @@ static int panel_init(void)
 	if (lcd_type < 0)
 		lcd_type = lcd_enabled;
 
-	if (parport < 0)
-		parport = DEFAULT_PARPORT;
-
 	/* take care of an eventual profile */
 	switch (profile) {
 	case PANEL_PROFILE_CUSTOM:
-- 
2.1.3

