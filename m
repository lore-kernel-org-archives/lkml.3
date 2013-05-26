Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172Ab3EZGpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 02:45:53 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:47447 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab3EZGpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 02:45:50 -0400
Message-ID: <51A1AF93.70202@gmail.com>
Date: Sun, 26 May 2013 14:45:39 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Simon Horman <horms@verge.net.au>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: [PATCH v2 7/7] s390: Remove setting for saved_max_pfn
References: <51A1AC4A.60506@gmail.com>
In-Reply-To: <51A1AC4A.60506@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

The only user of saved_max_pfn in s390 is read_oldmem interface but we
have removed that interface, so saved_max_pfn is now unneeded in s390,
and we needn't set it anymore.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 arch/s390/kernel/setup.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 0a49095..497451e 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -719,10 +719,6 @@ static void reserve_oldmem(void)
 	}
 	create_mem_hole(memory_chunk, OLDMEM_BASE, OLDMEM_SIZE);
 	create_mem_hole(memory_chunk, OLDMEM_SIZE, real_size - OLDMEM_SIZE);
-	if (OLDMEM_BASE + OLDMEM_SIZE == real_size)
-		saved_max_pfn = PFN_DOWN(OLDMEM_BASE) - 1;
-	else
-		saved_max_pfn = PFN_DOWN(real_size) - 1;
 #endif
 }
 
-- 
1.7.1

