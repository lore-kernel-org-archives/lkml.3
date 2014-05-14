Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbaENPLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:11:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829AbaENPLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:11:04 -0400
Date: Wed, 14 May 2014 17:10:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] uprobes: more x86 fixes
Message-ID: <20140514151016.GA530@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core

Based on tip:perf/uprobes


Denys found another nasty old bug in uprobes/x86: div, mul, shifts with
count in CL, and cmpxchg are not handled correctly.

Plus a couple of other minor fixes. Nobody acked the changes in x86/traps,
hopefully they are simple enough, and I believe that they make sense anyway
and allow to do more cleanups.

Denys Vlasenko (2):
      uprobes/x86: Simplify rip-relative handling
      uprobes/x86: Fix scratch register selection for rip-relative fixups

Oleg Nesterov (8):
      uprobes: Add mem_cgroup_charge_anon() into uprobe_write_opcode()
      x86/traps: Make math_error() static
      x86/traps: Use SEND_SIG_PRIV instead of force_sig()
      x86/traps: Introduce do_error_trap()
      x86/traps: Introduce fill_trap_info(), simplify DO_ERROR_INFO()
      x86/traps: Shift fill_trap_info() from DO_ERROR_INFO() to do_error_trap()
      x86/traps: Kill DO_ERROR_INFO()
      uprobes/x86: Fix the wrong ->si_addr when xol triggers a trap

 arch/x86/include/asm/traps.h   |    1 -
 arch/x86/include/asm/uprobes.h |    3 -
 arch/x86/kernel/traps.c        |  110 ++++++++++++---------
 arch/x86/kernel/uprobes.c      |  213 ++++++++++++++++++++++++++--------------
 include/linux/uprobes.h        |    4 +
 kernel/events/uprobes.c        |   33 ++++---
 6 files changed, 225 insertions(+), 139 deletions(-)

