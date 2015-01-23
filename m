Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbbAWDZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 22:25:41 -0500
Received: from mail-by2on0130.outbound.protection.outlook.com ([207.46.100.130]:61275
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751911AbbAWDZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 22:25:38 -0500
Date: Thu, 22 Jan 2015 21:20:17 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
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
Message-ID: <20150122212017.4b7032d52a6c75c06d5b4728@freescale.com>
In-Reply-To: <CAC5umyiF52cykH2_5TD0yzXb+842gywpe-+XZHEwmrDe0nYCPw@mail.gmail.com>
References: <20150120140200.aa7ba0eb28d95e456972e178@freescale.com>
	<20150120230150.GA14475@cloud>
	<20150120160738.edfe64806cc8b943beb1dfa0@linux-foundation.org>
	<CAC5umyieZn7ppXkKb45O=C=BF+iv6R_A1Dwfhro=cBJzFeovrA@mail.gmail.com>
	<20150122014550.GA21444@js1304-P5Q-DELUXE>
	<20150122144147.019eedc41f189eac44c3c4cd@freescale.com>
	<CAC5umyiF52cykH2_5TD0yzXb+842gywpe-+XZHEwmrDe0nYCPw@mail.gmail.com>
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
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(164054003)(377424004)(77156002)(62966003)(33646002)(104016003)(46102003)(86362001)(23726002)(46406003)(110136001)(50466002)(2950100001)(77096005)(36756003)(106466001)(105606002)(87936001)(93886004)(100306002)(85426001)(92566002)(50986999)(76176999)(6806004)(50226001)(19580395003)(19580405001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB322;H:tx30smr01.am.freescale.net;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BL2PR03MB322;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2PR03MB322;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB322;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 03:25:35.3960
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2PR03MB322
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015 08:49:36 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> 2015-01-23 5:41 GMT+09:00 Kim Phillips <kim.phillips@freescale.com>:
> > Thanks. Now I get this:
> >
> >   LD      init/built-in.o
> > mm/built-in.o: In function `kernel_map_pages':
> > include/linux/mm.h:2076: undefined reference to `.__kernel_map_pages'
> > include/linux/mm.h:2076: undefined reference to `.__kernel_map_pages'
> > include/linux/mm.h:2076: undefined reference to `.__kernel_map_pages'
> > Makefile:925: recipe for target 'vmlinux' failed
> > make: *** [vmlinux] Error 1
> >
> > but, AFAICT, that's not because this patch is invalid: it's because
> > __kernel_map_pages() isn't implemented in
> > arch/powerpc/mm/pgtable_64.c, i.e., for non-PPC_STD_MMU_64 PPC64
> > machines.
> 
> Then, in order to use generic __kernel_map_pages() in mm/debug-pagealloc.c,
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC shouldn't be selected in
> arch/powerpc/Kconfig, when CONFIG_PPC_STD_MMU_64 isn't defined.

Thanks.  I'm still build-testing this now:

>From 082911ee947246ff962ef21863c45ec467455c40 Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@freescale.com>
Date: Thu, 22 Jan 2015 20:42:40 -0600
Subject: [PATCH v2] mm: fix undefined reference to  `.__kernel_map_pages' on FSL
 PPC64

arch/powerpc has __kernel_map_pages implementations in mm/pgtable_32.c, and
mm/hash_utils_64.c, of which the former is built for PPC32, and the latter
PPC64's without PPC_STD_MMU.  Fix arch/powerpc/Kconfig to not select
ARCH_SUPPORTS_DEBUG_PAGEALLOC when CONFIG_PPC_STD_MMU_64 isn't defined,
i.e., for 64-bit book3e builds to use the generic __kernel_map_pages()
in mm/debug-pagealloc.c.

  LD      init/built-in.o
mm/built-in.o: In function `kernel_map_pages':
include/linux/mm.h:2076: undefined reference to `.__kernel_map_pages'
include/linux/mm.h:2076: undefined reference to `.__kernel_map_pages'
include/linux/mm.h:2076: undefined reference to `.__kernel_map_pages'
Makefile:925: recipe for target 'vmlinux' failed
make: *** [vmlinux] Error 1

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
v2: corrected SUPPORTS_DEBUG_PAGEALLOC selection to enable
non-STD_MMU_64 builds to use the generic __kernel_map_pages().

note: depends on Joonsoo Kim's patch "mm/debug_pagealloc: fix build
failure on ppc and some other archs" published earlier in this
thread.

 arch/powerpc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index a2a168e..22b0940 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -256,6 +256,7 @@ config PPC_OF_PLATFORM_PCI
 	default n
 
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
+	depends on PPC32 || PPC_STD_MMU_64
 	def_bool y
 
 config ARCH_SUPPORTS_UPROBES
-- 
2.2.2

Thanks,

Kim
