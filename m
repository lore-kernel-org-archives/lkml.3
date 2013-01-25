Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613Ab3AYOQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:16:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63854 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab3AYOPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:15:11 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        David Daney <david.daney@cavium.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 07/19] scripts/sortextable: silence script output
Date: Fri, 25 Jan 2013 14:14:24 +0000
Message-Id: <1359123276-15833-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:EwB0RV32Mg5MRVpLvtu3GPbSazKzhDaZojgi/c146Fh
 1TIS9lj37DHRXAkPebdM8ELlSSHsEzz9F9SnYgeWsUg6exLEcQ
 UK99r5vuQDnaDNXlrBwZTWFBFlyDV0Sodbv+YcJisPebHQymE0
 W2QhDolo79Xe7h03sMdsMBmxiarPetyZD5LYZ/vmk7Q8D56fXT
 ZBrvIqe8oVg6Qd3q5ATcjvE5F9xJK0ruH+lwUVSnZmKWvrR/dL
 lhStPGWew2FLDjAdEqZG52DRKTsdaTichDAOU8LLvrHZ1f0oPg
 Yonfca0dIzj68kpGopL2kP+qgMosB+gEkRwHZs7U5QJRO058Gc
 QbpNWvknKmX36unCLNZhB3lRE/RjR3bu7Wvuta3bp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exception table sorter outputs one line every time
it gets called, e.g. 'sort done marker at 66dc00', which
is slightly annoying when doing 'make -s' which is otherwise
completely silent. Since that output is not helpful to
most people building the kernel, turn it off by default.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: David Daney <david.daney@cavium.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 scripts/sortextable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/sortextable.h b/scripts/sortextable.h
index e4fd45b..f5eb43d 100644
--- a/scripts/sortextable.h
+++ b/scripts/sortextable.h
@@ -182,7 +182,7 @@ do_func(Elf_Ehdr *ehdr, char const *const fname, table_sort_t custom_sort)
 		_r(&sort_needed_sym->st_value) -
 		_r(&sort_needed_sec->sh_addr);
 
-#if 1
+#if 0
 	printf("sort done marker at %lx\n",
 	       (unsigned long)((char *)sort_done_location - (char *)ehdr));
 #endif
-- 
1.8.0

