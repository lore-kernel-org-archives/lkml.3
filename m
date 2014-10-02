Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbaJBPNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:13:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbaJBPNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:13:42 -0400
Date: Thu, 2 Oct 2014 12:13:07 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Milian Wolff <mail@milianw.de>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/5] perf tools: Move callchain_param to util object in
 to fix python test
Message-ID: <20141002151307.GA2245@redhat.com>
References: <1412179229-19466-1-git-send-email-jolsa@kernel.org>
 <1412179229-19466-2-git-send-email-jolsa@kernel.org>
 <20141002145949.GK2799@kernel.org>
 <20141002150827.GK9764@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002150827.GK9764@krava.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 02, 2014 at 05:08:27PM +0200, Jiri Olsa escreveu:
> On Thu, Oct 02, 2014 at 11:59:49AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Oct 01, 2014 at 06:00:26PM +0200, Jiri Olsa escreveu:
> > > In following commit we changed the location of callchains data:
> > >   b016b5ba554b perf tools: Move callchain config from record_opts to callchain_param
> > > 
> > > Now all callchains stuff stays in callchain_param struct,
> > > which adds its dependency for evsel.c object and breaks
> > > python perf.so usage (unresolved callchain_param).
> > > 
> > > Moving callchain_param into callchain.c and adding it into
> > > python-ext-sources unleash just another dependency hell,
> > > so I ended up adding callchain_param into util.c for now.
> > 
> > Against what branch is the patch? I am not finding b016b5ba554b in none
> 
> [jolsa@krava perf]$ git describe --contains b016b5ba554b
> fatal: cannot describe 'b016b5ba554ba38c74241ef8739f8fde8878d3eb'
> [jolsa@krava perf]$ git show --oneline b016b5ba554b | head -1
> b016b5ba554b perf tools: Move callchain config from record_opts to callchain_param
> [jolsa@krava perf]$ git show 72a128aa083a > /tmp/p
> [jolsa@krava perf]$ git show b016b5ba554b > /tmp/p1
> [jolsa@krava perf]$ diff -puw /tmp/p /tmp/p1 
> --- /tmp/p      2014-10-02 17:06:20.072958720 +0200
> +++ /tmp/p1     2014-10-02 17:06:26.035946113 +0200
> @@ -1,4 +1,4 @@
> -commit 72a128aa083a7f4cc4f800718aaae05d9c698e26
> +commit b016b5ba554ba38c74241ef8739f8fde8878d3eb
>  Author: Namhyung Kim <namhyung@kernel.org>
>  Date:   Tue Sep 23 10:01:41 2014 +0900
> 
> 
> I guess I took some version before your rebase
> 
> > of the branches in my linux git repo and the python 'perf test' entry
> > works as expected:
> > 
> > [root@zoo ~]# perf test python
> > 17: Try 'use perf' in python, checking link problems       : Ok
> > [root@zoo ~]# 
> 
> hum.. yours acme/perf/core is failing for me:
> 
> [jolsa@krava perf]$ ./perf test python
> 17: Try 'use perf' in python, checking link problems       : FAILED!
> [jolsa@krava perf]$ git show --oneline HEAD | head -1
> 281f92f233a5 perf record: Fix error message for --filter option not coming after tracepoint
> 
> maybe you need 'make clean && make' ?

Yeap, I somehow thought that I had that covered :-\

Reproduced, yeah, 72a128aa083a7f4cc4f800718aaae05d9c698e26 is in, and
I'll take your patch, thanks.

Will update the comment to refer to the right cset.

- Arnaldo
