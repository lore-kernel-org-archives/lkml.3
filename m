Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbaEHTMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 15:12:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbaEHTMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 15:12:08 -0400
Date: Thu, 8 May 2014 21:11:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] x86/traps: cleanup DO_ERROR*() to prepare for uprobes
	fixes
Message-ID: <20140508191140.GA16892@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05/06, Oleg Nesterov wrote:
>
> Well, actually we are not 100% fine because si_addr can be wrong. But this is
> not invalid_op-specific, we need to fix this anyway and the fix is simple.
>
> I do not want to discuss this now, but I am going to make another series later
> which adds something like uprobe_instruction_pointer(regs). It can (should) be
> used by DO_ERROR_INFO() (perhaps by something else, not sure about math_error())

So we basically need a very simple fix,

	- DO_ERROR_INFO(..., regs->ip)
	+ DO_ERROR_INFO(..., uprobe_get_trap_addr(regs))

but it is not easy to change these define's, this series tries to cleanup and
simplify this code first.

Note: initially I was going to send more changes. For example, after this series
we can convert math_error() into the "normal" DO_ERROR() user, and most probably
we can do the same with do_general_protection().

But let me send the initial changes first for review. If they pass the review
and if nobody objects, I'd like to route them along with the pending uprobes
fixes.

Oleg.

 arch/x86/include/asm/traps.h |    1 -
 arch/x86/kernel/traps.c      |  107 +++++++++++++++++++++++------------------
 2 files changed, 60 insertions(+), 48 deletions(-)

