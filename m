Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3EKCRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 22:17:07 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41242 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab3EKCRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 22:17:05 -0400
Message-ID: <518DAA1A.3010407@gmail.com>
Date: Sat, 11 May 2013 10:16:58 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: rusty@rustcorp.com.au
CC: lizefan@huawei.com, linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] module: Add section ".ref.data" into kmemleak-scan-area.
Content-Type: multipart/mixed;
 boundary="------------070001050600090901000407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070001050600090901000407
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

In commit 523c81135,it used "__refdata" on event_class_ftrace_##call.
It will cause kmemleak to misjudge because when loading module it did
not add '.ref.data' into kmemleak-scan-area.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 kernel/module.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index b049939..dafe2ea 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2434,7 +2434,8 @@ static void kmemleak_load_module(const struct module *mod,
                const char *name = info->secstrings + info->sechdrs[i].sh_name;
                if (!(info->sechdrs[i].sh_flags & SHF_ALLOC))
                        continue;
-               if (!strstarts(name, ".data") && !strstarts(name, ".bss"))
+               if (!strstarts(name, ".data") && !strstarts(name, ".bss") &&
+                       !strstarts(name, ".ref.data"))
                        continue;
 
                kmemleak_scan_area((void *)info->sechdrs[i].sh_addr,
-- 
1.7.10.4


--------------070001050600090901000407
Content-Type: text/x-patch;
 name="0001-module-Add-section-.ref.data-to-kmemleak-area.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-module-Add-section-.ref.data-to-kmemleak-area.patch"

>From 9adf5b9aae7ceb97828042d0ae8fe9fb688bc691 Mon Sep 17 00:00:00 2001
From: Jianpeng Ma <majianpeng@gmail.com>
Date: Sat, 11 May 2013 10:04:14 +0800
Subject: [PATCH] module: Add section ".ref.data" into kmemleak-scan-area.

In commit 523c81135,it used "__refdata" on event_class_ftrace_##call.
It will cause kmemleak to misjudge because when loading module it did
not add '.ref.data' into kmemleak-scan-area.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 kernel/module.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index b049939..dafe2ea 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2434,7 +2434,8 @@ static void kmemleak_load_module(const struct module *mod,
 		const char *name = info->secstrings + info->sechdrs[i].sh_name;
 		if (!(info->sechdrs[i].sh_flags & SHF_ALLOC))
 			continue;
-		if (!strstarts(name, ".data") && !strstarts(name, ".bss"))
+		if (!strstarts(name, ".data") && !strstarts(name, ".bss") && 
+			!strstarts(name, ".ref.data"))
 			continue;
 
 		kmemleak_scan_area((void *)info->sechdrs[i].sh_addr,
-- 
1.7.10.4


--------------070001050600090901000407--
