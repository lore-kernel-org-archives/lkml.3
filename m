Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbaEFT1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:27:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbaEFT1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:27:02 -0400
Date: Tue, 6 May 2014 21:26:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] uprobes: add comment with insn opcodes, mnemonics
	and why we dont support them
Message-ID: <20140506192641.GA12481@redhat.com>
References: <1399314247-7368-1-git-send-email-dvlasenk@redhat.com> <20140505194100.GA26916@redhat.com> <5369156C.4000602@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5369156C.4000602@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly, let me remind that my understanding of low lovel hardware details
is very limited.

On 05/06, Denys Vlasenko wrote:
>
> Oleg, can you clear for me the following -
>
> If the probed instruction triggers an "illegal insn" or "privileged insn"
> CPU exception - are we completely fine?

Yes I think we are fine. I assume that, say, do_debug() won't be called in this
case, and do_invalid_op()->do_trap() should trigger arch_uprobe_xol_was_trapped()
logic.

Well, actually we are not 100% fine because si_addr can be wrong. But this is
not invalid_op-specific, we need to fix this anyway and the fix is simple.

I do not want to discuss this now, but I am going to make another series later
which adds something like uprobe_instruction_pointer(regs). It can (should) be
used by DO_ERROR_INFO() (perhaps by something else, not sure about math_error())
_and_ by show_unhandled_signals users (actually the main reason to me). The only
problem is that this code should be cleanuped first. In fact I was thinking about
this change from the very beginning of the recent fixes, the "wrong" ip reported
by do_general_protection() greatly complicated the investigation of that problem.
But I need to take a rest of uprobes ;)

Oleg.

