Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3KVNu1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 08:50:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43138 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490Ab3KVNu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 08:50:26 -0500
Date: Fri, 22 Nov 2013 14:50:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131122135034.GA20146@nazgul.tnic>
References: <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
 <20131121150524.GA24806@ghostprotocols.net>
 <20131121152804.GI26009@pd.tnic>
 <20131121173714.GD24806@ghostprotocols.net>
 <20131122122701.GA1480@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131122122701.GA1480@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 01:27:01PM +0100, Ingo Molnar wrote:
> I don't think those other bits should go into this library. rbtree
> should go into lib/rbtree/, command-line bits into lib/cmdline/, build
> system helpers into lib/build/, etc.
>
> Merging unrelated things into a single library is a user-space disease
> we need not repeat.

Well, rbtree is basically rblist.c and the rbtree*.h headers which
simply wrap the kernel headers.

cmdline is parse-options.c.

IOW, that's splitting it into too granulary pieces with 1-2 compilation
units ber library.

And what if there are interdependencies between the stuff split this
way? That could become very painful and unnecessary.

So having a simple single library which includes generic stuff needed to
interface with the kernel is much simpler and sane, IMHO.

And, since we're keeping it internal, we can do the split the other way
around instead - first do the single generic library and then carve out
a certain subset of functionality if/when it makes sense.

The same approach we can use for the name - first split and work with it
and change stuff when the need for it arises.

> I'd also not expose any of this externally but straight link it into
> the individual utilities - that way it does not matter that it's a
> nice, topical, fine-grained set of functionality.
>
> I don't think we are ready for (nor do we want the overhead of)
> maintaining a library ABI at this stage.
>
> Once things slow down and it's all so robust that we've had at most
> a handful of commits in tools/lib/ in a full year we can think about
> exporting it, maybe ...

Right.
