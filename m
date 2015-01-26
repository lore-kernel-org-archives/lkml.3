Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbbAZT3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:29:42 -0500
Received: from mail-bn1bbn0103.outbound.protection.outlook.com ([157.56.111.103]:7222
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752622AbbAZT3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:29:37 -0500
Date: Mon, 26 Jan 2015 13:24:14 -0600
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
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH 2/2] mm: fix undefined reference to `.kernel_map_pages'
 on PPC builds
Message-ID: <20150126132414.238ece260a30b79327551206@freescale.com>
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
 smtp.mailfrom=kim.phillips@freescale.com; freescale.mail.onmicrosoft.com;
 dkim=none (message not signed) header.d=none;freescale.mail.onmicrosoft.com;
 dmarc=permerror action=none header.from=freescale.com;
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(164054003)(51704005)(24454002)(77096005)(36756003)(77156002)(62966003)(46406003)(50466002)(110136001)(93886004)(2950100001)(46102003)(6806004)(19580405001)(104016003)(23726002)(92566002)(19580395003)(47776003)(33646002)(85426001)(76176999)(105606002)(50986999)(100306002)(86362001)(50226001)(95246002)(106466001)(87936001)(95446003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0736;H:tx30smr01.am.freescale.net;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DM2PR0301MB0736;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0736;
X-Forefront-PRVS: 0468FE4A2B
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0736;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2015 19:29:33.6374
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0736
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan 2015 10:45:51 +0900
Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

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

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Thanks,

Kim
