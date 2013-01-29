Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3A2KyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 05:54:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab3A2Kx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 05:53:58 -0500
Date: Tue, 29 Jan 2013 11:53:38 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/8] perf tools: Add '.' as part of the event 'name' token
Message-ID: <20130129105338.GD1186@krava.brq.redhat.com>
References: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
 <1359230650-10415-2-git-send-email-jolsa@redhat.com>
 <CABPqkBSH=67hG8VRwHPU3byEancpVqsyetHkSjb4nOScPvcnFA@mail.gmail.com>
 <CABPqkBTPHKf+XTmeyA8PrWReG8Ak6ow9gSwfh4ozK+gvJMze1w@mail.gmail.com>
 <20130129080305.GB594@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129080305.GB594@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 09:03:05AM +0100, Ingo Molnar wrote:
> 
> * Stephane Eranian <eranian@google.com> wrote:
> 
> > On Mon, Jan 28, 2013 at 9:52 PM, Stephane Eranian <eranian@google.com> wrote:
> > > Jiri,
> > >
> > > I don't see part 0/8 of this series. Did you send it to me too?

oops, it went to lkml only, here it is:
http://marc.info/?l=linux-kernel&m=135923067520675&w=2

> > >
> > > I have some comments about it. I don't see why create something from scratch
> > > when I have been developing a library (libpfm4) that takes care of that and that
> > > is already used by many tool developers. That library can be linked with perf
> > > and provide full symbolic events + all the modifiers. The library is portable
> > > and supports all existing archs. It can also be used by self-monitoring apps.
> > >
> > >
> > > You're introducing yet another event table to maintain. And believe me this is
> > > a lot of work to maintain this.
> > >
> > > I don't understand why not use this existing library.
> > >
> >
> > I meant to add that I think it would be more productive if we 
> > (you and I) were to work on the library to extend it with 
> > external text-based event tables that could be used by perf 
> > either directly or thru the libpfm4 interface.
> 
> perf is intentionally external file free and does not 
> (fundamentally) depend on external libraries either,
> other than core system libraries.
> 
> There are several advantages to that:
> 
>  - there is no version skew and no design/maintenance friction
> 
>  - 'upgrading' perf between similar boxes is as simple as
>    copying the perf binary
> 
>  - it's self-sufficient
> 
>  - there's no real advantage of external text files versus
>    internal text files (i.e. text tables within the source 
>    code), while there are several disadvantages

When you say 'internal'.. do you mean like inside binary internal?

Currently this file gets installed with perf and is loaded in run
time based on the detected architecture.

> 
> So as long as Jiri is happy to maintain these tables I think 
> it's a superior solution (even if the tables start out 
> incomplete), from the perf project's perspective.

Actually what I did here was that I wrote a tool that sucked
and get all the events from libpfm4 in the alias perf format.

It took some libpfm4 changes as well, so I did not post the
tool source. But given that libpfm4 is not going in perf, this
might be answer.. having tool to keep us in sync with libpfm4
and run it once in a while.. ;-)

jirka
