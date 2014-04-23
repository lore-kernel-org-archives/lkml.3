Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbaDWPHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:07:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbaDWPHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:07:40 -0400
Date: Wed, 23 Apr 2014 17:07:14 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 7/7] perf hists/tui: Count callchain rows separately
Message-ID: <20140423150714.GA2230@krava.brq.redhat.com>
References: <1398236408-8856-1-git-send-email-namhyung@kernel.org>
 <1398236408-8856-8-git-send-email-namhyung@kernel.org>
 <20140423142915.GA27585@krava.brq.redhat.com>
 <1398265053.1696.21.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398265053.1696.21.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 11:57:33PM +0900, Namhyung Kim wrote:
> 2014-04-23 (수), 16:29 +0200, Jiri Olsa:
> > On Wed, Apr 23, 2014 at 04:00:08PM +0900, Namhyung Kim wrote:
> > > When TUI hist browser expands/collapses callchains it accounted number
> > > of callchain nodes into total entries to show.  However this code
> > > ignores filtering so that it can make the cursor go to out of screen.
> > 
> > SNIP
> > 
> > hi,
> > I needed following patch, otherwise following test case would segfault
> > 
> > - record with -g
> > - report - unfold one symbol
> > - search for nonsense
> > 
> > the reason is that after unfolding the symbol the nr_callchain_rows
> > will get some number, which will cause the hist_browser__nr_entries
> > function return (entries != 0) actually (entries == nr_callchain_rows)
> > even if there's no entry passing the filter
> 
> Argh, right..  Thanks for spotting this.  I guess other filters (thread,
> dso) have same problem.
> 
> > 
> > fixing that by unfolding everything after the filter and reseting
> > the nr_callchain_rows number
> 
> Hmm.. I think hists__remove_entry_filter() already folds them so how
> about just setting ->nr_callchain_rows to 0 in hist_browser__reset()
> instead?

ok, sounds good

thanks,
jirka
