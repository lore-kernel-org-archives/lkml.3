Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3ILOBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:01:03 -0400
Received: from forward17.mail.yandex.net ([95.108.253.142]:33265 "EHLO
	forward17.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3ILOBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:01:01 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2013 10:01:01 EDT
From: Kirill Tkhai <tkhai@yandex.ru>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Subject: [PATCH]scripts/tags.sh: Increase identifier list
MIME-Version: 1.0
Message-Id: <4751378993980@web6g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Thu, 12 Sep 2013 17:53:00 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1)Add		__maybe_unused
		__always_unused
		__cacheline_aligned
		__cacheline_aligned_in_smp
		ACPI_EXPORT_SYMBOL
to the list.

2)Regroup and cleanup(spaces to tabs; make the same alignment).

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Michal Marek <mmarek@suse.cz>
---
 scripts/tags.sh |   33 ++++++++++++++++++---------------
 1 files changed, 18 insertions(+), 15 deletions(-)
diff --git a/scripts/tags.sh b/scripts/tags.sh
index 74f02e4..0e93787 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -148,21 +148,24 @@ dogtags()
 
 exuberant()
 {
-	all_target_sources | xargs $1 -a                        \
-	-I __initdata,__exitdata,__initconst,__devinitdata	\
-	-I __devinitconst,__cpuinitdata,__initdata_memblock	\
-	-I __refdata,__attribute				\
-	-I __acquires,__releases,__deprecated			\
-	-I __read_mostly,__aligned,____cacheline_aligned        \
-	-I ____cacheline_aligned_in_smp                         \
-	-I ____cacheline_internodealigned_in_smp                \
-	-I __used,__packed,__packed2__,__must_check,__must_hold	\
-	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL                      \
-	-I DEFINE_TRACE,EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL \
-	-I static,const						\
-	--extra=+f --c-kinds=+px                                \
-	--regex-asm='/^(ENTRY|_GLOBAL)\(([^)]*)\).*/\2/'        \
-	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/' \
+	all_target_sources | xargs $1 -a				\
+	-I __initdata,__exitdata,__initconst,__devinitdata		\
+	-I __devinitconst,__cpuinitdata,__initdata_memblock		\
+	-I __refdata,__attribute,__deprecated				\
+	-I __maybe_unused,__always_unused				\
+	-I __acquires,__releases					\
+	-I __read_mostly						\
+	-I __aligned,__cacheline_aligned,____cacheline_aligned		\
+	-I __cacheline_aligned_in_smp,____cacheline_aligned_in_smp	\
+	-I ____cacheline_internodealigned_in_smp			\
+	-I __used,__packed,__packed2__,__must_check,__must_hold		\
+	-I EXPORT_SYMBOL,EXPORT_SYMBOL_GPL,ACPI_EXPORT_SYMBOL		\
+	-I DEFINE_TRACE							\
+	-I EXPORT_TRACEPOINT_SYMBOL,EXPORT_TRACEPOINT_SYMBOL_GPL	\
+	-I static,const							\
+	--extra=+f --c-kinds=+px					\
+	--regex-asm='/^(ENTRY|_GLOBAL)\(([^)]*)\).*/\2/'		\
+	--regex-c='/^SYSCALL_DEFINE[[:digit:]]?\(([^,)]*).*/sys_\1/'	\
 	--regex-c++='/^TRACE_EVENT\(([^,)]*).*/trace_\1/'		\
 	--regex-c++='/^DEFINE_EVENT\([^,)]*, *([^,)]*).*/trace_\1/'	\
 	--regex-c++='/PAGEFLAG\(([^,)]*).*/Page\1/'			\
