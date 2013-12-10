Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab3LJPFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 10:05:45 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:39316 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3LJPFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 10:05:42 -0500
Date: Tue, 10 Dec 2013 16:05:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Adrian Hunter <adrian.hunter@intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Ben Cheng <bccheng@google.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL 00/21] perf/core improvements and fixes
Message-ID: <20131210150538.GA873@gmail.com>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
 <20131210111229.GB26659@gmail.com>
 <20131210114421.GI8098@ghostprotocols.net>
 <52A70558.90808@intel.com>
 <20131210121801.GC30001@gmail.com>
 <20131210134920.GO8098@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210134920.GO8098@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Tue, Dec 10, 2013 at 01:18:01PM +0100, Ingo Molnar escreveu:
> > 
> > * Adrian Hunter <adrian.hunter@intel.com> wrote:
> > 
> > > -void dso__set_short_name(struct dso *dso, const char *name)
> > > +void dso__set_short_name(struct dso *dso, const char *name, bool sname_alloc)
> > >  {
> > >  	if (name == NULL)
> > >  		return;
> > > +	if (dso->sname_alloc)
> > > +		free((char *)dso->short_name);
> > > +	dso->sname_alloc = sname_alloc;
> > 
> > Calling the function option the same as the field name is asking for 
> > trouble - I'd suggest 'new_sname_alloc' for the parameter, or so.
> > 
> > And I'd also remove the 'const' from struct dso::short_name, it 
> > probably does not help code generation, because 'dso' is passed in as 
> > const in all the non-lifetime methods anyway.
>  
> > That way the cast can be dropped from the free().
> 
> Not that simple, there are multiple places that pass a constant
> short_name, for instance:
> 
> 	machine__get_kernel()
>                 kernel = dso__kernel_findnew(machine, vmlinux_name,
> 					     "[kernel]", DSO_TYPE_KERNEL);
> 			dso__set_short_name(dso, short_name);
> 
> So dso->short_name will point to "[kernel]", which is a const char *.

Okay, I guess the free() cast is fine then.

Thanks,

	Ingo
