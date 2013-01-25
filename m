Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab3AYOSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:18:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60530 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab3AYOPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:15:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 15/19] sunrpc: don't warn for unused variable 'buf'
Date: Fri, 25 Jan 2013 14:14:32 +0000
Message-Id: <1359123276-15833-16-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:EeG5WnyjrUW298Dbuqr4wE1v54Vz0cty8l97b4DWbIE
 jjoyu53+jYKA2HvrSyInBIo0QUwzm2x5XvOGloaNoFEAaC94u1
 kbkqm9YaIZWG2ksa5alDNcJTTnXZZsH8R6uBiYjm05ZqXsdXt3
 t4FDYNk5AS+6Frq3NiXRydMA/C6JXHMZ1oxhhIrIQ26OuKNl5N
 THfEqWmHKoct+jaCpUoAA6AQM84hpzVfMMA0yKNusKV+hi/D+G
 1KyJ2/74vcaOuDHByR4Wtn3PTDwJtZO3OqWrPMVXcCT0Pvfbkh
 KTU3MXrYwW2tCikNDr9QYjNdxIlZUsJ0V0uzcxUo0r3hzgLV8G
 OuwFYmIZnpl6J9qbr0JNp0uJFVkxoRUU8Ui3re5Bb
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

