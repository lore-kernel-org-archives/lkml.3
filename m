Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaF3G3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:29:01 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:35340 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaF3G3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:29:00 -0400
Subject: [PATCH] powerpc/powernv: Check for IRQHAPPENED before sleeping
To: benh@kernel.crashing.org, mikey@neuling.org, mpe@ellerman.id.au
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: shreyas@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Mon, 30 Jun 2014 11:54:05 +0530
Message-ID: <20140630062404.29315.23382.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14063006-6688-0000-0000-000002F0369A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8d6f7c5a: "powerpc/powernv: Make it possible to skip the IRQHAPPENED
check in power7_nap()" added code that prevents even cores which enter sleep
on idle, from checking for pending interrupts. Fix this.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/kernel/idle_power7.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
index 2480256..5cf3d36 100644
--- a/arch/powerpc/kernel/idle_power7.S
+++ b/arch/powerpc/kernel/idle_power7.S
@@ -131,7 +131,7 @@ _GLOBAL(power7_nap)
 
 _GLOBAL(power7_sleep)
 	li	r3,1
-	li	r4,0
+	li	r4,1
 	b	power7_powersave_common
 	/* No return */
 

