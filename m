Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaEMRM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 13:12:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaEMRMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 13:12:23 -0400
Date: Tue, 13 May 2014 19:11:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: can't we kill DIE_GPF ? (Was: x86/traps: cleanup DO_ERROR*()
	to prepare for uprobes fixes)
Message-ID: <20140513171148.GA12123@redhat.com>
References: <20140508191140.GA16892@redhat.com> <20140509140723.GA22532@redhat.com> <5371B6AA.7060508@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5371B6AA.7060508@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Masami Hiramatsu wrote:
>
> (2014/05/09 23:07), Oleg Nesterov wrote:
> > On 05/08, Oleg Nesterov wrote:
> >>
> >> For example, after this series
> >> we can convert math_error() into the "normal" DO_ERROR() user, and most probably
> >> we can do the same with do_general_protection().
> >
> > As for do_general_protection(), the problem is DIE_GPF.
> >
> > Masami, could you explain why it is needed ? kprobe_exceptions_notify()
> > is the only user, can't it use DIE_TRAP and check trapnr = X86_TRAP_GP ?
>
> Actually, this may be only for something which will happen on
> single-stepping out-of-line. And yes, I can move it onto the DIE_TRAP :)
>
> >
> > And if it can, probably we can do notify_die() at the start like other
> > DO_ERROR() functions do ?
>
> Agreed, it seems OK to me. (and seems better, since we can handle GPF
> before changing task->thread struct)
>
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Great, thanks!

I'll resend this patch with the changelog and other changes.

Oleg.

