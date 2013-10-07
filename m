Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab3JGScA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 14:32:00 -0400
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:50511 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755791Ab3JGSby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 14:31:54 -0400
Message-ID: <0000014194309038-3923fc42-2039-45da-b8fa-2df545112405-000000@email.amazonses.com>
User-Agent: quilt/0.50-1
Date: Mon, 7 Oct 2013 18:31:53 +0000
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [raw v1 0/4] Replace __this_cpu ops with raw_cpu_ops where necessary
X-SES-Outgoing: 2013.10.07-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel can detect __this_cpu ops in preemptible contexts after
the preemption check patchset that I posted last week.

Here is a selection of patches to fix false positives caused by
the additional checks. So far I have found no bug. Amazing.
Looks like there was some prior work done to shake these things out?

I ran an upstream kernel using Ubuntu 13.04 + the preempt checking +
the patches below on my desktop and with the following patches no
__this_cpu ops triggered messages. The kernel had the default Ubuntu
desktop configuration (+ CONFIG_PREEMPT + CONFIG_DEBUG_THIS_CPU_OPERATIONS).

