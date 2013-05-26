Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab3EZGmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 02:42:38 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:41713 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab3EZGmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 02:42:35 -0400
Message-ID: <51A1AECE.9040105@gmail.com>
Date: Sun, 26 May 2013 14:42:22 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Simon Horman <horms@verge.net.au>, Paul Mackerras <paulus@samba.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: [PATCH v2 5/7] powerpc: Remove savemaxmem parameter setup
References: <51A1AC4A.60506@gmail.com>
In-Reply-To: <51A1AC4A.60506@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

saved_max_pfn is used to know the amount of memory that the previous
kernel used. And for powerpc, we set saved_max_pfn by passing the
kernel commandline parameter "savemaxmem=".

The only user of saved_max_pfn in powerpc is read_oldmem interface.
Since we have removed read_oldmem, we don't need this parameter anymore.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/crash_dump.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/crash_dump.c b/arch/powerpc/kernel/crash_dump.c
index 9ec3fe1..779a78c 100644
--- a/arch/powerpc/kernel/crash_dump.c
+++ b/arch/powerpc/kernel/crash_dump.c
@@ -69,16 +69,6 @@ void __init setup_kdump_trampoline(void)
 }
 #endif /* CONFIG_NONSTATIC_KERNEL */
 
-static int __init parse_savemaxmem(char *p)
-{
-	if (p)
-		saved_max_pfn = (memparse(p, &p) >> PAGE_SHIFT) - 1;
-
-	return 1;
-}
-__setup("savemaxmem=", parse_savemaxmem);
-
-
 static size_t copy_oldmem_vaddr(void *vaddr, char *buf, size_t csize,
                                unsigned long offset, int userbuf)
 {
-- 
1.7.1

