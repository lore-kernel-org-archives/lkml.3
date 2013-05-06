Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3EFNGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:06:08 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48685 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab3EFNFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:05:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/4] xen/spinlock: Fix check from greater than to be also be greater or equal to.
Date: Mon,  6 May 2013 09:04:58 -0400
Message-Id: <1367845498-14290-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367845498-14290-1-git-send-email-konrad.wilk@oracle.com>
References: <1367845498-14290-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During review of git commit cb9c6f15f318aa3aeb62fe525aa5c6dcf6eee159
("xen/spinlock:  Check against default value of -1 for IRQ line.")
Stefano pointed out a bug in the patch. Unfortunatly due to vacation
timing the fix was not applied and this patch fixes it up.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/spinlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index 8b54603..3002ec1 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -364,7 +364,7 @@ void __cpuinit xen_init_lock_cpu(int cpu)
 	int irq;
 	const char *name;
 
-	WARN(per_cpu(lock_kicker_irq, cpu) > 0, "spinlock on CPU%d exists on IRQ%d!\n",
+	WARN(per_cpu(lock_kicker_irq, cpu) >= 0, "spinlock on CPU%d exists on IRQ%d!\n",
 	     cpu, per_cpu(lock_kicker_irq, cpu));
 
 	/*
-- 
1.8.1.4

