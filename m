Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbbAZT1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:27:49 -0500
Received: from mail-bn1bon0132.outbound.protection.outlook.com ([157.56.111.132]:56386
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752657AbbAZT1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:27:46 -0500
Date: Mon, 26 Jan 2015 13:22:22 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Michael Ellerman <mpe@ellerman.id.au>
CC: Akinobu Mita <akinobu.mita@gmail.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        Rik van Riel <riel@redhat.com>, <linux-mm@kvack.org>,
        <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>, Minchan Kim <minchan@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Scott Wood <scottwood@freescale.com>
Subject: [PATCH v3] powerpc/mm: fix undefined reference to 
 `.__kernel_map_pages' on FSL PPC64
Message-ID: <20150126132222.6477257be204a3332601ef11@freescale.com>
In-Reply-To: <1421987091.24984.13.camel@ellerman.id.au>
References: <20150120140200.aa7ba0eb28d95e456972e178@freescale.com>
	<20150120230150.GA14475@cloud>
	<20150120160738.edfe64806cc8b943beb1dfa0@linux-foundation.org>
	<CAC5umyieZn7ppXkKb45O=C=BF+iv6R_A1Dwfhro=cBJzFeovrA@mail.gmail.com>
	<20150122014550.GA21444@js1304-P5Q-DELUXE>
	<20150122144147.019eedc41f189eac44c3c4cd@freescale.com>
	<CAC5umyiF52cykH2_5TD0yzXb+842gywpe-+XZHEwmrDe0nYCPw@mail.gmail.com>
	<20150122212017.4b7032d52a6c75c06d5b4728@freescale.com>
	<1421987091.24984.13.camel@ellerman.id.au>
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
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(104016003)(106466001)(46102003)(19580395003)(76176999)(23726002)(36756003)(229853001)(33646002)(110136001)(47776003)(19580405001)(50226001)(46406003)(6806004)(93886004)(50986999)(100306002)(92566002)(85426001)(105606002)(87936001)(86362001)(50466002)(62966003)(77156002)(77096005)(2950100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0721;H:tx30smr01.am.freescale.net;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR0301MB0721;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0721;
X-Forefront-PRVS: 0468FE4A2B
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0721;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2015 19:27:40.9325
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0721
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0595;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/powerpc has __kernel_map_pages implementations in mm/pgtable_32.c, and
mm/hash_utils_64.c, of which the former is built for PPC32, and the latter
for PPC64 machines with PPC_STD_MMU.  Fix arch/powerpc/Kconfig to not select
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
v3:
- fix wording for hash_utils_64.c implementation pointed out by
Michael Ellerman
- changed designation from 'mm:' to 'powerpc/mm:', as I think this
now belongs in ppc-land

v2:
- corrected SUPPORTS_DEBUG_PAGEALLOC selection to enable
non-STD_MMU_64 builds to use the generic __kernel_map_pages().

depends on:
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Date: Thu, 22 Jan 2015 10:28:58 +0900
Subject: [PATCH] mm/debug_pagealloc: fix build failure on ppc and some other archs

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

