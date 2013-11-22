Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab3KVM1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:27:09 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:57414 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab3KVM1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:27:06 -0500
Date: Fri, 22 Nov 2013 13:27:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131122122701.GA1480@gmail.com>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
 <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
 <20131121150524.GA24806@ghostprotocols.net>
 <20131121152804.GI26009@pd.tnic>
 <20131121173714.GD24806@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121173714.GD24806@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@infradead.org> wrote:

> Em Thu, Nov 21, 2013 at 04:28:04PM +0100, Borislav Petkov escreveu:
> > On Thu, Nov 21, 2013 at 12:05:24PM -0300, Arnaldo Carvalho de Melo wrote:
> > > "To offers various helper methods to interface with the Linux kernel:
> > >  debugfs, procfs, sysfs handling routines with no policy, just pure,
> > >  obvious helpers to use kernel functionality."
>  
> > Exactly.
>  
> > > Naming is a bit hard, to keep it small, descriptive, as API can lead
> > > people to think about other kinds of kernel APIs (syscalls?), "fskapi"
> > > to mean "fs based kernel API" would perhaps be more descriptive? A
> > > longer (more descriptive) possibility would be "linux-fskapi".
>  
> > Yeah, you can't have fskapi because we'll add other stuff to it 
> > (see the diffstat I sent you last week) so not filesystem stuff 
> > only. So I think "kapi" is as generic and as fitting as it gets. 
> > We can use the "kernel-api" variant but I think the "k" is enough.
> 
> I think is that it is too generic, the other stuff you mention is 
> not really "kapi" at all.
> 
> The rest, things like util.c, usage.c, rbtree.c, hash, strlist, etc 
> are all, well, utilities that we got from the kernel, from git, or 
> that were created for perf, could get a tools/lib/util/ generic name 
> and be outside the one with the description agreed above.
> 
> But they are not "helper methods to interface with the Linux kernel" 
> at all.

I don't think those other bits should go into this library. rbtree 
should go into lib/rbtree/, command-line bits into lib/cmdline/, build 
system helpers into lib/build/, etc.

Merging unrelated things into a single library is a user-space disease 
we need not repeat.

I'd also not expose any of this externally but straight link it into 
the individual utilities - that way it does not matter that it's a 
nice, topical, fine-grained set of functionality.

I don't think we are ready for (nor do we want the overhead of) 
maintaining a library ABI at this stage.

Once things slow down and it's all so robust that we've had at most a 
handful of commits in tools/lib/ in a full year we can think about 
exporting it, maybe ...

Thanks,

	Ingo
