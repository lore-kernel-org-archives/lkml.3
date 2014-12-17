Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaLQL42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 06:56:28 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:55289 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaLQL40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 06:56:26 -0500
From: samuel kihahu <skihahu@gmail.com>
To: gregkh@linuxfoundation.org
Cc: speakup@linux-speakup.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, samuel kihahu <skihahu@gmail.com>
Subject: [PATCH] staging: speakup: replace simple_strtoul with kstrtoul
Date: Wed, 17 Dec 2014 14:56:02 +0300
Message-Id: <1418817362-29088-1-git-send-email-skihahu@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing obsolete simple_strtoul with kstrtoul.

Signed-off-by: samuel kihahu <skihahu@gmail.com>
---
 drivers/staging/speakup/varhandlers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/varhandlers.c b/drivers/staging/speakup/varhandlers.c
index d758284..b526c8e 100644
--- a/drivers/staging/speakup/varhandlers.c
+++ b/drivers/staging/speakup/varhandlers.c
@@ -323,7 +323,7 @@ char *spk_s2uchar(char *start, char *dest)
 {
 	int val = 0;
 
-	val = simple_strtoul(skip_spaces(start), &start, 10);
+	val = kstrtoul(skip_spaces(start), &start, 10);
 	if (*start == ',')
 		start++;
 	*dest = (u_char)val;
-- 
1.8.3.1

