Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaDCUJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:09:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbaDCUJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:09:40 -0400
Date: Thu, 3 Apr 2014 21:50:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes/x86: Gather "riprel" functions together
Message-ID: <20140403195014.GB12639@redhat.com>
References: <20140331194409.GA9297@redhat.com> <1396468395.4659.59.camel@oc7886638347.ibm.com.usor.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396468395.4659.59.camel@oc7886638347.ibm.com.usor.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Jim Keniston wrote:
>
> On Mon, 2014-03-31 at 21:44 +0200, Oleg Nesterov wrote:
> ...
> > +static void
> > +handle_riprel_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs, long *correction)
> > +{
> > +	if (auprobe->fixups & (UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX)) {
> > +		struct arch_uprobe_task *autask;
> > +
> > +		autask = &current->utask->autask;
> > +		if (auprobe->fixups & UPROBE_FIX_RIP_AX)
> > +			regs->ax = autask->saved_scratch_register;
> > +		else
> > +			regs->cx = autask->saved_scratch_register;
> > +
> > +		/*
> > +		 * The original instruction includes a displacement, and so
> > +		 * is 4 bytes longer than what we've just single-stepped.
> > +		 * Fall through to handle stuff like "jmpq *...(%rip)" and
> > +		 * "callq *...(%rip)".
> > +		 */
> > +		if (correction)
> > +			*correction += 4;
> > +	}
> > +}
>
> This is another case of a glitch in the code being moved.  Since this
> code was moved to its own function, the "Fall through" comment makes no
> sense.  Maybe
> 		 * Caller may need to apply other fixups to handle stuff
> 		 * like "jmpq *...(%rip)" and "callq *...(%rip)".

Thanks. updated the comment in v2.

Oleg.

