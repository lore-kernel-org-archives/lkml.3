Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbaKRVBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:01:46 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43754 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673AbaKRU7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:59:05 -0500
From: Mariusz Gorski <marius.gorski@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] staging: panel: Call init function directly
Date: Tue, 18 Nov 2014 21:56:07 +0100
Message-Id: <1416344174-9155-3-git-send-email-marius.gorski@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com>
References: <1416344174-9155-1-git-send-email-marius.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove useless function and let the kernel call the actual
init function directly.

Signed-off-by: Mariusz Gorski <marius.gorski@gmail.com>
---
 drivers/staging/panel/panel.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 3dd318a..0d3f09e 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -2222,7 +2222,7 @@ static struct parport_driver panel_driver = {
 };
 
 /* init function */
-static int panel_init(void)
+static int __init panel_init_module(void)
 {
 	/* for backwards compatibility */
 	if (keypad_type < 0)
@@ -2334,11 +2334,6 @@ static int panel_init(void)
 	return 0;
 }
 
-static int __init panel_init_module(void)
-{
-	return panel_init();
-}
-
 static void __exit panel_cleanup_module(void)
 {
 	unregister_reboot_notifier(&panel_notifier);
-- 
2.1.3

