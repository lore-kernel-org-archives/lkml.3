Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3CHGQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:16:01 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:56458 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3CHGP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:15:59 -0500
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: lucas.de.marchi@gmail.com
Cc: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/7] kernel/sys.c: Use the simpler call_usermodehelper()
Date: Fri,  8 Mar 2013 03:15:07 -0300
Message-Id: <1362723313-839-2-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit "7ff6764 usermodehelper: cleanup/fix __orderly_poweroff() &&
argv_free()" simplified __orderly_poweroff() removing the need to use
call_usermodehelper_fns().

Since we are not passing any callback, it's simpler to use
call_usermodehelper().

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 kernel/sys.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 81f5644..bd15276 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2203,8 +2203,7 @@ static int __orderly_poweroff(void)
 		return -ENOMEM;
 	}
 
-	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_WAIT_EXEC,
-				      NULL, NULL, NULL);
+	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
 	argv_free(argv);
 
 	return ret;
-- 
1.8.1.5

