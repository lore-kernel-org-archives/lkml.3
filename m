Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbaGILKZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:10:25 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25379 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaGILKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:10:21 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-97-53bd23183d3c
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH -next 05/21] x86: cpu: don't sanitize early stages of a
 secondary CPU boot
Date: Wed, 09 Jul 2014 15:01:02 +0400
Message-id: <1404903678-8257-6-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
References: <1404903678-8257-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLJMWRmVeSWpSXmKPExsVy+t/xy7oSynuDDW59F7HY9usRm8XlXXPY
	HJg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK2PnyV9MBftYK/asn8rSwHiZpYuRk0NCwERi
	QcsnZghbTOLCvfVsXYxcHEICSxkl3p56ywaSEBLoY5Lo/gjWwCagJ/Fv1nawuIiAgsTm3mes
	IDazgI7ExmutTCC2sECCxOkLf8DqWQRUJXqffWIHsXkFXCWWXrwGtUxBYtnymWC9nAJuEj09
	C5ggdrlKrP68jXECI+8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCFB8GUH4+JjVocY
	BTgYlXh4NWp3BwuxJpYVV+YeYpTgYFYS4bUV3RssxJuSWFmVWpQfX1Sak1p8iJGJg1OqgbE6
	bMbMmYdm9TWE2l9/vchavmO+mMYVgYkZb19XLOcrvXrgeovn9aYd6UsXHTd31GTinO8+acs7
	nV6POSvqT+zQ3NPguK5+Nd9zfkX9mPVvXs+anTY36ABXdufcPRVK8/dXX7KPzLubYLfgs/XJ
	pYIrlrnkS3x1/e4k9DaeIV4g7V1Sk3GfYbASS3FGoqEWc1FxIgDD0Lzn4AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instrumentation of this files may result in unbootable machine.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 arch/x86/kernel/cpu/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 7fd54f0..a7bb360 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -8,6 +8,9 @@ CFLAGS_REMOVE_common.o = -pg
 CFLAGS_REMOVE_perf_event.o = -pg
 endif
 
+KASAN_SANITIZE_common.o := n
+KASAN_SANITIZE_perf_event.o := n
+
 # Make sure load_percpu_segment has no stackprotector
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_common.o		:= $(nostackp)
-- 
1.8.5.5

