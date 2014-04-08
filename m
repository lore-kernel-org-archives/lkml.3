Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbaDHQMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:12:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055AbaDHQMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:12:46 -0400
Date: Tue, 8 Apr 2014 18:10:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/9] uprobes/x86: Introduce uprobe_xol_ops and
	arch_uprobe->ops
Message-ID: <20140408161020.GB31460@redhat.com>
References: <20140404185131.GA14738@redhat.com> <5343BCF0.3030605@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5343BCF0.3030605@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Masami Hiramatsu wrote:
>
> (2014/04/05 3:51), Oleg Nesterov wrote:
> >
> > TODO: An error from adjust_ret_addr() shouldn't be silently ignored,
> > we should teach arch_uprobe_post_xol() or handle_singlestep() paths
> > to restart the probed insn in this case. And probably "adjust" can
> > be simplified and turned into set_ret_addr(). It seems that we do
> > not really need copy_from_user(), we can always calculate the value
> > we need to write into *regs->sp.
>
> It seems that you fixed this in 8/9, we don't need the TODO list in
> the description.

Well, OK, I'll update the changelog and remove the "error ... ignored"
part. Although to be honest, I do not understand why do you think it
is bad to document the other problems you found while you were writing
the patch.

> > +	if (auprobe->ops->emulate)
> > +		return auprobe->ops->emulate(auprobe, regs);
> > +
> > +	/* TODO: move this code into ->emulate() hook */
>
> If you think this can move into the emulate(),

Yes sure,

> you should do in this
> patch.

No, sorry, I strongly disagree, this should come as a separate change,
and only after "Emulate jmp's".

> Since the following code runs by default, there should be
> no problem to do that.

Hmm. Not sure I understand "by default". If you meant that this should
go into default_emulate_op() (which we do not have), then I strongly
disagree again.

It should not, if nothing else we need to record insn->length somewhere,
this should go into ttt_emulate_op() we add later. And it simply looks
much more natural to handle jmp's and nop's together.

Masami, this time I simply can't understand your objections, please
clarify.

Thanks,

Oleg.

