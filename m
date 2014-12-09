Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbaLILGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:06:21 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61781 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732AbaLILGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:06:19 -0500
Date: Tue, 9 Dec 2014 12:06:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vince@deater.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Linux 3.18 released
Message-ID: <20141209110614.GA24745@gmail.com>
References: <CA+55aFwK3XtS32iJna-2uXZUfZQNUGC0Z4FmEFHK4JXB_kyojA@mail.gmail.com>
 <alpine.DEB.2.10.1412081331580.28373@pianoman.cluster.toy>
 <20141209101825.GA18294@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209101825.GA18294@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Vince Weaver <vince@deater.net> wrote:
> 
> > On Sun, 7 Dec 2014, Linus Torvalds wrote:
> > 
> > > I'd love to say that we've figured out the problem that 
> > > plagues 3.17 for a couple of people, but we haven't. At the 
> > > same time, there's absolutely no point in having everybody 
> > > else twiddling their thumbs when a couple of people are 
> > > actively trying to bisect an older issue, so holding up the 
> > > release just didn't make sense. Especially since that would 
> > > just have then held things up entirely over the holiday 
> > > break.
> > > 
> > > So the merge window for 3.19 is open, and DaveJ will 
> > > hopefully get his bisection done (or at least narrow things 
> > > down sufficiently that we have that "Ahaa" moment) over the 
> > > next week. But in solidarity with Dave (and to make my life 
> > > easier too ;) let's try to avoid introducing any _new_ 
> > > nasty issues, ok?
> > 
> > It's probably unrelated to DaveJ's issue, but my perf_event 
> > fuzzer still quickly locks the kernel pretty solid on 3.18.
> 
> I'm really tempted to restrict most of the weirder perf ABI 
> details (such as event groups, raw events, etc.) to root only 
> (with a perf_event_paranoid level to make it available for 
> power users and distros so inclined) - most of the past 
> lockups/races you have triggered were in such weird, seldom 
> used corners of the perf ABI that doesn't get much testing 
> outside Trinity fuzzing.
> 
> The bits used by tools/perf and used by the majority of users 
> are generally rock solid.

Note that it's entirely possible that I'm wrong about that 
suspicion, that the leftover bug(s?) are still in the core 
portion of perf.

Maybe fuzzing could help there: initially only fuzz core portions 
of perf ABI (bits that things like tools/perf uses on an everyday 
basis), then the rarer bits? If we knew it that it's say the 
cgroups bits or tracepoint integration of perf that is causing 
the trouble, that would already narrow down the inquiry quite a 
bit.

> Doing that is not a fix obviously and we'd like to fix all 
> pending bugs for real as well, but would at least isolate the 
> impact to root-only until it's fixed.

Thanks,

	Ingo
