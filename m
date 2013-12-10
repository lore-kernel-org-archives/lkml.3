Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3LJMY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:24:56 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59754 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3LJMYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:24:52 -0500
Date: Tue, 10 Dec 2013 13:24:49 +0100
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
Message-ID: <20131210122449.GA30891@gmail.com>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
 <20131210111229.GB26659@gmail.com>
 <20131210114421.GI8098@ghostprotocols.net>
 <52A70558.90808@intel.com>
 <20131210121042.GK8098@ghostprotocols.net>
 <52A707A2.5020802@intel.com>
 <20131210122213.GL8098@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210122213.GL8098@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Tue, Dec 10, 2013 at 02:22:58PM +0200, Adrian Hunter escreveu:
> > On 10/12/13 14:10, Arnaldo Carvalho de Melo wrote:
> > > Em Tue, Dec 10, 2013 at 02:13:12PM +0200, Adrian Hunter escreveu:
> > >> On 10/12/13 13:44, Arnaldo Carvalho de Melo wrote:
> > >>> Em Tue, Dec 10, 2013 at 12:12:29PM +0100, Ingo Molnar escreveu:
> > >>>>
> > >>>> Hm, I've unpulled it because 'perf top' crashes on exit, in 
> > >>>> dso__delete():
> > >>>
> > >>> 495		if (dso->sname_alloc)
> > >>> 496			free((char *)dso->short_name)
> > >>>
> > >>> Yeah, must be that basename() patch from Stephane, I'll work on a fix
> > >>> and resubmit this batch, thanks for the report.
> > >>
> > >> The problem is sname_alloc is not maintained.  Perhaps it should be
> > >> set in dso__set_short_name() e.g.
> > > 
> > > Yeah, sounds better than having all callers manage that thing, quickie,
> > > was this with Stephane's patch applied?
> > 
> > Yes it was at
> > 	e993d10caeb6dca690dbaf86e1981ba240d1414a
> > 	perf symbols: fix bug in usage of the basename() function
> 
> Yes, this is the buggy patch, my question was if Ingo did the 
> changes that streamlined the dso->sname_alloc management with 
> e993d10caeb6 applied to his working tree.

My current perf/core head is:

  789790791ad2 tools/perf/build: Fix install dependency

which does not have e993d10c.

[ Btw., a small nit: the capitalization of the commit title looks 
  inconsistent. ]

Thanks,

	Ingo
