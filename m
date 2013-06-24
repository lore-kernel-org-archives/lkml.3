Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3FXXOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:14:39 -0400
Received: from dmz-mailsec-scanner-6.mit.edu ([18.7.68.35]:48959 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110Ab3FXXOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:14:38 -0400
X-AuditID: 12074423-b7f168e00000095a-fc-51c8d2dd4e7b
Date: Mon, 24 Jun 2013 19:14:27 -0400
From: Greg Price <price@MIT.EDU>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf report: Add option to collapse undesired parts of
 call graph
Message-ID: <20130624231426.GY22203@biohazard-cafe.mit.edu>
References: <20121207072726.GY22203@biohazard-cafe.mit.edu>
 <20130111052736.GG3054@ghostprotocols.net>
 <20130623031720.GW22203@biohazard-cafe.mit.edu>
 <20130623215327.GA995@krava.redhat.com>
 <20130624083253.GA28025@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624083253.GA28025@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsUixG6nrnv30olAg3dvFSwutl1kszjw+ACL
	xda9b1gsjp79y2RxedccNovV/04xWlw6sIDJ4sHKbIumZVtZLNYcWcxu0fb5H6sDt8eVpxwe
	p3v0PHbOusvusWlVJ5tH19srTB7v911l85i7q4/R4/MmuQCOKC6blNSczLLUIn27BK6M7kdv
	2Qv+iFRcW/CSvYHxjEAXIyeHhICJxK95L9ggbDGJC/fWA9lcHEIC+xglds+ZCOVsZJS4dKSV
	EcL5zChxftdOli5GDg4WAVWJ3ysEQbrZBBQkfsxfxwxiiwgoSSz+8pEdpJ5ZYCGzxJ2TDUwg
	CWGBCInpm/+zgti8AtYS3X+OgjUICbxklNiw1wIiLihxcuYTFhCbWUBL4sa/l0wgu5gFpCWW
	/+MACXMK6EucPXMDbKSogIrEtf3tbBMYBWch6Z6FpHsWQvcCRuZVjLIpuVW6uYmZOcWpybrF
	yYl5ealFumZ6uZkleqkppZsYwdHkoryD8c9BpUOMAhyMSjy8H+JOBAqxJpYVV+YeYpTkYFIS
	5V1wGijEl5SfUpmRWJwRX1Sak1p8iFGCg1lJhDdUBCjHm5JYWZValA+TkuZgURLnFbu1M1BI
	ID2xJDU7NbUgtQgmK8PBoSTB6whMGkKCRanpqRVpmTklCGkmDk6Q4TxAw4VBaniLCxJzizPT
	IfKnGBWlgEaDJARAEhmleXC9sGT3ilEc6BVhXl2QKh5gooTrfgU0mAlo8OTU4yCDSxIRUlIN
	jNtWng7cyPwla4pLsvaEjhcrHuk8EX6W/Vx+qve0Y+13JIVWfN10U2ZL7KRZPLFL5mS4VK0N
	NX4400n8Zsycb0cV3Po8GaP/rjw4Oe6wquVEm5Oa6/evEfgsfTyO9e7jrwlPtxyzVrjyO4qz
	xlzT9up9Xuee7uPz69y3PJI360qNjWmTVln3NleJpTgj0VCLuag4EQDnJcGfUQMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 10:32:53AM +0200, Ingo Molnar wrote:
> * Jiri Olsa <jolsa@redhat.com> wrote:
> > It could also make sense to allow sorting on this
> > the same way as we do for '-s parent' and report only
> > '[other]' and 'blackbox' entries.
> > 
> > Also I dont like the 'blackbox' option name, it should
> > complement the parent option somehow.. but no idea ;-)
> 
> Looks like a nice feature.

Thanks, good to hear!


> Maybe calling it '--collapse' would be a better name?
> 
> By default the call-graphs are all expanded to maximum. With this option 
> certain function(s) and all their child chains can be collapsed.

Maybe.  But what this does is actually a bit of an inverse of the
collapsing one does in the front-end (with 'C' or with enter, etc.);
unless we have --inverted/-G, the collapsing one can do interactively
is of the various *callers*, recursively, of a function, whereas this
collapses the recursive *callees*.  Or in other words, interactively
one may collapse or expand a subtree of the display; with this option
one collects together and merges all the subtrees that have a given
symbol name at their respective roots.

So this is doing something that can't be achieved by just doing some
grunt work in the front-end as a user, and it might be confusing to
give it the same name as the interactive thing.

If you're investigating the kind of question that --inverted/-G is
good for answering, then this is the same thing one can do with that
grunt work, but in that case the option is less interesting. :)  The
example in my commit message, which comes from a real use case, is
without -G.

Perhaps --coalesce, but that's a little mysterious.  --trim-callees?
--ignore-callees?  --ignore-inside?  --strip-callees?  --trim-inside?


> --parent filters the call-chains, excluding all others that don't include 
> this parent. It might make sense to rename it to --filter?

Sure, maybe so.  I don't have a firm opinion on the name or exact
semantics of --parent.


> It would also be nice if all these visualization variants were available 
> in the GTK front-end.

TBH I'm not really familiar with the GTK front-end, as I mainly use
the TUI.  At a quick trial, it looks like --blackbox has the expected
effect on the display there; though with or without --blackbox I can't
seem to get the entries to expand to show me a call-graph profile, so
it's hard to demonstrate it fully.  Not sure what I may have done
wrong in building or running perf to make that not work (or is that
expected?)

What changes do you have in mind to make these available in the GTK
front-end?


Cheers,
Greg
