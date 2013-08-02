Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab3HBKR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:17:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37583 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab3HBKRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:17:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [ 07/39] tracing: Fix irqs-off tag display in syscall tracing
Date: Fri,  2 Aug 2013 18:18:17 +0800
Message-Id: <20130802101457.809517963@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802101456.800497005@linuxfoundation.org>
References: <20130802101456.800497005@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

commit 11034ae9c20f4057a6127fc965906417978e69b2 upstream

Initialization of variable irq_flags and pc was missed when backport
11034ae9c to linux-3.0.y and linux-3.4.y, my fault.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_syscalls.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -358,6 +358,9 @@ void ftrace_syscall_exit(void *ignore, s
 	if (!sys_data)
 		return;
 
+	local_save_flags(irq_flags);
+	pc = preempt_count();
+
 	event = trace_current_buffer_lock_reserve(&buffer,
 			sys_data->exit_event->event.type, sizeof(*entry),
 			irq_flags, pc);


