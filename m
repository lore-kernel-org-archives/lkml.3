Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3KUNuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 08:50:00 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50065 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab3KUNt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 08:49:57 -0500
Date: Thu, 21 Nov 2013 14:49:49 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>
Subject: Re: [PATCH] perf: Move fs.* to generic lib/lk/
Message-ID: <20131121134949.GE26009@pd.tnic>
References: <1384984585-24300-1-git-send-email-bp@alien8.de>
 <20131121073410.GA16971@gmail.com>
 <20131121100722.GA25459@pd.tnic>
 <20131121111744.GA27513@gmail.com>
 <20131121113014.GA26009@pd.tnic>
 <20131121114224.GA27704@gmail.com>
 <20131121120605.GC26009@pd.tnic>
 <20131121123954.GA8044@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131121123954.GA8044@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 07:39:55AM -0500, Steven Rostedt wrote:
> Should we put libtraceevent here too? Have all kapi functionality live
> here?
>
> As libtraceevent is getting mature, we need to get it out as a real
> library soon. There is already three utilities that use it: perf,
> trace-cmd and powertop. And I've heard of others that want that
> functionatity.

Right, my intention was to have topic libraries like libtraceevent,
libkapi and libperfevent (this is the one that's following by exporting
evlist/evsel to other tools).

But I certainly see your angle of lumping *all* kernel-related
functionality together in one lib.

I dunno, I feel like leaving them split for now is better. Why? Not
polluting namespaces unnecessarily and why would tools who don't need
tracing functionality link against it.

Anyway, arguments can be made for both, but I personally prefer leaving
them separate. Unless there's a really compelling reason to have a
single lib - a reason which I cannot think of right now...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
