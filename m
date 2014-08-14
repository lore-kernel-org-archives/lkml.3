Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaHNKNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 06:13:52 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:36610 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaHNKNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 06:13:51 -0400
From: kpark3469@gmail.com
To: akpm@linux-foundation.org
Cc: keun-o.park@windriver.com, hpa@zytor.com, rafael.j.wysocki@intel.com,
        peterz@infradead.org, rusty@rustcorp.com.au,
        kirill.shutemov@linux.intel.com, oleg@redhat.com, prarit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] earlyprintk: re-enable earlyprintk calling early_param
Date: Thu, 14 Aug 2014 19:13:36 +0900
Message-Id: <1408011216-8621-1-git-send-email-kpark3469@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sahara <keun-o.park@windriver.com>

Although there are many obs_kernel_param and its names are
earlyprintk and also EARLY_PRINTK is also enabled, we could not
see the early_printk output properly until now. This patch
considers earlycon as well as earlyprintk.

Signed-off-by: Sahara <keun-o.park@windriver.com>
---
 init/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index bb1aed9..235d248 100644
--- a/init/main.c
+++ b/init/main.c
@@ -426,7 +426,8 @@ static int __init do_early_param(char *param, char *val, const char *unused)
 	for (p = __setup_start; p < __setup_end; p++) {
 		if ((p->early && parameq(param, p->str)) ||
 		    (strcmp(param, "console") == 0 &&
-		     strcmp(p->str, "earlycon") == 0)
+		     ((strcmp(p->str, "earlycon") == 0) ||
+		     (strcmp(p->str, "earlyprintk") == 0)))
 		) {
 			if (p->setup_func(val) != 0)
 				pr_warn("Malformed early option '%s'\n", param);
-- 
1.7.9.5

