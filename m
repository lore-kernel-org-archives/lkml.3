Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3KPRkX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 12:40:23 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:44609 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3KPRjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 12:39:43 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Levente Kurusa <levex@linux.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 4/5] kstrtox: remove redundant casts
Date: Sat, 16 Nov 2013 11:32:30 -0600
Message-Id: <1384623151-31302-5-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.4.2+fc1
In-Reply-To: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com>
References: <1384623151-31302-1-git-send-email-felipe.contreras@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The temporary variable is of the same type as the cast, so it's
redundant.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 lib/kstrtox.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index ec8da78..649b74b 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -176,7 +176,7 @@ int _kstrtoul(const char *s, unsigned int base, unsigned long *res)
 	rv = kstrtoull(s, base, &tmp);
 	if (rv < 0)
 		return rv;
-	if (tmp != (unsigned long long)(unsigned long)tmp)
+	if (tmp != (unsigned long)tmp)
 		return -ERANGE;
 	*res = tmp;
 	return 0;
@@ -192,7 +192,7 @@ int _kstrtol(const char *s, unsigned int base, long *res)
 	rv = kstrtoll(s, base, &tmp);
 	if (rv < 0)
 		return rv;
-	if (tmp != (long long)(long)tmp)
+	if (tmp != (long)tmp)
 		return -ERANGE;
 	*res = tmp;
 	return 0;
@@ -223,7 +223,7 @@ int kstrtouint(const char *s, unsigned int base, unsigned int *res)
 	rv = kstrtoull(s, base, &tmp);
 	if (rv < 0)
 		return rv;
-	if (tmp != (unsigned long long)(unsigned int)tmp)
+	if (tmp != (unsigned int)tmp)
 		return -ERANGE;
 	*res = tmp;
 	return 0;
@@ -254,7 +254,7 @@ int kstrtoint(const char *s, unsigned int base, int *res)
 	rv = kstrtoll(s, base, &tmp);
 	if (rv < 0)
 		return rv;
-	if (tmp != (long long)(int)tmp)
+	if (tmp != (int)tmp)
 		return -ERANGE;
 	*res = tmp;
 	return 0;
@@ -269,7 +269,7 @@ int kstrtou16(const char *s, unsigned int base, u16 *res)
 	rv = kstrtoull(s, base, &tmp);
 	if (rv < 0)
 		return rv;
-	if (tmp != (unsigned long long)(u16)tmp)
+	if (tmp != (u16)tmp)
 		return -ERANGE;
 	*res = tmp;
 	return 0;
@@ -284,7 +284,7 @@ int kstrtos16(const char *s, unsigned int base, s16 *res)
 	rv = kstrtoll(s, base, &tmp);
 	if (rv < 0)
 		return rv;
-	if (tmp != (long long)(s16)tmp)
+	if (tmp != (s16)tmp)
 		return -ERANGE;
 	*res = tmp;
 	return 0;
@@ -299,7 +299,7 @@ int kstrtou8(const char *s, unsigned int base, u8 *res)
 	rv = kstrtoull(s, base, &tmp);
 	if (rv < 0)
 		return rv;
-	if (tmp != (unsigned long long)(u8)tmp)
+	if (tmp != (u8)tmp)
 		return -ERANGE;
 	*res = tmp;
 	return 0;
@@ -314,7 +314,7 @@ int kstrtos8(const char *s, unsigned int base, s8 *res)
 	rv = kstrtoll(s, base, &tmp);
 	if (rv < 0)
 		return rv;
-	if (tmp != (long long)(s8)tmp)
+	if (tmp != (s8)tmp)
 		return -ERANGE;
 	*res = tmp;
 	return 0;
-- 
1.8.4.2+fc1

