Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaHQRah (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 13:30:37 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:47225 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751368AbaHQRag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 13:30:36 -0400
Message-Id: <20140817173023.439660246@linux.com>
Date: Sun, 17 Aug 2014 12:30:23 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 00/35] percpu: Consistent per cpu operations V7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V6->V7
- Separate out __get_cpu_var accesses of cpumasks and create a special
  patch that handles the configuration dependent conversion to either
  this_cpu_read() or this_cpu_ptr(). If this is problematic
  then the last 2 patches of the series can be dropped top leave __get_cpu_var use
  for these cases intact.
- Rebase against 3.17-rc1
- Convert newly introduced uses of __get_cpu_var
- Use Feng's korg testing to validate patch in a series of configurations
- Remove portions of the overview that describe patches already merged.
- Patches available in git tree on
	korg https://git.kernel.org/cgit/linux/kernel/git/christoph/percpu.git/


V4->V5
- Remove patches that were merged
- Update patches against 3.16-rc1
- randconfig debugging on x86
- All patches can be merged individually now (asid from the last two
  that remove functions)
- Non x86 and powerpc architecture patches have minimal verification.

V3->V4:
- Rediff patches
- Put the patches first that define the new API.
- Add patches to convert the __get_cpu_var stuff added in 3.14

V2->V3:
- Rediff patches
- Fix breakage caused by mips patches. Add a mips patch to convert from local_t.
- Update some descriptions.

V1->V2:
- Move legacy definition for __this_cpu_ptr into include/asm-generic/percpu.h
  so that users bypassing include/linux/percpu.h do not break (affects
  tile and s390)
- Merge raw_cpu_ops core and the patch to rename x86 __this_cpu primitives
  into one. Otherwise breakage will occur since x86 __this_cpu ops will fall
  back to generic ops which is not tolerated well by the preempt hackery
  in x86.
- Add notes to each patch that depends on another to avoid mismerges.
  Add acks etc.
- Use quilt-0.61 with the bug fix that ensures all mailing lists
  receive the postings intended for them.


The patches are follow on patches that complete the conversion of
__get_cpu_var uses. Aside from the 4 last patches all of them
can be applied independently. The last 4 patches deal with removal
of macros that are no longer needed because the earlier patches
converted the usage.

