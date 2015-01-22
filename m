Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbbAVUrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:47:14 -0500
Received: from mail-bn1bbn0102.outbound.protection.outlook.com ([157.56.111.102]:61728
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753039AbbAVUrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:47:11 -0500
Date: Thu, 22 Jan 2015 14:41:47 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Akinobu Mita <akinobu.mita@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, <josh@joshtriplett.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Jens Axboe <axboe@fb.com>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 2/2] mm: fix undefined reference to `.kernel_map_pages'
 on PPC builds
Message-ID: <20150122144147.019eedc41f189eac44c3c4cd@freescale.com>
In-Reply-To: <20150122014550.GA21444@js1304-P5Q-DELUXE>
References: <20150120140200.aa7ba0eb28d95e456972e178@freescale.com>
	<20150120230150.GA14475@cloud>
	<20150120160738.edfe64806cc8b943beb1dfa0@linux-foundation.org>
	<CAC5umyieZn7ppXkKb45O=C=BF+iv6R_A1Dwfhro=cBJzFeovrA@mail.gmail.com>
	<20150122014550.GA21444@js1304-P5Q-DELUXE>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=kim.phillips@freescale.com; lists.ozlabs.org; dkim=none
 (message not signed) header.d=none;lists.ozlabs.org; dmarc=permerror
 action=none header.from=freescale.com;
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(377424004)(51704005)(24454002)(46102003)(6806004)(100306002)(19580405001)(106466001)(86362001)(50986999)(105606002)(76176999)(110136001)(50226001)(85426001)(62966003)(87936001)(77156002)(2950100001)(92566002)(33646002)(77096005)(104016003)(36756003)(47776003)(19580395003)(93886004)(23726002)(50466002)(46406003);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB325;H:tx30smr01.am.freescale.net;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BLUPR03MB325;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR03MB325;
X-Forefront-PRVS: 0464DBBBC4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB325;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2015 20:47:05.8057
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB325
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB277;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 10:45:51 +0900
Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> On Wed, Jan 21, 2015 at 09:57:59PM +0900, Akinobu Mita wrote:
> > 2015-01-21 9:07 GMT+09:00 Andrew Morton <akpm@linux-foundation.org>:
> > > On Tue, 20 Jan 2015 15:01:50 -0800 josh@joshtriplett.org wrote:
> > >
> > >> On Tue, Jan 20, 2015 at 02:02:00PM -0600, Kim Phillips wrote:
> > >> > It's possible to configure DEBUG_PAGEALLOC without PAGE_POISONING on
> > >> > ppc.  Fix building the generic kernel_map_pages() implementation in
> > >> > this case:
> > >> >
> > >> >   LD      init/built-in.o
> > >> > mm/built-in.o: In function `free_pages_prepare':
> > >> > mm/page_alloc.c:770: undefined reference to `.kernel_map_pages'
> > >> > mm/built-in.o: In function `prep_new_page':
> > >> > mm/page_alloc.c:933: undefined reference to `.kernel_map_pages'
> > >> > mm/built-in.o: In function `map_pages':
> > >> > mm/compaction.c:61: undefined reference to `.kernel_map_pages'
> > >> > make: *** [vmlinux] Error 1
> > 
> > kernel_map_pages() is static inline function since commit 031bc5743f15
> > ("mm/debug-pagealloc: make debug-pagealloc boottime configurable").
> > 
> > But there is old declaration in 'arch/powerpc/include/asm/cacheflush.h'.
> > Removing it or changing s/kernel_map_pages/__kernel_map_pages/ in this
> > header file or something can fix this problem?
> > 
> > The architecture which has ARCH_SUPPORTS_DEBUG_PAGEALLOC
> > including PPC should not build mm/debug-pagealloc.o
> 
> Yes, architecture with ARCH_SUPPORTS_DEBUG_PAGEALLOC should not build
> mm/debug-pagealloc.o. I attach the patch to remove old declaration.
> I hope it will fix Kim's problem.
> 
> -------------->8------------------
> From 7cb9d1ed8a785df152cb8934e187031c8ebd1bb2 Mon Sep 17 00:00:00 2001
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Date: Thu, 22 Jan 2015 10:28:58 +0900
> Subject: [PATCH] mm/debug_pagealloc: fix build failure on ppc and some other
>  archs
> 
> Kim Phillips reported following build failure.
> 
>   LD      init/built-in.o
>   mm/built-in.o: In function `free_pages_prepare':
>   mm/page_alloc.c:770: undefined reference to `.kernel_map_pages'
>   mm/built-in.o: In function `prep_new_page':
>   mm/page_alloc.c:933: undefined reference to `.kernel_map_pages'
>   mm/built-in.o: In function `map_pages':
>   mm/compaction.c:61: undefined reference to `.kernel_map_pages'
>   make: *** [vmlinux] Error 1
> 
> Reason for this problem is that commit 031bc5743f15
> ("mm/debug-pagealloc: make debug-pagealloc boottime configurable") forgot
> to remove old declaration of kernel_map_pages() in some architectures.
> This patch removes them to fix build failure.
> 
> Reported-by: Kim Phillips <kim.phillips@freescale.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> ---

Thanks. Now I get this:

  LD      init/built-in.o
mm/built-in.o: In function `kernel_map_pages':
include/linux/mm.h:2076: undefined reference to `.__kernel_map_pages'
include/linux/mm.h:2076: undefined reference to `.__kernel_map_pages'
include/linux/mm.h:2076: undefined reference to `.__kernel_map_pages'
Makefile:925: recipe for target 'vmlinux' failed
make: *** [vmlinux] Error 1

but, AFAICT, that's not because this patch is invalid: it's because
__kernel_map_pages() isn't implemented in
arch/powerpc/mm/pgtable_64.c, i.e., for non-PPC_STD_MMU_64 PPC64
machines.

Kim
