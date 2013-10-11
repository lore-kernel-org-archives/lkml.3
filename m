Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3JKQwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 12:52:24 -0400
Received: from a9-99.smtp-out.amazonses.com ([54.240.9.99]:38755 "EHLO
	a9-99.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276Ab3JKQwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 12:52:21 -0400
Message-ID: <00000141a86ede0e-a6d70e83-4902-4f57-b109-9daa42da7992-000000@email.amazonses.com>
User-Agent: quilt/0.60-1
Date: Fri, 11 Oct 2013 16:52:20 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu operations V4
X-SES-Outgoing: 2013.10.11-54.240.9.99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces preemption checks for __this_cpu operations.

First we add new raw_cpu operations that perform this cpu operations
without preempt checks in the future.

Then those raw_cpu operations are used in a number of locations to avoid
false positives.

The last patch then adds the preemption checks by modifying the
__this_cpu macros in include/linux/percpu.h

V3->v4:
	- Drop CONFIG_DEBUG_THIS_CPU_OPERATIONS
	- Detail operation triggering the log entry.
	- Use quilt 0.60/ [PATCH] prefix.
	- Clean up subject lines.
	- Include raw_cpu_ops conversion/fixes that were tested on
	  a Ubuntu 13.04 desktop.
	- Traces

V2->V3:
	- Subject line in the raw_cpu_ops patch had ; instead of :.
	  Guess I am getting old.
	- Improve descriptions and variable names.
	- Run tests again with kvm to verify that it still works.
		A) No warnings with just the patches applied
		B) Lots of warnings with CONFIG_DEBUG_THIS_CPU_OPERATIONS enabled
		C) No warnings with 3 core patches applied that simply convert
			__this_cpu operations to raw_cpu_ops.

V1->V2:
	- Reuse preemption check logic in lib/smp_processor_id.c
	- Add CONFIG_DEBUG_THIS_CPU_OPERATIONS
	- Remove conversions to the use of raw_cpu_ops since
	  these may require some discussion first.

