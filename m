Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936691Ab3DICsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:48:12 -0400
Received: from intranet.asianux.com ([58.214.24.6]:41981 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933990Ab3DICsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:48:11 -0400
X-Spam-Score: -100.7
Message-ID: <5163814A.2030006@asianux.com>
Date: Tue, 09 Apr 2013 10:47:38 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kernel: module: using strlcpy and strcpy instead of strncpy
References: <51615AB0.9060502@asianux.com> <87r4ila8sb.fsf@rustcorp.com.au> <516298E0.9000905@asianux.com>
In-Reply-To: <516298E0.9000905@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  namebuf is NUL terminated string.  better always let it ended by '\0'.
  ownername and module_name(owner) are the same buf len. strcpy is better.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/module.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 3c2c72d..09aeefd 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1283,7 +1283,7 @@ static const struct kernel_symbol *resolve_symbol(struct module *mod,
 
 getname:
 	/* We must make copy under the lock if we failed to get ref. */
-	strncpy(ownername, module_name(owner), MODULE_NAME_LEN);
+	strcpy(ownername, module_name(owner));
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
