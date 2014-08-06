Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaHFBQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:16:23 -0400
Received: from ozlabs.org ([103.22.144.67]:43823 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaHFBQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:16:22 -0400
Message-ID: <1407287780.32238.3.camel@concordia>
Subject: Re: [PATCH 09/13] perf tools: Add perf download to download event
 files
From: Michael Ellerman <mpe@ellerman.id.au>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Date: Wed, 06 Aug 2014 11:16:20 +1000
In-Reply-To: <20140719095104.GA11994@gmail.com>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
	 <1405540969-18975-10-git-send-email-jolsa@kernel.org>
	 <20140717104704.GB9571@gmail.com> <87ha2e4lj4.fsf@tassilo.jf.intel.com>
	 <20140719095104.GA11994@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-07-19 at 11:51 +0200, Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Ingo Molnar <mingo@kernel.org> writes:
> > >
> > > We want these description files to be in the perf source code, 
> > > somewhere in tools/perf/live-config/arch/x86/ or so, and installed 
> > > during 'make install' - i.e. part of perf project and installed in 
> > > ~/.debug or ~/.perf or so.
> > 
> > I don't think that's a good idea. It would recreate all the 
> > problems oprofile has with out of date event lists. Already
> > proven to not work well.
> 
> That's true only if you ignore my second suggestion:
> 
> > > Those files could be refreshed via 'perf download' and could be 
> > > accessible via kernel.org as well, 'perf download' should pick up 
> > > these files from Linus's latest git repository (via the HTTP 
> > > namespace).
> > 
> > I have doubts a gitweb server is a good way to distribute 
> > potentially high volume / high access data.
> 
> I don't buy that concern either, because typically humans will trigger 
> the refresh - just like clicking on a link to refresh. In any case, if 
> it starts being a problem in practice we can reconsider, it's not a 
> reason to not do it.
> 
> > However getting a more neutral space is fine.
> > 
> > It would be fine to put it elsewhere on kernel.org.
> > I can ask for a space.
> 
> The beauty of my approach is to:
> 
>  1) integrate the descriptions into the project, so that developers 
>     are well aware of them and keep them uptodate - while considering 
>     all the other perf features the kernel may offer.
> 
>  2) have them update automatically as we update the primary source, in 
>     a single place.

Another benefit of having the events installed as part of perf is that they are
usable on machines that don't have access to the internet.

Even if some of the event descriptions are out of date, that is still
preferable to having no events on such machines.

cheers


