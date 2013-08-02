Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3HBVaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:30:04 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:44906 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab3HBV3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:29:23 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 5/7] Add strstr to compressed string.c for ARM.
Date: Fri,  2 Aug 2013 14:29:06 -0700
Message-Id: <1375478948-22562-6-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shared efi-stub-helper.c functions require a strstr
implementation.
Implementation copied from arch/x86/boot/string.c

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/arm/boot/compressed/string.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm/boot/compressed/string.c b/arch/arm/boot/compressed/string.c
index 36e53ef..5397792 100644
--- a/arch/arm/boot/compressed/string.c
+++ b/arch/arm/boot/compressed/string.c
@@ -111,6 +111,27 @@ char *strchr(const char *s, int c)
 	return (char *)s;
 }
 
+/**
+ * strstr - Find the first substring in a %NUL terminated string
+ * @s1: The string to be searched
+ * @s2: The string to search for
+ */
+char *strstr(const char *s1, const char *s2)
+{
+	size_t l1, l2;
+
+	l2 = strlen(s2);
+	if (!l2)
+		return (char *)s1;
+	l1 = strlen(s1);
+	while (l1 >= l2) {
+		l1--;
+		if (!memcmp(s1, s2, l2))
+			return (char *)s1;
+		s1++;
+	}
+	return NULL;
+}
 #undef memset
 
 void *memset(void *s, int c, size_t count)
-- 
1.7.10.4

