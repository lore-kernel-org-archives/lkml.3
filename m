Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaHDUNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:13:34 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:41035 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaHDUNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:13:32 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
        akpm@linux-foundation.org, srivatsa.bhat@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, qiuxishi@huawei.com, wangyun@linux.vnet.ibm.com,
        qiudayu@linux.vnet.ibm.com, joe@perches.com, alistair@popple.id.au,
        rcj@linux.vnet.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] arch/powerpc/mm/numa.c: Fix break placement
Date: Mon,  4 Aug 2014 23:13:10 +0300
Message-Id: <1407183190-1397-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81631
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 arch/powerpc/mm/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 3b181b2..d3e9a78 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -611,8 +611,8 @@ static int cpu_numa_callback(struct notifier_block *nfb, unsigned long action,
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
 		unmap_cpu_from_node(lcpu);
-		break;
 		ret = NOTIFY_OK;
+		break;
 #endif
 	}
 	return ret;
-- 
1.8.5.5

