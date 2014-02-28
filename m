Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbaB1Trf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 14:47:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbaB1Trd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 14:47:33 -0500
Date: Fri, 28 Feb 2014 14:46:42 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: Re: [PATCH 08/19] perf c2c: Shared data analyser
Message-ID: <20140228194642.GM25953@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-9-git-send-email-dzickus@redhat.com>
 <87lhwvawc4.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lhwvawc4.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 11:08:59AM -0800, Andi Kleen wrote:
> Don Zickus <dzickus@redhat.com> writes:
> > +
> > +static const struct perf_evsel_str_handler handlers[] = {
> > +	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load, },
> > +	{ "cpu/mem-stores/pp",	       perf_c2c__process_store, },
> 
> The 30 magic number should probably be configurable.

Yeah, I just didn't figure out how to make it configurable yet within this
string.  

> 
> Using load-latency here rules out Atom, so at some point
> you would need to get rid of that.

Oh.  How do you get load-latency for Atom then?

> 
> I suspect on most systems you should rather use p 
> instead of pp to get the overhead down (before Haswell pp
> is expensive)

Ok.  Good to know.

> 
> > +static int perf_c2c__record(int argc, const char **argv)
> > +{
> > +	unsigned int rec_argc, i, j;
> > +	const char **rec_argv;
> > +	const char * const record_args[] = {
> > +		"record",
> > +		/* "--phys-addr", */
> 
> So is that needed or not?

No.  Legacy code before we had MMAP2 support.  I'll remove it next respin.

Cheers,
Don
