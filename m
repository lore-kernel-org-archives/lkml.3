Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaFHG5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 02:57:46 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:59663 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaFHG5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 02:57:44 -0400
Message-ID: <5394097C.9030006@gmail.com>
Date: Sun, 08 Jun 2014 14:58:04 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: liqin.linux@gmail.com, lennox.wu@gmail.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/score/kernel/process.c: Remove useless varialbes 'ti'
 and 'regs'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are useless, so remove them, the related warning (with
allmodconfig under score):

    CC      arch/score/kernel/process.o
  arch/score/kernel/process.c: In function 'copy_thread':
  arch/score/kernel/process.c:76:18: warning: unused variable 'regs' [-Wunused-variable]
    struct pt_regs *regs = current_pt_regs();
                    ^
  arch/score/kernel/process.c:74:22: warning: unused variable 'ti' [-Wunused-variable]
    struct thread_info *ti = task_thread_info(p);
                        ^

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/score/kernel/process.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/score/kernel/process.c b/arch/score/kernel/process.c
index a1519ad3..50bf1b0 100644
--- a/arch/score/kernel/process.c
+++ b/arch/score/kernel/process.c
@@ -71,9 +71,7 @@ void flush_thread(void) {}
 int copy_thread(unsigned long clone_flags, unsigned long usp,
 		unsigned long arg, struct task_struct *p)
 {
-	struct thread_info *ti = task_thread_info(p);
 	struct pt_regs *childregs = task_pt_regs(p);
-	struct pt_regs *regs = current_pt_regs();
 
 	p->thread.reg0 = (unsigned long) childregs;
 	if (unlikely(p->flags & PF_KTHREAD)) {
-- 
1.7.11.7
