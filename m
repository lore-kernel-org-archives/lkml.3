Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749Ab3BHDj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 22:39:57 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35743 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533Ab3BHDj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 22:39:56 -0500
MIME-Version: 1.0
Date: Fri, 8 Feb 2013 11:39:56 +0800
Message-ID: <CAJd=RBD4ZJN7uXQ5xY1GF14j_DydDQEpuZNct-UiNXTBARpQSQ@mail.gmail.com>
Subject: [PATCH 1/2] stop_machine: check work->done while handling enqueued works
From: Hillf Danton <dhillf@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hillf Danton <dhillf@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment just above cpu_stop_signal_done() says it is uncertain that
the input @done is valid, and the works enqueued through the function
stop_one_cpu_nowait() do carry no done, thus we have to check if it is
valid when updating work result.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/stop_machine.c	Thu Feb  7 20:03:10 2013
+++ b/kernel/stop_machine.c	Fri Feb  8 11:07:40 2013
@@ -279,7 +279,7 @@ repeat:
 		preempt_disable();

 		ret = fn(arg);
-		if (ret)
+		if (ret && done != NULL)
 			done->ret = ret;

 		/* restore preemption and check it's still balanced */
--
