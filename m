Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934007Ab3CHNPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 08:15:40 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:2750 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932120Ab3CHNPi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 08:15:38 -0500
From: <oskar.andero@sonymobile.com>
Date: Fri, 8 Mar 2013 14:15:35 +0100
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>,
        =?iso-8859-1?Q?Davidsson=2C_Bj=F6rn?= 
	<Bjorn.Davidsson@sonymobile.com>
Subject: Re: [PATCH] Kprobes blacklist: Conditionally add x86-specific symbols
Message-ID: <20130308131534.GI26148@caracas.corpusers.net>
References: <1362653070-24035-1-git-send-email-oskar.andero@sonymobile.com>
 <513967BD.9010602@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <513967BD.9010602@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05:23 Fri 08 Mar     , Masami Hiramatsu wrote:
> (2013/03/07 19:44), oskar.andero@sonymobile.com wrote:
> > From: Bjorn Davidsson <bjorn.davidsson@sonymobile.com>
> > 
> > The kprobes blacklist contains x86-specific symbols.
> > Looking for these in kallsyms takes unnecessary time
> > during startup on non-X86 platform.
> > Added #ifdef CONFIG_X86 around them.
> 
> Right. however, it might be better break that into
> common and arch-specific lists, because there may be
> other arch-specific non-probe-able functions on each
> architecture...

Ok. You mean adding, for instance, a kprobe_blacklist_arch[] in arch/x86
somewhere or did you have something else in mind? I guess we preferably want
to get rid of the #ifdef.

> Would you know some other black points on your platform?

Not that we are aware of.

> Thank you,
> 
> > 
> > Reviewed-by: Radovan Lekanovic <radovan.lekanovic@sonymobile.com>
> > Signed-off-by: Björn Davidsson <bjorn.davidsson@sonymobile.com>
> > Signed-off-by: Oskar Andero <oskar.andero@sonymobile.com>
> > ---
> >  kernel/kprobes.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> > index e35be53..8c3796f 100644
> > --- a/kernel/kprobes.c
> > +++ b/kernel/kprobes.c
> > @@ -95,9 +95,11 @@ static raw_spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
> >   */
> >  static struct kprobe_blackpoint kprobe_blacklist[] = {
> >  	{"preempt_schedule",},
> > +#ifdef CONFIG_X86
> >  	{"native_get_debugreg",},
> >  	{"irq_entries_start",},
> >  	{"common_interrupt",},
> > +#endif
> >  	{"mcount",},	/* mcount can be called from everywhere */
> >  	{NULL}    /* Terminator */
> >  };
> > 
> 
> 
> -- 
> Masami HIRAMATSU
> IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
> 
> 

-Oskar
