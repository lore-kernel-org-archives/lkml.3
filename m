Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab3JNH4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 03:56:13 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:58818 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3JNH4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 03:56:12 -0400
Date: Mon, 14 Oct 2013 09:56:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 0/8] perf tools: Fix scalability problem on callchain
 merging (v5)
Message-ID: <20131014075608.GA20435@gmail.com>
References: <1381468543-25334-1-git-send-email-namhyung@kernel.org>
 <20131011055829.GA4975@gmail.com>
 <20131011073448.GA11064@krava.redhat.com>
 <52581511.2010909@gmail.com>
 <52581737.8090309@gmail.com>
 <87wqljxyqg.fsf@tassilo.jf.intel.com>
 <525875FB.1090104@gmail.com>
 <20131013102521.GA1044@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131013102521.GA1044@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Olsa <jolsa@redhat.com> wrote:

> > -   OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
> > +   OPT_CALLBACK_DEFAULT_NOOPT('g', "call-graph", &record.opts,
> 
> hum, this disables the option completely, no?
> 
> The issue is a consequence of allowing '-g' to have carry
> a value (dwarf,fp). Maybe we could have some sort of new
> OPT_OPTION type, where if its value is not recognized it
> would be passed to next option.
> 
> Or the way Ingo suggested earlier:
> 
> ---
> So, why not keep -g as a shortcut to whatever default call-graph profiling
> we want to provide (note, this does not mean it always has to be 'fp'),
> and use --call-graph for more specific variants?
> 
> a .perfconfig value could even set the default for '-g', so that you don't
> have to type '--call-graph dwarf' all the time.
> ---
> 
> I'll try to come up with something later today

So, I think we should split -g/--call-graph into _two_, separate options:

	--call-graph <variant>
	-g

instead of turning the '<variant>' configurability off. Whatever is 
configurable via .perfconfig ought to also have a command line 
counterpart. This is pretty fundamental.

Ack on the .perfconfig aspect to choose a default for -g.

Thanks,

	Ingo
