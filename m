Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbaFNNVw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 09:21:52 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:60703 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbaFNNVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 09:21:51 -0400
From: Jeff Oczek <jeffoczek@gmail.com>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jeff Oczek <jeffoczek@gmail.com>
Subject: [PATCH v2 1/2] staging: tidspbridge: Add parameter names to function ptrs in struct dbll_attrs
Date: Sat, 14 Jun 2014 09:21:16 -0400
Message-Id: <1402752077-16297-1-git-send-email-jeffoczek@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402714093-15404-1-git-send-email-jeffoczek@gmail.com>
References: <1402714093-15404-1-git-send-email-jeffoczek@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add more descriptive names to function pointers in definition of struct dbll_attrs

Signed-off-by: Jeff Oczek <jeffoczek@gmail.com>
---
 drivers/staging/tidspbridge/include/dspbridge/dblldefs.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h b/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
index 30e0aa0..e988e1e 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dblldefs.h
@@ -168,11 +168,11 @@ struct dbll_attrs {
 	 *  These file manipulation functions should be compatible with the
 	 *  "C" run time library functions of the same name.
 	 */
-	 s32(*fread) (void *, size_t, size_t, void *);
-	 s32(*fseek) (void *, long, int);
-	 s32(*ftell) (void *);
-	 s32(*fclose) (void *);
-	void *(*fopen) (const char *, const char *);
+	 s32 (*fread)(void *ptr, size_t size, size_t count, void *filp);
+	 s32 (*fseek)(void *filp, long offset, int origin);
+	 s32 (*ftell)(void *filp);
+	 s32 (*fclose)(void *filp);
+	 void *(*fopen)(const char *path, const char *mode);
 };
 
 /*
-- 
1.9.1

