Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3DUQqj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 12:46:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab3DUQqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 12:46:38 -0400
Date: Sun, 21 Apr 2013 18:43:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] perf: Add hardware breakpoint address mask
Message-ID: <20130421164333.GA5328@redhat.com>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com> <1365528113-5458-2-git-send-email-jacob.shin@amd.com> <20130420162223.GA13393@redhat.com> <20130420214632.GA6155@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130420214632.GA6155@jshin-Toonie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20, Jacob Shin wrote:
>
> On Sat, Apr 20, 2013 at 06:22:23PM +0200, Oleg Nesterov wrote:
> > On 04/09, Jacob Shin wrote:
> > >
> > > @@ -612,6 +612,9 @@ static int hw_breakpoint_add(struct perf_event *bp, int flags)
> > >  	if (!(flags & PERF_EF_START))
> > >  		bp->hw.state = PERF_HES_STOPPED;
> > >
> > > +	if (bp->attr.bp_addr_mask && !arch_has_hw_breakpoint_addr_mask())
> > > +		return -EOPNOTSUPP;
> > > +
> >
> > This is called by sched_in... Isn't it "too late" ?
> >
> > Perhaps arch_validate_hwbkpt_settings() should validate mask/cpu_has_bpext?
>
> Ah, yes okay. Should I do this for all the archs that HAVE_HW_BREAKPOINT ?
>
> Or is creating HAVE_HW_BREAKPOINT_ADDR_MASK and in validate_hw_breakpoint:
>
>   #ifndef HAVE_HW_BREAKPOINT_ADDR_MASK
>   if (bp->attr.bp_addr_mask)
>   	return -EOPNOTSUPP;
>   #endif

Or a __weak function overridden in amd.c. I do not know what would be
better, up to you.

Hmm. But this patch already defines arch_has_hw_breakpoint_addr_mask()
for any arch, so validate_hw_breakpoint() can just use it?

Oleg.

