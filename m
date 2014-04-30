Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759362AbaD3Sdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:33:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758922AbaD3Sdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:33:42 -0400
Date: Wed, 30 Apr 2014 19:39:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] uprobes: finish "fix the handling of relative
	jmp/call's" changes
Message-ID: <20140430173943.GA27643@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core

This hopefully completes the previous "fix the handling of relative
jmp/call's" series, all changes except the last 3 unrelated fixes try
to address TODO's mentioned in the changelogs.

Note: Denys spotted another nasty (and off-topic) bug in uprobes/x86,
we will try to fix it separately.


Denys Vlasenko (1):
      uprobes/x86: Refuse to attach uprobe to "word-sized" branch insns

Oleg Nesterov (20):
      uprobes/x86: Add uprobe_init_insn(), kill validate_insn_{32,64}bits()
      uprobes/x86: Add is_64bit_mm(), kill validate_insn_bits()
      uprobes/x86: Shift "insn_complete" from branch_setup_xol_ops() to uprobe_init_insn()
      uprobes/x86: Make good_insns_* depend on CONFIG_X86_*
      uprobes/x86: Fix is_64bit_mm() with CONFIG_X86_X32
      uprobes/x86: Don't change the task's state if ->pre_xol() fails
      uprobes/x86: Introduce uprobe_xol_ops->abort() and default_abort_op()
      uprobes/x86: Don't use arch_uprobe_abort_xol() in arch_uprobe_post_xol()
      uprobes/x86: Move UPROBE_FIX_SETF logic from arch_uprobe_post_xol() to default_post_xol_op()
      uprobes/x86: Move default_xol_ops's data into arch_uprobe->def
      uprobes/x86: Cleanup the usage of arch_uprobe->def.fixups, make it u8
      uprobes/x86: Introduce push_ret_address()
      uprobes/x86: Kill adjust_ret_addr(), simplify UPROBE_FIX_CALL logic
      uprobes/x86: Cleanup the usage of UPROBE_FIX_IP/UPROBE_FIX_CALL
      uprobes/x86: Rename *riprel* helpers to make the naming consistent
      uprobes/x86: Kill the "autask" arg of riprel_pre_xol()
      uprobes/x86: Simplify riprel_{pre,post}_xol() and make them similar
      uprobes/tracing: Make uprobe_perf_close() visible to uprobe_perf_open()
      uprobes/tracing: Fix uprobe_perf_open() on uprobe_apply() failure
      uprobes: Refuse to insert a probe into MAP_SHARED vma

 arch/x86/include/asm/uprobes.h |   13 +-
 arch/x86/kernel/process_64.c   |    7 +-
 arch/x86/kernel/uprobes.c      |  331 +++++++++++++++++++--------------------
 kernel/events/uprobes.c        |    2 +-
 kernel/trace/trace_uprobe.c    |   46 +++---
 5 files changed, 199 insertions(+), 200 deletions(-)

