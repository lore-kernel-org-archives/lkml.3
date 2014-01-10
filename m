Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbaAJQak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:30:40 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:48863 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894AbaAJQah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:30:37 -0500
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com,
        msalter@redhat.com, patches@linaro.org,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V6 5/8] Add strstr to compressed string.c for ARM.
Date: Fri, 10 Jan 2014 08:30:14 -0800
Message-Id: <1389371417-379-6-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shared efi-stub-helper.c functions require a strstr implementation.
The EFI stub is part of the decompressor, so it does not use the kernel
strstr() implementation.  This patch adds a strstr() implementation to
the string.c file for the decompressor, with the implementation copied
from the arch/x86/boot/string.c file used by the x86 decompressor.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
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

