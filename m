Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964970AbaFSTxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:53:40 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37751 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964908AbaFSTxh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:53:37 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Mark Salter <msalter@redhat.com>
Cc: David Rientjes <rientjes@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2] mm: page_alloc: fix CMA area initialisation when pageblock >
 MAX_ORDER
In-Reply-To: <1403201524.32688.62.camel@deneb.redhat.com>
Organization: http://mina86.com/
References: <1402522435-13884-1-git-send-email-msalter@redhat.com> <alpine.DEB.2.02.1406111557030.27885@chino.kir.corp.google.com> <xa1t61jzwfo6.fsf@mina86.com> <1403201524.32688.62.camel@deneb.redhat.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140619:m.szyprowski@samsung.com::9x3cCUuKFDY4+PP5:00000000000000000000000000000000000000kPT
X-Hashcash: 1:20:140619:linux-kernel@vger.kernel.org::mEGSAGXVs+aawoCW:0000000000000000000000000000000000i81
X-Hashcash: 1:20:140619:rientjes@google.com::2MrabMs7O0RrnwiG:0000000000000000000000000000000000000000001a5g
X-Hashcash: 1:20:140619:msalter@redhat.com::ZgEXdVvcIa/wSua3:00000000000000000000000000000000000000000002KZ7
X-Hashcash: 1:20:140619:catalin.marinas@arm.com::Fhj7HryT/UQBvFHr:000000000000000000000000000000000000005rF5
X-Hashcash: 1:20:140619:linux-arm-kernel@lists.infradead.org::wzwYyEHlQ/pvsZq3:00000000000000000000000005VVh
Date: Thu, 19 Jun 2014 21:53:33 +0200
Message-ID: <xa1td2e41xs2.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a kernel configured with ARM64_64K_PAGES && !TRANSPARENT_HUGEPAGE,
the following is triggered at early boot:

  SMP: Total of 8 processors activated.
  devtmpfs: initialized
  Unable to handle kernel NULL pointer dereference at virtual address 00000008
  pgd = fffffe0000050000
  [00000008] *pgd=00000043fba00003, *pmd=00000043fba00003, *pte=00e0000078010407
  Internal error: Oops: 96000006 [#1] SMP
  Modules linked in:
  CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc864k+ #44
  task: fffffe03bc040000 ti: fffffe03bc080000 task.ti: fffffe03bc080000
  PC is at __list_add+0x10/0xd4
  LR is at free_one_page+0x270/0x638
  ...
  Call trace:
  [<fffffe00003ee970>] __list_add+0x10/0xd4
  [<fffffe000019c478>] free_one_page+0x26c/0x638
  [<fffffe000019c8c8>] __free_pages_ok.part.52+0x84/0xbc
  [<fffffe000019d5e8>] __free_pages+0x74/0xbc
  [<fffffe0000c01350>] init_cma_reserved_pageblock+0xe8/0x104
  [<fffffe0000c24de0>] cma_init_reserved_areas+0x190/0x1e4
  [<fffffe0000090418>] do_one_initcall+0xc4/0x154
  [<fffffe0000bf0a50>] kernel_init_freeable+0x204/0x2a8
  [<fffffe00007520a0>] kernel_init+0xc/0xd4

This happens because init_cma_reserved_pageblock() calls
__free_one_page() with pageblock_order as page order but it is bigger
han MAX_ORDER.  This in turn causes accesses past zone->free_list[].

Fix the problem by changing init_cma_reserved_pageblock() such that it
splits pageblock into individual MAX_ORDER pages if pageblock is
bigger than a MAX_ORDER page.

In cases where !CONFIG_HUGETLB_PAGE_SIZE_VARIABLE, which is all
architectures expect for ia64, powerpc and tile at the moment, the
“pageblock_order > MAX_ORDER” condition will be optimised out since
both sides of the operator are constants.  In cases where pageblock
size is variable, the performance degradation should not be
significant anyway since init_cma_reserved_pageblock() is called
only at boot time at most MAX_CMA_AREAS times which by default is
eight.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Reported-by: Mark Salter <msalter@redhat.com>
---
 mm/page_alloc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7f97767..fe114db 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -817,7 +817,18 @@ void __init init_cma_reserved_pageblock(struct page *page)
 
 	set_page_refcounted(page);
 	set_pageblock_migratetype(page, MIGRATE_CMA);
-	__free_pages(page, pageblock_order);
+
+	if (pageblock_order > MAX_ORDER) {
+		i = pageblock_order - MAX_ORDER;
+		i = 1 << i;
+		p = page;
+		do {
+			__free_pages(p, MAX_ORDER);
+		} while (p += MAX_ORDER_NR_PAGES, --i);
+	} else {
+		__free_pages(page, pageblock_order);
+	}
+
 	adjust_managed_page_count(page, pageblock_nr_pages);
 }
 #endif
-- 
2.0.0.526.g5318336

