Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbaB0MZQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:25:16 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48020 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaB0MZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:25:14 -0500
Date: Thu, 27 Feb 2014 17:55:06 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Hogan <james.hogan@imgtec.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>, josh@joshtriplett.org
Subject: [PATCH 39/46] kernel: Add prototype declaration to header file
 include/linux/irq_work.h
Message-ID: <1e40ba09c3543e4f95e76efc65b28dace1f1fa34.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declaration of function to header file
include/linux/irq_work.h because it is used by more than one file.

This eliminates the following warning in kernel/irq_work.c:
kernel/irq_work.c:51:13: warning: no previous prototype for ‘arch_irq_work_raise’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/irq_work.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6601702..4212080 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -33,6 +33,7 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 void irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
+void arch_irq_work_raise(void);
 
 #ifdef CONFIG_IRQ_WORK
 bool irq_work_needs_cpu(void);
-- 
1.7.9.5

