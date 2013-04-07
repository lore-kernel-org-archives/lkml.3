Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418Ab3DGLiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 07:38:55 -0400
Received: from intranet.asianux.com ([58.214.24.6]:48620 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab3DGLix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 07:38:53 -0400
X-Spam-Score: -100.7
Message-ID: <51615AB0.9060502@asianux.com>
Date: Sun, 07 Apr 2013 19:38:24 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: rusty@rustcorp.com.au
CC: "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: module: strncpy issue, using strlcpy instead of strncpy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  ownername and namebuf are all NUL terminated string.

  need always let them ended by '\0'.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/module.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 3c2c72d..597efd8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1283,7 +1283,7 @@ static const struct kernel_symbol *resolve_symbol(struct module *mod,
 
 getname:
 	/* We must make copy under the lock if we failed to get ref. */
-	strncpy(ownername, module_name(owner), MODULE_NAME_LEN);
+	strlcpy(ownername, module_name(owner), MODULE_NAME_LEN);
 unlock:
 	mutex_unlock(&module_mutex);
 	return sym;
@@ -3464,7 +3464,7 @@ const char *module_address_lookup(unsigned long addr,
 	}
 	/* Make a copy in here where it's safe */
 	if (ret) {
-		strncpy(namebuf, ret, KSYM_NAME_LEN - 1);
+		strlcpy(namebuf, ret, KSYM_NAME_LEN);
 		ret = namebuf;
 	}
 	preempt_enable();
-- 
1.7.7.6
