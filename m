Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbbAVNzG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:55:06 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:48711 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbbAVNzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:55:00 -0500
From: Anshul Garg <aksgarg1989@gmail.com>
X-Google-Original-From: Anshul Garg
To: akpm@linux-foundation.org, levex@linux.com, felipe.contreras@gmail.com,
        linux-kernel@vger.kernel.org
Cc: aksgarg1989@gmail.com, anshul.g@samsung.com
Subject: [PATCH] lib/kstrtox.c clean kstrtoll function
Date: Thu, 22 Jan 2015 05:54:10 -0800
Message-Id: <1421934850-77446-1-git-send-email-aksgarg1989@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <aksgarg1989@gmai.com>
References: <aksgarg1989@gmai.com>
X-Antivirus: avast! (VPS 150122-1, 01/22/2015), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anshul Garg <aksgarg1989@gmail.com>

Instead of having same code for negative and postive
integer, use sign variable for integer parsing.

Signed-off-by: Anshul Garg <aksgarg1989@gmail.com>
---
 lib/kstrtox.c |   24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index ec8da78..744cbb0 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -146,23 +146,19 @@ EXPORT_SYMBOL(kstrtoull);
 int kstrtoll(const char *s, unsigned int base, long long *res)
 {
 	unsigned long long tmp;
-	int rv;
+	int rv, sign = 1;
 
 	if (s[0] == '-') {
-		rv = _kstrtoull(s + 1, base, &tmp);
-		if (rv < 0)
-			return rv;
-		if ((long long)(-tmp) >= 0)
-			return -ERANGE;
-		*res = -tmp;
-	} else {
-		rv = kstrtoull(s, base, &tmp);
-		if (rv < 0)
-			return rv;
-		if ((long long)tmp < 0)
-			return -ERANGE;
-		*res = tmp;
+		sign = -1;
+		s++;
 	}
+
+	rv = kstrtoull(s, base, &tmp);
+	if (rv < 0)
+		return rv;
+	if ((long long)tmp < 0)
+		return -ERANGE;
+	*res = sign * tmp;
 	return 0;
 }
 EXPORT_SYMBOL(kstrtoll);
-- 
1.7.9.5


---
This email has been checked for viruses by Avast antivirus software.
http://www.avast.com

