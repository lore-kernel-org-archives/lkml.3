Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab3GVQAx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:00:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47128 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab3GVQAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:00:52 -0400
Date: Mon, 22 Jul 2013 13:00:45 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Hitoshi Mitake <mitake.hitoshi@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, h.mitake@gmail.com,
        kirill.shutemov@linux.intel.com
Subject: Re: [PATCH] perf, tools, bench: Fix memcpy benchmark for large sizes
 v2
Message-ID: <20130722160045.GG2157@ghostprotocols.net>
References: <1374187398-14234-1-git-send-email-andi@firstfloor.org>
 <87ip064k60.wl%mitake.hitoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ip064k60.wl%mitake.hitoshi@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jul 20, 2013 at 12:57:27AM +0900, Hitoshi Mitake escreveu:
> At Thu, 18 Jul 2013 15:43:18 -0700, Andi Kleen wrote:
> > glibc calloc() has an optimization to not explicitely memset()
> > very large calloc allocations that just came from mmap(),
> > because they are known to be zero.

> > This could result in the perf memcpy benchmark reading only from
> > the zero page, which gives unrealistic results.

> > Always call memset explicitly on the source area to avoid this problem.

> > +++ b/tools/perf/bench/mem-memcpy.c
> > @@ -115,8 +115,10 @@ static void alloc_mem(void **dst, void **src, size_t length)
> >  	*src = zalloc(length);
> > -	if (!src)
> > +	if (!*src)
 
> In the latest mem-memcpy.c, this if (!src) is already fixed as if
> (!*src). This modification makes applying fail.

I fixed this up, please take a look at:

https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/commit/?h=perf/core&id=a198996c7afae0097c67a61851f19863e59697b2

https://git.kernel.org/cgit/linux/kernel/git/acme/linux.git/log/?h=perf/core

- Arnaldo
