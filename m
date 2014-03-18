Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbaCRSN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 14:13:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40532 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaCRSNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 14:13:54 -0400
Date: Tue, 18 Mar 2014 15:13:37 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, eranian@google.com,
        namhyung@kernel.org, jolsa@redhat.com
Subject: Re: [PATCH] tools, perf: Add asprintf replacement
Message-ID: <20140318181337.GD6482@ghostprotocols.net>
References: <1394520204-22613-1-git-send-email-andi@firstfloor.org>
 <20140318142632.GB6482@ghostprotocols.net>
 <20140318150533.GA3132@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318150533.GA3132@tassilo.jf.intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 18, 2014 at 08:05:33AM -0700, Andi Kleen escreveu:
> > Humm, this unconditionally replaces it with an alternative that limits
> > the buffer to a fixed size :-\
> 
> Better than corrupting memory.

Yes, it is better than corrupting memory, use the less ugly, good point.
 
> I guess you could use two passes to avoid the limit, but it would surprise me
> if anything in perf needs more than 1K of printf. One issue 
> with doing two passes is that I wasn't sure the snprintf return

The return of snprintf is crazy, that is why we use scnprintf.

> value would work properly on all libcs (e.g. the weirdo one Android uses)
> 
> > 
> > Do you recall at least one of those old glibc version/release number?
 
> glibc-2.13-2.x86_64 (FC14)

> > A reproducer? So that I can try to reproduce it here and try to polish
> > this a bit more...
> 
> I saw it with perf report --branch-history in TUI mode and then pressing
> e. But even running valgrind in stdio mode showed some corruption.
> Without the patch also using some of the --call-graph options segfaulted.

Thanks for the data points,

- Arnaldo
