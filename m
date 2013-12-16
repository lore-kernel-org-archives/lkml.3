Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3LPOh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 09:37:57 -0500
Received: from mail-ea0-f180.google.com ([209.85.215.180]:65163 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab3LPOh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 09:37:56 -0500
Date: Mon, 16 Dec 2013 15:37:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH v0 00/71] perf: Add support for Intel Processor Trace
Message-ID: <20131216143751.GA7959@gmail.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
 <20131211130448.GA2480@gmail.com>
 <87r49jttqr.fsf@ashishki-desk.ger.corp.intel.com>
 <20131211134724.GC3101@gmail.com>
 <87bo0ht5nj.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bo0ht5nj.fsf@ashishki-desk.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Shishkin <alexander.shishkin@linux.intel.com> wrote:

> > One good approach to do that would be to unify the BTS and PT 
> > tooling (the kernel side can be unified as well, to the extent it 
> > makes sense), and to prove it via actual functionality that this 
> > stuff matters. BTS is available widely, so the tooling can be 
> > tested by anyone who's interested.
> >
> > Allow people to record crashes in core dumps, allow them to look 
> > at histograms/spectrograms of BTS/PT traces, zoom in on actual 
> > traces, etc. - make it easier to handle this huge amount of data 
> > and visualize traces in other ways you find useful, etc.
> >
> > None of that is done right now via BTS so nobody uses it.
> 
> So I can make BTS appear as an "itrace" pmu similarly to PT. One 
> question that comes to mind is should we then dispose of the old 
> interface that's used for accessing BTS functionality or make it 
> coexist with the new one.

So we could make the old ABI a CONFIG_PERF_EVENTS_COMPAT_X86_BTS kind 
of legacy option, turned off by default. That allows us its eventual 
future phasing out.

It all depends on how useful the new tooling becomes: if interesting 
things can be done with it via an obvious, powerful interface then 
people might start using it.

Thanks,

	Ingo
