Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661Ab3BRXtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 18:49:14 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45892 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab3BRXtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 18:49:13 -0500
MIME-Version: 1.0
Message-ID: <b6ea78ee-41df-4c92-84fa-e1b4a430f957@default>
Date: Mon, 18 Feb 2013 15:48:47 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Ric Mason <ric.masonn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>
Subject: RE: [PATCH] zsmalloc: Add Kconfig for enabling PTE method
References: <1359937421-19921-1-git-send-email-minchan@kernel.org>
 <511F2721.2000305@gmail.com> <512271E1.9000105@linux.vnet.ibm.com>
In-Reply-To: <512271E1.9000105@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Subject: Re: [PATCH] zsmalloc: Add Kconfig for enabling PTE method
> 
> On 02/16/2013 12:28 AM, Ric Mason wrote:
> > On 02/04/2013 08:23 AM, Minchan Kim wrote:
> >> +      for object mapping. You can check speed with zsmalloc
> >> benchmark[1].
> >> +      [1] https://github.com/spartacus06/zsmalloc
> >
> > Is there benchmark to test zcache? eg. internal fragmentation level ...
> 
> First, zsmalloc is not used in zcache right now so just wanted to say
> that.  It is used in zram and the proposed zswap
> (https://lwn.net/Articles/528817/)
> 
> There is not an official benchmark.  However anything that generates
> activity that will hit the frontswap or cleancache hooks will do.
> These are workloads that overcommit memory and use swap, or access
> file sets whose size is larger that the system page cache.

I think it's important to note that the question "is there
a benchmark" is a very deep and difficult question for any
compression solution because it is so workload-dependent.
Unlike many benchmarks that simply synthesize a _quantity_
of data, zcache/zswap/zram all are very sensitive to the
actual contents of that data as the compression ratio
varies widely depending on the data.  So we need to ensure
that the data used by any benchmark has similar "entropy"
to real world workloads.  I'm not sure how we can do that.

So it may or may not be useful to measure zcache/zswap/zram using
standard benchmarks (including things like SPECjbb).  At least
kernbench is something that kernel developers do every day,
so it is definitely a real world workload... but adding
parallel compiles (via "make -jN") until the system thrashes,
and then showing zcache/zswap/zram reduces the thrashing may
not be at all representative of a broad range of workloads
that cause memory pressure... kernbench is just convenient for
us developers to demonstrate that the mechanism works.

Ideas welcome... well-thought out ideas anyway!

Dan

