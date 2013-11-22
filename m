Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3KVPBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 10:01:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47756 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3KVPBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 10:01:15 -0500
Date: Fri, 22 Nov 2013 12:00:55 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131122150055.GC11305@ghostprotocols.net>
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
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 22, 2013 at 02:50:34PM +0100, Borislav Petkov escreveu:
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
> 
> cmdline is parse-options.c.
> 
> IOW, that's splitting it into too granulary pieces with 1-2 compilation
> units ber library.

Lets do one at a time, so far we agreed that the ones that involves
parsing procfs/sysfs etc should go in tools/lib/(fs)?kapi, so lets do
that one.
 
> And what if there are interdependencies between the stuff split this
> way? That could become very painful and unnecessary.
 
> So having a simple single library which includes generic stuff needed to
> interface with the kernel is much simpler and sane, IMHO.
 
> And, since we're keeping it internal, we can do the split the other way
> around instead - first do the single generic library and then carve out
> a certain subset of functionality if/when it makes sense.
 
> The same approach we can use for the name - first split and work with it
> and change stuff when the need for it arises.
 
> > I'd also not expose any of this externally but straight link it into
> > the individual utilities - that way it does not matter that it's a
> > nice, topical, fine-grained set of functionality.
> >
> > I don't think we are ready for (nor do we want the overhead of)
> > maintaining a library ABI at this stage.
> >
> > Once things slow down and it's all so robust that we've had at most
> > a handful of commits in tools/lib/ in a full year we can think about
> > exporting it, maybe ...
> 
> Right.

yeah.
