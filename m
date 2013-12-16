Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab3LPPaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:30:18 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45961 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3LPPaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:30:15 -0500
Date: Mon, 16 Dec 2013 16:30:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 00/71] perf: Add support for Intel Processor Trace
Message-ID: <20131216153008.GA26686@localhost.localdomain>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20131211130448.GA2480@gmail.com>
 <87r49jttqr.fsf@ashishki-desk.ger.corp.intel.com>
 <20131211134724.GC3101@gmail.com>
 <87bo0ht5nj.fsf@ashishki-desk.ger.corp.intel.com>
 <20131216143751.GA7959@gmail.com>
 <20131216151852.GW22695@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216151852.GW22695@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 07:18:52AM -0800, Andi Kleen wrote:
> > So we could make the old ABI a CONFIG_PERF_EVENTS_COMPAT_X86_BTS kind 
> > of legacy option, turned off by default. That allows us its eventual 
> > future phasing out.
> > 
> > It all depends on how useful the new tooling becomes: if interesting 
> > things can be done with it via an obvious, powerful interface then 
> > people might start using it.
> 
> The thing to keep in mind is that BTS is really really slow.
> 
> It's unlikely it'll be ever all that useful no matter how the API
> looks like.

You're right it's extremely slow. But it can still be relevant for debugging,
at least for apps that don't do too much CPU bound stuffs.

My hope has always been that we can make a userspace function graph tracer
out of its dumps. And I think we can, I'm pretty sure that would be a useful tool.

Even better would be to allow for some perf timehist which we can use to navigate through
the execution flow including all branches. But that's quite sophisticated (although
possibly very useful), still a function graph would be a good beginning.

Now if we find a faster replacement that can dump similar sources or even better
if we can filter by branch type (call and ret is all we need for a function graph tracer)
I'm all for it. But I agree with Ingo that some useful tooling should come along.
