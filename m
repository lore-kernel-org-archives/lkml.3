Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaFHONM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 10:13:12 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49841 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaFHONK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 10:13:10 -0400
From: Choi Gi-yong <yong@gnoy.org>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Choi Gi-yong <yong@gnoy.org>
Subject: [PATCH 2/2] Staging: speakup: ERROR: Fix macro parenthesis.
Date: Sun,  8 Jun 2014 23:12:57 +0900
Message-Id: <1402236777-10914-1-git-send-email-yong@gnoy.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Choi Gi-yong <yong@gnoy.org>
---
 drivers/staging/speakup/speakup_acntpc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/speakup/speakup_acntpc.c b/drivers/staging/speakup/speakup_acntpc.c
index 31f952b..f70b698 100644
--- a/drivers/staging/speakup/speakup_acntpc.c
+++ b/drivers/staging/speakup/speakup_acntpc.c
@@ -35,7 +35,7 @@
 #include "speakup_acnt.h" /* local header file for Accent values */
 
 #define DRV_VERSION "2.10"
-#define PROCSPEECH '\r'
+#define PROCSPEECH ('\r')
 
 static int synth_probe(struct spk_synth *synth);
 static void accent_release(void);
@@ -152,8 +152,10 @@ static inline bool synth_full(void)
 static const char *synth_immediate(struct spk_synth *synth, const char *buf)
 {
 	u_char ch;
+
 	while ((ch = *buf)) {
 		int timeout = SPK_XMITR_TIMEOUT;
+
 		if (ch == '\n')
 			ch = PROCSPEECH;
 		if (synth_full())
@@ -257,6 +259,7 @@ static int synth_probe(struct spk_synth *synth)
 {
 	unsigned int port_val = 0;
 	int i = 0;
+
 	pr_info("Probing for %s.\n", synth->long_name);
 	if (port_forced) {
 		speakup_info.port_tts = port_forced;
-- 
1.9.1

