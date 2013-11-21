Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3KURhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:37:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53696 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab3KURhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:37:32 -0500
Date: Thu, 21 Nov 2013 14:37:14 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121173714.GD24806@ghostprotocols.net>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
 <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
 <20131121150524.GA24806@ghostprotocols.net>
 <20131121152804.GI26009@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121152804.GI26009@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 21, 2013 at 04:28:04PM +0100, Borislav Petkov escreveu:
> On Thu, Nov 21, 2013 at 12:05:24PM -0300, Arnaldo Carvalho de Melo wrote:
> > "To offers various helper methods to interface with the Linux kernel:
> >  debugfs, procfs, sysfs handling routines with no policy, just pure,
> >  obvious helpers to use kernel functionality."
 
> Exactly.
 
> > Naming is a bit hard, to keep it small, descriptive, as API can lead
> > people to think about other kinds of kernel APIs (syscalls?), "fskapi"
> > to mean "fs based kernel API" would perhaps be more descriptive? A
> > longer (more descriptive) possibility would be "linux-fskapi".
 
> Yeah, you can't have fskapi because we'll add other stuff to it (see
> the diffstat I sent you last week) so not filesystem stuff only. So I
> think "kapi" is as generic and as fitting as it gets. We can use the
> "kernel-api" variant but I think the "k" is enough.

I think is that it is too generic, the other stuff you mention is not
really "kapi" at all.

The rest, things like util.c, usage.c, rbtree.c, hash, strlist, etc are
all, well, utilities that we got from the kernel, from git, or that were
created for perf, could get a tools/lib/util/ generic name and be
outside the one with the description agreed above.

But they are not "helper methods to interface with the Linux kernel" at
all.

If "libc" is the "library that comes with the C language" we could have
liblk for the "library that came from the Linux kernel".

But "libkapi" seems the wrong name for a library with those utilities :-\

- Arnaldo
