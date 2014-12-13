Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030876AbaLMNSr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 08:18:47 -0500
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:54638 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933281AbaLMNSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 08:18:45 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2198:2199:2393:2525:2553:2560:2563:2682:2685:2693:2859:2902:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3167:3354:3622:3865:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6119:6120:6261:6742:7875:7903:8599:8660:8957:9025:10004:10400:10848:10967:11026:11232:11658:11914:12043:12291:12296:12517:12519:12555:12683:12740:12783:13148:13230:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: offer97_6930a18b4b41a
X-Filterd-Recvd-Size: 3884
Date: Sat, 13 Dec 2014 08:18:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tony Luck <tony.luck@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <marc.zyngier@arm.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH 2/2] tracing: Add tracepoint_printk cmdline
Message-ID: <20141213081832.05cb4e6b@gandalf.local.home>
In-Reply-To: <20141213105925.GB29934@pd.tnic>
References: <alpine.DEB.2.11.1412121539300.16494@nanos>
	<20141212181420.47100d5c@gandalf.local.home>
	<20141213004830.792da019@gandalf.local.home>
	<20141213005037.78eca245@gandalf.local.home>
	<20141213105925.GB29934@pd.tnic>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2014 11:59:25 +0100
Borislav Petkov <bp@alien8.de> wrote:

> On Sat, Dec 13, 2014 at 12:50:37AM -0500, Steven Rostedt wrote:
> > 
> > Add the kernel command line tracepoint_printk option that will
> > have tracepoints that are active sent to printk().
> > 
> > Passing "tracepoint_printk" will activate this. To turn it off
> > the sysctl /proc/sys/kernel/tracepoint_printk can have '0' echoed
> > into it. Note, this only works if the cmdline option is used.
> > Echoing 1 into the sysctl file without the cmdline option will
> > have no affect.
> > 
> > Note, this is a dangerous option. Having high frequency
> > tracepoints send their data to printk() can possibly cause
> > a live lock.
> > 
> > Link: http://lkml.kernel.org/r/alpine.DEB.2.11.1412121539300.16494@nanos
> > 
> > Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  Documentation/kernel-parameters.txt | 18 ++++++++++++++++++
> >  include/linux/ftrace.h              |  1 +
> >  kernel/sysctl.c                     |  7 +++++++
> >  kernel/trace/trace.c                | 17 +++++++++++++++++
> >  kernel/trace/trace.h                |  1 +
> >  kernel/trace/trace_events.c         | 32 ++++++++++++++++++++++++++++++++
> >  6 files changed, 76 insertions(+)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index 1d09eb37c562..d81f464a7358 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -3500,6 +3500,24 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  			See also Documentation/trace/ftrace.txt "trace options"
> >  			section.
> >  
> > +	tracepoint_printk[FTRACE]
> 
> Damn, this is long and most likely nasty to type on some dingy box when
> you're trying to debug stuff. Can we shorten it?
> 
> trace_printk

No this is already taken.

> tp_printk

Actually, I was thinking about shortening it to tp_printk.

> tp_print
> tp_pr
> ...
> 
> Last one is my favourite - we should call it ToiletPaper_Print :-)

What you need when your kernel is in the crapper.

-- Steve

> 
> > +			Have the tracepoints sent to printk as well as the
> > +			tracing ring buffer. This is useful for early boot up
> > +			where the system hangs or reboots and does not give the
> > +			option for reading the tracing buffer or performing a
> > +			ftrace_dump_on_oops.
> 

