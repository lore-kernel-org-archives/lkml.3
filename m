Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaDAPer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:34:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbaDAPep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:34:45 -0400
Date: Tue, 1 Apr 2014 16:33:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] uprobes/x86: Conditionalize the usage of
	handle_riprel_insn()
Message-ID: <20140401143346.GA18503@redhat.com>
References: <20140331194402.GA9287@redhat.com> <533A2FE3.3050101@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533A2FE3.3050101@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Masami Hiramatsu wrote:
>
> (2014/04/01 4:44), Oleg Nesterov wrote:
> > arch_uprobe_analyze_insn() calls handle_riprel_insn() at the start,
> > but only "0xff" and "default" cases need the UPROBE_FIX_RIP_ logic.
> > Move the callsite into "default" case and change the "0xff" case to
> > fall-through.
> >
> > We are going to add the various hooks to handle the rip-relative
> > jmp/call instructions (and more), we need this change to enforce the
> > fact that the new code can't conflict with is_riprel_insn() code.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Hmm, this seems not obviously reasonable at this point.
> However, the code itself is not wrong. Could you merge
> this change to that new hooks?

Good point, I'll send v2.

I'd still prefer to do this in a separate patch if you do not object,
and this patch should come after "add uprobe_xol_ops". In this case
it should be more clear why do we need this change, and the changelog
can tell more. Say, it can mention that otherwise uprobe_abort_xol()
can be confused until at least we add uprobe_xol_ops->abort().

And probably I'll add another patch into this series, "restart if
->post_xol() fails" (see "TODO:" in 7/7). We need this change anyway
to emulate the "call" insn. We could fix this before we add the hooks,
but after 7/7 the change will be more simple/clear.

Thanks!

Oleg.

