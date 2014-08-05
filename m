Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaHENdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 09:33:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:39180 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbaHENdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 09:33:53 -0400
Date: Tue, 5 Aug 2014 10:33:47 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 05/33] perf record: Allow the user to disable time stamps
Message-ID: <20140805133347.GH13375@kernel.org>
References: <1407169064-25625-1-git-send-email-acme@kernel.org>
 <1407169064-25625-6-git-send-email-acme@kernel.org>
 <20140805060856.GA9453@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805060856.GA9453@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 05, 2014 at 08:08:56AM +0200, Ingo Molnar escreveu:
> * Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> > From: Andi Kleen <ak@linux.intel.com>
 
> This patch looks dangerous and misleading to me.

I took it more from the angle: hey, it fixes a regression, i.e.
-T/--time somehow became a noop, and also it doesn't change any default.

It also states that you will get misaccounting, why that would happen,
althought wording could've been better, as mmaps won't be "missing",
i.e. they will be there as this governs just PERF_SAMPLE_TIME, not
perf_event_attr.mmap, so it MMAPs may come after samples for its maps.

So, I took it.

How should we proceed?

- Arnaldo
 
> > Time stamps are always implicitely enabled for record currently.  The
> > old --time/-T option is a nop.
> > 
> > Allow the user to disable timestamps by using --no-time
> > 
> > This can cause some minor misaccounting (by missing mmaps), but
> > significantly lowers the size of perf.data
> 
> I'm not any big change in size:
> 
>  -rw------- 1 mingo mingo 384768 Aug  5 08:01 perf.data.timestamps
>  -rw------- 1 mingo mingo 336952 Aug  5 08:00 perf.data.notimestamps
> 
> That's a ~14% reduction - it's certainly noticeable but not 
> earth-shattering.

I wonder if this is for things like intel PT or some other super high
volume scenario where 14% indeed looks like huge, but then not using
PERF_SAMPLE_TIME there may have implications, but then, this is one of
those use-only-if-you-know-what-are-the-implications knob, where the
default is the sane one.
 
> And what is called 'minor misaccounting' in the description is 
> actually a potentially broken profile that people might rely on.
> 
> So the patch description misleads twice: by exaggerating the 
> advantages and also by downplaying the disadvantages.
> 
> So either remove the --time option altogether, or fix its 
> 'misaccounting' so that the profile can be relied on.
> 
> Thanks,
> 
> 	Ingo
