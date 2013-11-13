Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab3KMSH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 13:07:58 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:43157 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab3KMSHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 13:07:52 -0500
Date: Wed, 13 Nov 2013 15:07:46 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf tip: fails to convert comm
Message-ID: <20131113180746.GE14758@ghostprotocols.net>
References: <528306F5.8050307@gmail.com>
 <20131113180344.GA28039@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113180344.GA28039@localhost.localdomain>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 13, 2013 at 07:03:47PM +0100, Frederic Weisbecker escreveu:
> On Tue, Nov 12, 2013 at 09:58:29PM -0700, David Ahern wrote:
> > Hi Namhyung and Frederic:
> > 
> > If you recall I mentioned noting a problem with the callchain series
> > showing comm's. Well, it fails on acme's perf/core. git bisect
> > points to:
> > 
> > $ git bisect bad
> > 4dfced359fbc719a35527416f1b4b3999647f68b is the first bad commit
> > commit 4dfced359fbc719a35527416f1b4b3999647f68b
> > Author: Namhyung Kim <namhyung.kim@lge.com>
> > Date:   Fri Sep 13 16:28:57 2013 +0900
> > 
> >     perf tools: Get current comm instead of last one
> > 
> >     At insert time, a hist entry should reference comm at the time
> > otherwise
> >     it'll get the last comm anyway.
> > 
> > 
> > How to re-create:
> > 
> > Start point is tools/perf directory for 3.12 (Linus tree):
> >   $ perf sched record -o /tmp/perf.data -g -- make -j 16
> >   $ perf script -i /tmp/perf.data > /tmp/1
> > 
> > cd to Arnaldo's tree, make perf and use it to create /tmp/2:
> >   $ perf script -i /tmp/perf.data > /tmp/1
> >   $ diff -U3 /tmp/1 /tmp/2 | less
> > 
> > You'll see a number of comm's showing as :<pid> instead of make, etc.
> 
> I see. I can reproduce, I'll check and see what happens. It would be nice if
> we could have an option to dump internal perf events like comm events as well
> in the perf script stream.

'perf record -D' not enough?

- Arnaldo
