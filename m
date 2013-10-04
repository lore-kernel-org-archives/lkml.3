Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181Ab3JDGBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 02:01:41 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59460 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab3JDGBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 02:01:40 -0400
Date: Fri, 4 Oct 2013 08:01:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [pchecks v2 0/2] percpu v3: Implement Preemption checks for
 __this_cpu operations
Message-ID: <20131004060136.GB11399@gmail.com>
References: <000001417f93f8eb-802d2cf9-29b6-46b7-975e-b909a5c17783-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <000001417f93f8eb-802d2cf9-29b6-46b7-975e-b909a5c17783-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux.com> wrote:

> This patchset introduces preemption checks for __this_cpu operations.
> 
> First we add new raw_cpu operations that perform this cpu operations
> without preempt checks. 
> 
> The second patch then adds the preempt checks by modifying the
> __this_cpu macros in include/linux/percpu.h

Patch submission technical feedback: your 0/2 mail is still non-standard, 
it arrived out of order and looks broken - why isn't it threaded to the 
other patches? Here is how it looks like in my mailer:

You should either use "git send-email" to create proper threading (you can 
use that even if you originally created the series via Quilt), or you can 
send them manually with proper threading (that's what I did years ago when 
I still used Quilt).

You should not burden lkml with broken-format submissions, especially as 
the size of this patch series is expected to grow in the future, as you 
fix false positive warnings.

64877   C Oct 03 Christoph Lamet ( 206) ┬─>[pchecks v2 2/2] percpu: Add preemption checks to __this_cpu ops
64878   C Oct 03 Christoph Lamet ( 121) └─>[pchecks v2 1/2] percpu: Add raw_cpu_ops
64879   C Oct 03 Christoph Lamet (  24) [pchecks v2 0/2] percpu v3: Implement Preemption checks for __this_cpu operatio

> V2->V3:
> 	- Subject line in the raw_cpu_ops patch had ; instead of :.
> 	  Guess I am getting old.
> 	- Improve descriptions and variable names.
> 	- Run tests again with kvm to verify that it still works.
> 		A) No warnings with just the patches applied
> 		B) Lots of warnings with CONFIG_DEBUG_THIS_CPU_OPERATIONS enabled

Patch series technical feedback: it's standard kernel debugging 
infrastructure policy that all warnings that trigger with debugging 
enabled need to be fixed, so your series will need to fix them before I 
can move forward with merging these patches.

Please fix these technical shortcomings before your next submission.

Thanks,

	Ingo
