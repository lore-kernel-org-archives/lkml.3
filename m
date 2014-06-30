Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbaF3T2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:28:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:57902 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbaF3T2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:28:19 -0400
Date: Mon, 30 Jun 2014 16:28:14 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Robert Richter <rric@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Fu Wei <fu.wei@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: crazy idea (was: Re: [PATCH] perf tool: Carve out ctype.h et al)
Message-ID: <20140630192814.GD4762@kernel.org>
References: <20140630070755.GA4766@pd.tnic>
 <CAFrcx1=ri4MO3SUn85KqRDc-OBdbRumM44-OsxbU6CckszhH=g@mail.gmail.com>
 <20140630100115.GC4766@pd.tnic>
 <20140630145031.GR27560@rric.localhost>
 <20140630145831.GA4762@kernel.org>
 <20140630151802.GG4766@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630151802.GG4766@pd.tnic>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jun 30, 2014 at 05:18:02PM +0200, Borislav Petkov escreveu:
> On Mon, Jun 30, 2014 at 11:58:31AM -0300, Arnaldo Carvalho de Melo wrote:
> > Yeap, guess its the most sensible to do given how things went so far.
> >
> > Please submit patches when you fix things on code copied from
> > tools/perf/ and generally when improving it.
> 
> Sure.
> 
> Btw, should I still be working on the split even if the RAS daemon is
> out-of-tree?
> 
> If I do, the advantage is that there'll be no pressure on anyone and
> we'll be applying patches as they come.

Yes, I think we should continue moving stuff out of tools/perf/ and into
a place that can be shared with other tools/ living codebases.

Doing so will of course help tools that live elsewhere, outside the
kernel sources as well.

I thought that one way to overcome the fact that the ras daemon doesn't
live in the kernel sources (now or ever) would be to pick whatever lower
hanging fruits there are in place, like:

[acme@zoo linux]$ find tools/ -name list.h
tools/firewire/list.h
tools/lib/lockdep/uinclude/linux/list.h
tools/perf/util/include/linux/list.h
[acme@zoo linux]$ 

Haven't found much more than that tho at this point.

- Arnaldo
