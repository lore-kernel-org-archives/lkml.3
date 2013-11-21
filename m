Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3KULm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:42:29 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:33423 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3KULm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:42:28 -0500
Date: Thu, 21 Nov 2013 12:42:24 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121114224.GA27704@gmail.com>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
 <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121113014.GA26009@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Thu, Nov 21, 2013 at 12:17:44PM +0100, Ingo Molnar wrote:
> > > However, now that I think of it, the naming is kinda imprecise 
> > > having only "kernel" in it - it only denotes that it is a library of 
> > > stuff that has grown in the kernel.
> > > 
> > > So how about
> > > 
> > > tools/lib/ktools/
> > > tools/lib/kutils/
> > > tools/lib/kernel-tools/
> > > tools/lib/kernel-utils/
> > > ...
> > > 
> > > and
> > > 
> > > libktools.so
> > > libkutils.so
> > > ...
> > > 
> > > ?
> > > 
> > > I'd prefer ktools as in the tools/ directory of the kernel repo.
> > 
> > So what does each name mean, what would they be used for and what's 
> > the difference between them?
> 
> Oh no, I'm only proposing multiple libraries but multiple names to 
> choose *only* *one* from them - the one which we think fits best.
> 
> Basically I wanna say: "this is the library of tools which grew in 
> the tools/ directory of the kernel repo".
> 
> Thus I'm proposing
> 
> 	tools/lib/ktools/
> 
> as a path and
> 
> 	libktools.so
> 
> as a library name, because, IMHO, this name is closer to the reality.
>
> tools/lib/kernel/ is also ok - it does not describe the collection 
> of functionality that precisely, IMHO, that's all.
> 
> Am I even making sense here?

Ok - so why not call it tools/lib/kernel/ or tools/lib/kernelapi/ or 
tools/lib/kapi/?

That's really what is common about it: it offers various helper 
methods to interface with the Linux kernel: debugfs, procfs, sysfs 
handling routines with no policy, just pure, obvious helpers to use 
kernel functionality.

[ Naming it 'ktools' is not optimal because these are already tools/ 
  ... the secondary meaning of 'tools' in that context is easily lost. 
  Same goes for 'kutils', the secondary meaning is confusing (to me). ]

... and just in case you are wondering why I'm making a fuss about it: 
a naming discussion for something fundamental as this isn't bikeshed 
painting, we really want people to look at that place to readily stuff 
kernel related helpers into, and the name should make that very 
obvious.

Thanks,

	Ingo
