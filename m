Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab3HTDSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 23:18:08 -0400
Received: from intranet.asianux.com ([58.214.24.6]:62336 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3HTDSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 23:18:07 -0400
X-Spam-Score: -101.1
Message-ID: <5212DFB0.8070902@asianux.com>
Date: Tue, 20 Aug 2013 11:17:04 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: jg1.han@samsung.com, Rusty Russell <rusty@rustcorp.com.au>,
        khali@linux-fr.org, David.Woodhouse@intel.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/params.c: use scnprintf() instead of sprintf()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some strings (e.g. version string), they are permitted to be larger
than PAGE_SIZE (although meaningless), so recommend to use scnprintf()
instead of sprintf().


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/params.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 1f228a3..4da300f 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -241,7 +241,8 @@ int parse_args(const char *doing,
 	}								\
 	int param_get_##name(char *buffer, const struct kernel_param *kp) \
 	{								\
-		return sprintf(buffer, format, *((type *)kp->arg));	\
+		return scnprintf(buffer, PAGE_SIZE, format,		\
+				*((type *)kp->arg));			\
 	}								\
 	struct kernel_param_ops param_ops_##name = {			\
 		.set = param_set_##name,				\
@@ -285,7 +286,7 @@ EXPORT_SYMBOL(param_set_charp);
 
 int param_get_charp(char *buffer, const struct kernel_param *kp)
 {
-	return sprintf(buffer, "%s", *((char **)kp->arg));
+	return scnprintf(buffer, PAGE_SIZE, "%s", *((char **)kp->arg));
 }
 EXPORT_SYMBOL(param_get_charp);
 
@@ -827,7 +828,7 @@ ssize_t __modver_version_show(struct module_attribute *mattr,
 	struct module_version_attribute *vattr =
 		container_of(mattr, struct module_version_attribute, mattr);
 
-	return sprintf(buf, "%s\n", vattr->version);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", vattr->version);
 }
 
 extern const struct module_version_attribute *__start___modver[];
-- 
1.7.7.6
