Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3ANL7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:59:21 -0500
Received: from mout.web.de ([212.227.15.4]:51934 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab3ANL7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:59:20 -0500
Message-ID: <50F3F289.3090402@web.de>
Date: Mon, 14 Jan 2013 12:56:57 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Cooper <jason@lakedaemon.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all dma_alloc_coherent()
 calls
References: <20121119144826.f59667b2.akpm@linux-foundation.org> <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:tTylKC9xqcXU7PyNVazSZHKQDR07aoIy+41etsZwp/W
 Si0lyrWa94mcNJEujR99jVYDGTb91nTdOQw7XjGlSvxjJgoGPy
 /fDQWW5toYLQFotP10nXt72eYCB/FE1xdcuLVqNegj3DY5hKKI
 S69GHryptsSybW5Kqpwgfhx8wOJwfK6D9ED9aRnbuiukB2Zl/9
 S8GnEl8HRLmMtxAz2uTYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.11.2012 15:31, Marek Szyprowski wrote:
> dmapool always calls dma_alloc_coherent() with GFP_ATOMIC flag,
> regardless the flags provided by the caller. This causes excessive
> pruning of emergency memory pools without any good reason. Additionaly,
> on ARM architecture any driver which is using dmapools will sooner or
> later  trigger the following error:
> "ERROR: 256 KiB atomic DMA coherent pool is too small!
> Please increase it with coherent_pool= kernel parameter!".
> Increasing the coherent pool size usually doesn't help much and only
> delays such error, because all GFP_ATOMIC DMA allocations are always
> served from the special, very limited memory pool.
>
> This patch changes the dmapool code to correctly use gfp flags provided
> by the dmapool caller.
>
> Reported-by: Soeren Moch <smoch@web.de>
> Reported-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Andrew Lunn <andrew@lunn.ch>
> Tested-by: Soeren Moch <smoch@web.de>

Now I tested linux-3.7.1 (this patch is included there) on my Marvell
Kirkwood system. I still see

   ERROR: 1024 KiB atomic DMA coherent pool is too small!
   Please increase it with coherent_pool= kernel parameter!

after several hours of runtime under heavy load with SATA and
DVB-Sticks (em28xx / drxk and dib0700).

As already reported earlier this patch improved the behavior compared to 
linux-3.6.x and 3.7.0 (error after several ten minutes runtime), but
I still see a regression compared to linux-3.5.x. With this kernel the
same system with same workload runs flawlessly.

Regards,
Soeren

