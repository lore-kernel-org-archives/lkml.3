Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaEDPl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbaEDPlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH 3.14 035/158] s390: fix control register update
Date: Sun,  4 May 2014 11:39:04 -0400
Message-Id: <20140504154034.736854242@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit a8a934e44f2bd0ed613e1aa0471e3478c6a9228a upstream.

The git commit c63badebfebacdba827ab1cc1d420fc81bd8d818
"s390: optimize control register update" broke the update for
control register 0. After the update do the lctlg from the correct
value.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/ptrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -64,7 +64,7 @@ void update_cr_regs(struct task_struct *
 		if (task->thread.per_flags & PER_FLAG_NO_TE)
 			cr_new &= ~(1UL << 55);
 		if (cr_new != cr)
-			__ctl_load(cr, 0, 0);
+			__ctl_load(cr_new, 0, 0);
 		/* Set or clear transaction execution TDC bits 62 and 63. */
 		__ctl_store(cr, 2, 2);
 		cr_new = cr & ~3UL;


