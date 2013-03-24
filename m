Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab3CXH1b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 03:27:31 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37320 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3CXH1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 03:27:09 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org
Subject: [RFC PATCH v2, part4 01/39] vmlinux.lds: add comments for global variables and clean up useless declarations
Date: Sun, 24 Mar 2013 15:24:27 +0800
Message-Id: <1364109934-7851-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
References: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch documents global variables exported from vmlinux.lds.
1) Add comments about usage guidelines for global variables exported
   from vmlinux.lds.S.
2) Remove unused __initdata_begin[] and __initdata_end[].

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 include/asm-generic/sections.h |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/sections.h b/include/asm-generic/sections.h
index c1a1216..f1a24b5 100644
--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -3,6 +3,26 @@
 
 /* References to section boundaries */
 
+/*
+ * Usage guidelines:
+ * _text, _data: architecture specific, don't use them in arch-independent code
+ * [_stext, _etext]: contains .text.* sections, may also contain .rodata.*
+ *                   and/or .init.* sections
+ * [_sdata, _edata]: contains .data.* sections, may also contain .rodata.*
+ *                   and/or .init.* sections.
+ * [__start_rodata, __end_rodata]: contains .rodata.* sections
+ * [__init_begin, __init_end]: contains .init.* sections, but .init.text.*
+ *                   may be out of this range on some architectures.
+ * [_sinittext, _einittext]: contains .init.text.* sections
+ * [__bss_start, __bss_stop]: contains BSS sections
+ *
+ * Following global variables are optional and may be unavailable on some
+ * architectures and/or kernel configurations.
+ *	_text, _data
+ *	__kprobes_text_start, __kprobes_text_end
+ *	__entry_text_start, __entry_text_end
+ *	__ctors_start, __ctors_end
+ */
 extern char _text[], _stext[], _etext[];
 extern char _data[], _sdata[], _edata[];
 extern char __bss_start[], __bss_stop[];
@@ -12,7 +32,6 @@ extern char _end[];
 extern char __per_cpu_load[], __per_cpu_start[], __per_cpu_end[];
 extern char __kprobes_text_start[], __kprobes_text_end[];
 extern char __entry_text_start[], __entry_text_end[];
-extern char __initdata_begin[], __initdata_end[];
 extern char __start_rodata[], __end_rodata[];
 
 /* Start and end of .ctors section - used for constructor calls. */
-- 
1.7.9.5

