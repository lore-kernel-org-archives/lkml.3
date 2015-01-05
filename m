Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbbAEOcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:32:17 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:35076 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbbAEOcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:32:16 -0500
From: Guillaume Vercoutere <gvercoutere@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        gvercoutere@gmail.com
Subject: [PATCH 2/3] staging: android: Correct NULL comparison style in logger.c
Date: Mon,  5 Jan 2015 15:25:23 +0100
Message-Id: <1420467923-6397-1-git-send-email-gvercoutere@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace explicit NULL comparison with !

Signed-off-by: Guillaume Vercoutere <gvercoutere@gmail.com>
---
 drivers/staging/android/logger.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 59ea1a7..72b804e 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -707,11 +707,11 @@ static int __init create_log(char *log_name, int size)
 	unsigned char *buffer;
 
 	buffer = vmalloc(size);
-	if (buffer == NULL)
+	if (!buffer)
 		return -ENOMEM;
 
 	log = kzalloc(sizeof(struct logger_log), GFP_KERNEL);
-	if (log == NULL) {
+	if (!log) {
 		ret = -ENOMEM;
 		goto out_free_buffer;
 	}
@@ -719,7 +719,7 @@ static int __init create_log(char *log_name, int size)
 
 	log->misc.minor = MISC_DYNAMIC_MINOR;
 	log->misc.name = kstrdup(log_name, GFP_KERNEL);
-	if (log->misc.name == NULL) {
+	if (!log->misc.name) {
 		ret = -ENOMEM;
 		goto out_free_log;
 	}
-- 
1.7.10.4

