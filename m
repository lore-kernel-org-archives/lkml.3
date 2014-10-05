Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaJEN1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 09:27:19 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:62976 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaJEN1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 09:27:15 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Grant Likely <grant.likely@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] lib: string.c:  A speed optimized for strncpy
Date: Sun,  5 Oct 2014 15:29:16 +0200
Message-Id: <1412515757-19689-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1412515757-19689-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1412515757-19689-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variant is in my tests about 7-10% faster, and also think
it is perhaps even clearer code than before.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 lib/string.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index f3c6ff5..6961229 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -123,12 +123,12 @@ char *strncpy(char *dest, const char *src, size_t count)
 {
 	char *tmp = dest;
 
-	while (count) {
-		if ((*tmp = *src) != 0)
-			src++;
-		tmp++;
-		count--;
-	}
+	while (count && (*tmp++ = *src++))
+		--count;
+
+	while (count--)
+		*tmp++ = '\0';
+
 	return dest;
 }
 EXPORT_SYMBOL(strncpy);
-- 
1.7.10.4

