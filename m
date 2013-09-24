Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476Ab3IXQBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:01:01 -0400
Received: from a14-70.smtp-out.amazonses.com ([54.240.14.70]:32867 "EHLO
	a14-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab3IXQA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:00:59 -0400
X-Greylist: delayed 1157 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Sep 2013 12:00:59 EDT
Message-ID: <0000014150a21162-f0f1d0c6-9686-4360-b32b-a04c48f33c51-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Tue, 24 Sep 2013 15:41:41 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: linux-arch@vger.kernel.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [pchecks v2 0/2] percpu v2: Implement Preemption checks for __this_cpu operations
X-SES-Outgoing: 2013.09.24-54.240.14.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces preemption checks for __this_cpu operations.

First we add new raw_cpu operations that perform this cpu operations
without preempt checks. 

The second patch then adds the preempt checks by modifying the
__this_cpu macros in include/linux/percpu.h

V1->V2:
	- Reuse preemption check logic in lib/smp_processor_id.c
	- Add CONFIG_DEBUG_THIS_CPU_OPERATIONS
	- Remove conversions to the use of raw_cpu_ops since
	  these may require some discussion first.

