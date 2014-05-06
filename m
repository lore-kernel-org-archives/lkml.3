Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357AbaEFID5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:03:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934240AbaEFIDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:03:51 -0400
Date: Tue, 6 May 2014 10:03:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@kernel.org>
cc: David Lang <david@lang.hm>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
In-Reply-To: <20140506073228.GA26271@gmail.com>
Message-ID: <alpine.LNX.2.00.1405060955180.3969@pobox.suse.cz>
References: <cover.1398958771.git.jpoimboe@redhat.com> <alpine.LRH.2.00.1405021504320.22053@twin.jikos.cz> <alpine.DEB.2.02.1405051633080.14881@nftneq.ynat.uz> <alpine.LNX.2.00.1405060147190.3969@pobox.suse.cz> <20140506073228.GA26271@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014, Ingo Molnar wrote:

> So what I'm curious about, what is the actual 'in the field' distro 
> experience, about the type of live-patches that get pushed with 
> urgency?

This is of course a very good question. We've done some very light 
preparatory analysis and went through patches which would make most sense 
to be shipped as hot/live patches without enough time for proper downtime 
scheduling (i.e. CVE severity high enough (local root), etc). Most of the 
time, these turn out to be a one-or-few liners, mostly adding extra check, 
fixing bounds, etc. There were just one or two in a few years history 
where some extra care would be needed.

Of course, I guess that most valuable input regarding this could be coming 
from kSplice guys, as they have the biggest in-field experience with this, 
and are shipping a lot of non-trivial patches this way, not just the 
"super-critical" ones. But I am not really sure whether we can expect any 
input from them, unfortunately.

> My guess would be that the overwhelming majority of live-patches don't 
> change data structures - and hence the right initial model would be to 
> ensure (via tooling, and via review) that 'v1' and 'v2' data is exactly 
> the same.

I fully agree ... that's why we are not pro-actively dealing with that in 
kGraft, for the sake of keeping it stupid at simple (at least in the early 
stages).

> The most abstract way to 'live patch' a kernel is to do a checkpoint 
> save on all application state, to reboot the kernel, boot into the 
> patched kernel and then restore all application state seemlessly.

In some sense yes, but it seems to still be rather costly operation 
(especially checkpointing on a HUGE machine might take some time, if I 
understand the technology correctly) compared to just flipping a few bytes 
(while maintaining overall correctness, of course) in the kernel memory.

Basically, CR might be the best solution for very complex and large kernel 
updates. What I am currently most concerned about though, are scenarios 
where datacenter owners need to urgently apply a local root one-liner fix 
with as little hassle as possible.

-- 
Jiri Kosina
SUSE Labs
