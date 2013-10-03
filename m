Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3JCS22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:28:28 -0400
Received: from b232-131.smtp-out.amazonses.com ([199.127.232.131]:15634 "EHLO
	b232-131.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291Ab3JCS21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:28:27 -0400
Message-Id: <000001417f93f8eb-802d2cf9-29b6-46b7-975e-b909a5c17783-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Thu, 3 Oct 2013 18:28:26 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [pchecks v2 0/2] percpu v3: Implement Preemption checks for __this_cpu operations
X-SES-Outgoing: 199.127.232.131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces preemption checks for __this_cpu operations.

First we add new raw_cpu operations that perform this cpu operations
without preempt checks. 

The second patch then adds the preempt checks by modifying the
__this_cpu macros in include/linux/percpu.h

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

