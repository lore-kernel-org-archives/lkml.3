Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3CLAra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:47:30 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:56781 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab3CLAr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:47:29 -0400
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lucas.de.marchi@gmail.com, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH v3 1/7] kernel/sys.c: Use the simpler call_usermodehelper()
Date: Mon, 11 Mar 2013 21:48:05 -0300
Message-Id: <1363049291-946-1-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.8.1.5
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

