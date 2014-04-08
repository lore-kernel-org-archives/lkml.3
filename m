Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbaDHSLB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 14:11:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275AbaDHSK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 14:10:59 -0400
Date: Tue, 8 Apr 2014 20:10:40 +0200
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
Message-ID: <20140408181040.GA5179@redhat.com>
References: <20140404185131.GA14738@redhat.com> <5343BCF0.3030605@hitachi.com> <20140408161020.GB31460@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408161020.GB31460@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Oleg Nesterov wrote:
>
> On 04/08, Masami Hiramatsu wrote:
> >
> > (2014/04/05 3:51), Oleg Nesterov wrote:
> > >
> > > TODO: An error from adjust_ret_addr() shouldn't be silently ignored,
> > > we should teach arch_uprobe_post_xol() or handle_singlestep() paths
> > > to restart the probed insn in this case. And probably "adjust" can
> > > be simplified and turned into set_ret_addr(). It seems that we do
> > > not really need copy_from_user(), we can always calculate the value
> > > we need to write into *regs->sp.
> >
> > It seems that you fixed this in 8/9, we don't need the TODO list in
> > the description.
>
> Well, OK, I'll update the changelog and remove the "error ... ignored"
> part. Although to be honest, I do not understand why do you think it
> is bad to document the other problems you found while you were writing
> the patch.

I'll remove it altogether. But I'll update the changelog in
"Introduce sizeof_long() ..." from the next series to explain why I think
adjust_ret_addr() must die.

Oleg.

