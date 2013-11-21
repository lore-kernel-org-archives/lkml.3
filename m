Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3KUPU5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 10:20:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50183 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab3KUPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 10:20:56 -0500
Date: Thu, 21 Nov 2013 12:12:58 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121151258.GB24806@ghostprotocols.net>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
 <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
 <20131121123954.GA8044@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121123954.GA8044@home.goodmis.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 21, 2013 at 07:39:55AM -0500, Steven Rostedt escreveu:
> On Thu, Nov 21, 2013 at 01:06:05PM +0100, Borislav Petkov wrote:
> > No, I absolutely don't think it is a bikeshedding exercise too. We
> > really need that lib because people have started growing their own
> > facilities in tools/ and outside so having a lib which implements
> > generic functionality for interfacing with the kernel right is going to
> > save everyone a lot of time and energy.
 
> Should we put libtraceevent here too? Have all kapi functionality live here?

Don't know, what I'm liking about this discussion now is that we're
focusing on breaking it down into multiple libraries.

So at some point, symbol resolution, that involves parsing multiple "fs
based kernel api" (/proc/{kallsyms,modules,etc), but should not be in
the library being discussed now, will be another tools/perf/util/
"spin-off", that, again, focuses on a clear mission statement and is
useful for multiple /usr/src/linux/tools/ "clients".

And as the first step, only tools/ clients would be targeted, as we
would have some time to do changes that touches the libraries _and_ all
its users, just like we can do with kernel APIs and its users, i.e.
drivers, etc.

Only at a later stage, when those libraries are boringly mature, we
would export them for wider use.
 
> As libtraceevent is getting mature, we need to get it out as a real library
> soon. There is already three utilities that use it: perf, trace-cmd and 
> powertop. And I've heard of others that want that functionatity.
> 
> -- Steve
