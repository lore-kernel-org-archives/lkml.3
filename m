Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab3AYWtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:49:04 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54330 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3AYWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:45:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 15/19] sunrpc: don't warn for unused variable 'buf'
Date: Fri, 25 Jan 2013 22:44:14 +0000
Message-Id: <1359153858-31992-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:cVoNLzvDoAlG2K0TJYUottMh1ho2HoyMxijEwli/Mb1
 oYMkjrchAgO2Z86x+yCYsKJfZerHJOCZqnIPNE2OmWApQfKfb0
 5+BCcv/QdbOMvXK+wc4y60HrpN8maobdHkpg5MR6uKxJJushf3
 /q82SIhv5GeKk4CnIV/XF2WMQiEbfiemF8Kiye0yNqGmbDwvFa
 AZ8chIU9DTMmrwXvkVR4jbZq5dORRgfFpvX3o8+d3qy8wesuS0
 LR0ORxedDZRwhigGXlPQqQQsF7K+4srDN1TdB5lkE5M1dHHIEl
 SjRxtMmyTLyylipcRG1vhXgCseLdGYfH0FzGXc/EvsriFZ3iuN
 +GkfVn1JbbPVoBky46K2kdoPhf+zwi0JrhosNFHVH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When RPC_DEBUG is unset, the dprintk() macro does nothing,
causing the 'buf' variable in svc_printk to become unused.
Marking it as __maybe_unused avoids a harmless gcc warning.

Without this patch, building at91_dt_defconfig results in:

net/sunrpc/svc.c: In function 'svc_printk':
net/sunrpc/svc.c:1051:7: warning: unused variable 'buf' [-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: "J. Bruce Fields" <bfields@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-nfs@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 net/sunrpc/svc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index dbf12ac..b1f5223 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1047,7 +1047,7 @@ void svc_printk(struct svc_rqst *rqstp, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
-	char 	buf[RPC_MAX_ADDRBUFLEN];
+	char buf[RPC_MAX_ADDRBUFLEN] __maybe_unused;
 
 	va_start(args, fmt);
 
-- 
1.8.0

