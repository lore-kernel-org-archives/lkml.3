Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbaGSJvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 05:51:13 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:49619 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819AbaGSJvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 05:51:09 -0400
Date: Sat, 19 Jul 2014 11:51:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 09/13] perf tools: Add perf download to download event
 files
Message-ID: <20140719095104.GA11994@gmail.com>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
 <1405540969-18975-10-git-send-email-jolsa@kernel.org>
 <20140717104704.GB9571@gmail.com>
 <87ha2e4lj4.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ha2e4lj4.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@kernel.org> writes:
> >
> > We want these description files to be in the perf source code, 
> > somewhere in tools/perf/live-config/arch/x86/ or so, and installed 
> > during 'make install' - i.e. part of perf project and installed in 
> > ~/.debug or ~/.perf or so.
> 
> I don't think that's a good idea. It would recreate all the 
> problems oprofile has with out of date event lists. Already
> proven to not work well.

That's true only if you ignore my second suggestion:

> > Those files could be refreshed via 'perf download' and could be 
> > accessible via kernel.org as well, 'perf download' should pick up 
> > these files from Linus's latest git repository (via the HTTP 
> > namespace).
> 
> I have doubts a gitweb server is a good way to distribute 
> potentially high volume / high access data.

I don't buy that concern either, because typically humans will trigger 
the refresh - just like clicking on a link to refresh. In any case, if 
it starts being a problem in practice we can reconsider, it's not a 
reason to not do it.

> However getting a more neutral space is fine.
> 
> It would be fine to put it elsewhere on kernel.org.
> I can ask for a space.

The beauty of my approach is to:

 1) integrate the descriptions into the project, so that developers 
    are well aware of them and keep them uptodate - while considering 
    all the other perf features the kernel may offer.

 2) have them update automatically as we update the primary source, in 
    a single place.

Your suggestions so far lose those benefits, unnecessarily, and 
without explanation given.

So unless you can come up with a better approach, this is the way to 
implement this feature.

Thanks,

	Ingo
