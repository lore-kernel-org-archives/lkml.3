Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933707Ab3JORy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:54:59 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:41982 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932555Ab3JORyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:54:54 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Oct 2013 13:54:54 EDT
Message-Id: <20131015174722.615394057@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 15 Oct 2013 12:47:22 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu operations V4b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

** Resending using Comcast instead of Amazon SES.

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

