Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab3LLQy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:54:59 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24920 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3LLQyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:54:52 -0500
From: vegard.nossum@oracle.com
To: linux-kernel@vger.kernel.org
Cc: Vegard Nossum <vegard.nossum@oracle.com>, Alan Cox <alan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6/9] x86: Known exploit detection for CVE-2013-0268
Date: Thu, 12 Dec 2013 17:52:29 +0100
Message-Id: <1386867152-24072-6-git-send-email-vegard.nossum@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegard.nossum@oracle.com>

See c903f0456bc69176912dee6dd25c6a66ee1aed00.

Cc: Alan Cox <alan@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 arch/x86/kernel/msr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 88458fa..fad04f1 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -37,6 +37,7 @@
 #include <linux/notifier.h>
 #include <linux/uaccess.h>
 #include <linux/gfp.h>
+#include <linux/exploit.h>
 
 #include <asm/processor.h>
 #include <asm/msr.h>
@@ -174,8 +175,10 @@ static int msr_open(struct inode *inode, struct file *file)
 	unsigned int cpu = iminor(file_inode(file));
 	struct cpuinfo_x86 *c;
 
-	if (!capable(CAP_SYS_RAWIO))
+	if (!capable(CAP_SYS_RAWIO)) {
+		exploit("CVE-2013-0268");
 		return -EPERM;
+	}
 
 	if (cpu >= nr_cpu_ids || !cpu_online(cpu))
 		return -ENXIO;	/* No such CPU */
-- 
1.7.10.4

