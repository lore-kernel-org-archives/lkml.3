Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbaAWN0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:26:30 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51385 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaAWN0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:26:10 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-46-52e11870e874
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: Jason Baron <jbaron@akamai.com>
Cc: linux-kernel@vger.kernel.org, Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [PATCH 3/3] dynamic_debug: replace obselete simple_strtoul() with
 kstrtouint()
Date: Thu, 23 Jan 2014 17:20:32 +0400
Message-id: <1390483232-7160-3-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1390483232-7160-1-git-send-email-a.ryabinin@samsung.com>
References: <1390483232-7160-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCJMWRmVeSWpSXmKPExsVy+t/xy7oFEg+DDE6cN7TY9usRm8WMxcdZ
	LS7vmsPmwOwx+cgCZo++LasYPT5vkgtgjuKySUnNySxLLdK3S+DKWLrOtqCJreL7pl6mBsb7
	LF2MHBwSAiYSzbPUuhg5gUwxiQv31rOB2EICSxklzu9U7WLkArJ7mCTur2pmBEmwCehJ/Ju1
	HaxIREBZ4srHG6wgNrOAl8TGq0uZQGxhgUiJjau/s4DYLAKqErMur2EF2cUr4Coxc1kkxC4F
	iWVf1jKD2JwCbhJdzW+YIfa6SlxYNIFtAiPvAkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5
	mxghIfF1B+PSY1aHGAU4GJV4eBO/3A8SYk0sK67MPcQowcGsJMKby/4wSIg3JbGyKrUoP76o
	NCe1+BAjEwenVAPjwZkpJi/+L3mSb/+w9vWq7VGRrinitVe1luucl1574+u59xZSDSUHVj3t
	zPi7+DdDsPqs4glHM+8KbS6tX8+pmpH1+8JiroQbf7NeO7AuiKvan/nZ7WLAjwX3WpPObeVy
	+LTY7FNDbzT749Wuk/Pbv/tK2HC947HyM5vTduTPU+H52TtK96Y8UWIpzkg01GIuKk4EAKgW
	ZPTnAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 lib/dynamic_debug.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index e488d9a..7288e38 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -268,14 +268,12 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
  */
 static inline int parse_lineno(const char *str, unsigned int *val)
 {
-	char *end = NULL;
 	BUG_ON(str == NULL);
 	if (*str == '\0') {
 		*val = 0;
 		return 0;
 	}
-	*val = simple_strtoul(str, &end, 10);
-	if (end == NULL || end == str || *end != '\0') {
+	if (kstrtouint(str, 10, val) < 0) {
 		pr_err("bad line-number: %s\n", str);
 		return -EINVAL;
 	}
-- 
1.8.3.2

