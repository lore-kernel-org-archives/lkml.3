Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaIPVW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:22:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046AbaIPVWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:22:53 -0400
Date: Tue, 16 Sep 2014 23:22:50 +0200
From: Jan Kara <jack@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] printk: git rid of [sched_delayed] message for
 printk_deferred
Message-ID: <20140916212250.GI1205@quack.suse.cz>
References: <20140914050905.GA296@x4>
 <20140914055450.GB296@x4>
 <CAMuHMdUmqvN3GZzfjjHc5W2Dxgx2b0gzVHFUR8P8yUs5iFt_tA@mail.gmail.com>
 <20140915163740.GA12408@x4>
 <20140916105547.GA1205@quack.suse.cz>
 <20140916144252.GB32118@x4>
 <20140916111331.14303381@gandalf.local.home>
 <20140916203510.GF1205@quack.suse.cz>
 <20140916170709.73ef2993@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140916170709.73ef2993@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16-09-14 17:07:09, Steven Rostedt wrote:
> On Tue, 16 Sep 2014 22:35:10 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > On Tue 16-09-14 11:13:31, Steven Rostedt wrote:
> > > On Tue, 16 Sep 2014 16:42:52 +0200
> > > Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> > > 
> > > > commit 458df9fd hardcodes printk_deferred() to KERN_WARNING and inserts
> > > > the string "[sched_delayed] " before the actual message.
> > > > However it doesn't take into account the KERN_* prefix of the message,
> > > > that now ends up in the middle of the output:
> > > > 
> > > >  [sched_delayed] ^a4CE: hpet increased min_delta_ns to 20115 nsec
> > > > 
> > > > Fix this by just getting rid of the "[sched_delayed] " scnprintf().
> > > 
> > > I prefer the "[sched_delayed]" output. It lets us know that the output
> > > did not come out immediately, which is important sometimes during
> > > debugging. Otherwise it can confuse people, as printk is suppose to be
> > > a blocking write.
> >   This is a common misconception about printk. It isn't a blocking write
> > for ten years or more. If there happens to be someone else printing to
> > console, the difference between printk() and printk_deferred() is
> > marginal - it used to be bigger when scheduler had its own buffer but these
> > days message is inserted in the kernel ring buffer immediately. That's why
> > I don't think the prefix is useful anymore.
> 
> For the most part it's a blocking write. Yeah, if another CPU is
> writing, it wont be a blocking write, but it usually is, I know I
> depend on it (when I'm debugging, I usually don't have contention
> between CPUs). The important part is that they are done in order. A
> delayed print, wont be in order with other printks. That is still a
> crucial difference.
  printk_deffered() will be in order with other printks after your commit
458df9fd4815b47809875d57f42e16401674b621. Just printing to console itself
will be delayed to the next timer interrupt. Or am I missing something?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
