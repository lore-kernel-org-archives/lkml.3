Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770Ab3AOQ5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:57:41 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:60387 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755751Ab3AOQ5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:57:39 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX187wW1tKdKVASR4M0R4bInd0qXszj6fM80=
Date: Tue, 15 Jan 2013 11:56:42 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Soeren Moch <smoch@web.de>, Greg KH <gregkh@linuxfoundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
Message-ID: <20130115165642.GA25500@titan.lakedaemon.net>
References: <20121119144826.f59667b2.akpm@linux-foundation.org>
 <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com>
 <50F3F289.3090402@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F3F289.3090402@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

I've added you to the this thread hoping for a little insight into USB
drivers and their use of coherent and GFP_ATOMIC.  Am I barking up the
wrong tree by looking a the drivers?

On Mon, Jan 14, 2013 at 12:56:57PM +0100, Soeren Moch wrote:
> On 20.11.2012 15:31, Marek Szyprowski wrote:
> >dmapool always calls dma_alloc_coherent() with GFP_ATOMIC flag,
> >regardless the flags provided by the caller. This causes excessive
> >pruning of emergency memory pools without any good reason. Additionaly,
> >on ARM architecture any driver which is using dmapools will sooner or
> >later  trigger the following error:
> >"ERROR: 256 KiB atomic DMA coherent pool is too small!
> >Please increase it with coherent_pool= kernel parameter!".
> >Increasing the coherent pool size usually doesn't help much and only
> >delays such error, because all GFP_ATOMIC DMA allocations are always
> >served from the special, very limited memory pool.
> >
> >This patch changes the dmapool code to correctly use gfp flags provided
> >by the dmapool caller.
> >
> >Reported-by: Soeren Moch <smoch@web.de>
> >Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> >Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >Tested-by: Andrew Lunn <andrew@lunn.ch>
> >Tested-by: Soeren Moch <smoch@web.de>
> 
> Now I tested linux-3.7.1 (this patch is included there) on my Marvell
> Kirkwood system. I still see
> 
>   ERROR: 1024 KiB atomic DMA coherent pool is too small!
>   Please increase it with coherent_pool= kernel parameter!
> 
> after several hours of runtime under heavy load with SATA and
> DVB-Sticks (em28xx / drxk and dib0700).

Could you try running the system w/o the em28xx stick and see how it
goes with v3.7.1?

thx,

Jason.

> As already reported earlier this patch improved the behavior
> compared to linux-3.6.x and 3.7.0 (error after several ten minutes
> runtime), but
> I still see a regression compared to linux-3.5.x. With this kernel the
> same system with same workload runs flawlessly.
> 
> Regards,
> Soeren
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
