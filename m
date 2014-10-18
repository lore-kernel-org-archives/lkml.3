Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaJRO1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 10:27:30 -0400
Received: from mout.gmx.net ([212.227.15.19]:57472 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaJRO12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 10:27:28 -0400
Message-ID: <544277C5.9030302@gmx.at>
Date: Sat, 18 Oct 2014 16:23:01 +0200
From: Manfred Schlaegl <manfred.schlaegl@gmx.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
CC: Daniel Walter <dwalter@google.com>,
        Manfred Schlaegl <manfred.schlaegl@gmx.at>,
        Randy Dunlap <rdunlap@infradead.org>,
        user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] um: Remove unused bp stack-frame pointer
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V03:K0:74uhXHUhk+y266QCr9/TxU3XDyBfIUlzJv0FSCon4GPtakBeibC
 GwTwWtasr/ljyk1TCRM+J7/e9Ngt1FLhY2RO2VgcHOsWEYkw1l3Oalqggxy3fvO9Yb7vigh
 ux/hAfjV/75zVQXQrCkMob2p4J341zmAXfF3jy835ju+e6NHMAce1AX6UaYEUCdPSISkePU
 mI5ZZtaTfIkp3/jr7cbHg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer to bp stack-frame is no longer used. Removed it.
This also removes a corresponding compiler-warning.

Signed-off-by: Manfred Schlaegl <manfred.schlaegl@gmx.at>
---
 arch/um/kernel/sysrq.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 894c8d3..aa1b56f 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -29,7 +29,7 @@ static const struct stacktrace_ops stackops = {
  void show_stack(struct task_struct *task, unsigned long *stack)
 {
-	unsigned long *sp = stack, bp = 0;
+	unsigned long *sp = stack;
 	struct pt_regs *segv_regs = current->thread.segv_regs;
 	int i;
 @@ -39,10 +39,6 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 		return;
 	}
 -#ifdef CONFIG_FRAME_POINTER
-	bp = get_frame_pointer(task, segv_regs);
-#endif
-
 	if (!stack)
 		sp = get_stack_pointer(task, segv_regs);
 -- 1.7.10.4

