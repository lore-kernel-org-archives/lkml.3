Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab3KVPjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:39:15 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:50821 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab3KVPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:39:14 -0500
Date: Fri, 22 Nov 2013 16:39:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131122153910.GA15636@gmail.com>
References: <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
 <20131121150524.GA24806@ghostprotocols.net>
 <20131121152804.GI26009@pd.tnic>
 <20131121173714.GD24806@ghostprotocols.net>
 <20131122122701.GA1480@gmail.com>
 <20131122135034.GA20146@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122135034.GA20146@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Fri, Nov 22, 2013 at 01:27:01PM +0100, Ingo Molnar wrote:
> > I don't think those other bits should go into this library. rbtree
> > should go into lib/rbtree/, command-line bits into lib/cmdline/, build
> > system helpers into lib/build/, etc.
> >
> > Merging unrelated things into a single library is a user-space disease
> > we need not repeat.
> 
> Well, rbtree is basically rblist.c and the rbtree*.h headers which 
> simply wrap the kernel headers.

Yes - with some details and a nice, includable .h file that userspace 
tooling can utilize.

> cmdline is parse-options.c.
> 
> IOW, that's splitting it into too granulary pieces with 1-2 
> compilation units ber library.

I see no problem with that - it's basically like util/*.c is, just 
between tools.

> And what if there are interdependencies between the stuff split this 
> way? That could become very painful and unnecessary.

What dependencies do you mean? The only constraint is to not make it 
circular - but that's easy to do if they are nicely separated per 
concept. I don't think rbtree.h ever wants to include cmdline 
processing or debugfs processing.

> So having a simple single library which includes generic stuff 
> needed to interface with the kernel is much simpler and sane, IMHO.

For userspace and for kernel space subsystems a single .h file per 
separate concept works the best. That is why we have a separate 
rbtree.h, list.h, slab.h, etc.

> And, since we're keeping it internal, we can do the split the other 
> way around instead - first do the single generic library and then 
> carve out a certain subset of functionality if/when it makes sense.

Why?

> The same approach we can use for the name - first split and work 
> with it and change stuff when the need for it arises.
> 
> > I'd also not expose any of this externally but straight link it 
> > into the individual utilities - that way it does not matter that 
> > it's a nice, topical, fine-grained set of functionality.
> >
> > I don't think we are ready for (nor do we want the overhead of) 
> > maintaining a library ABI at this stage.
> >
> > Once things slow down and it's all so robust that we've had at 
> > most a handful of commits in tools/lib/ in a full year we can 
> > think about exporting it, maybe ...
> 
> Right.

Hey, that's an important point of agreement! :-)

Thanks,

	Ingo
