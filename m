Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaJVORx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:17:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35945 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaJVORv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:17:51 -0400
X-AuditID: cbfee68e-f79b46d000002b74-e2-5447bc8de7dc
From: Pintu Kumar <pintu.k@samsung.com>
To: akpm@linux-foundation.org, riel@redhat.com, pintu.k@samsung.com,
        aquini@redhat.com, paul.gortmaker@windriver.com, jmarchan@redhat.com,
        lcapitulino@redhat.com, kirill.shutemov@linux.intel.com,
        m.szyprowski@samsung.com, aneesh.kumar@linux.vnet.ibm.com,
        iamjoonsoo.kim@lge.com, mina86@mina86.com, lauraa@codeaurora.org,
        gioh.kim@lge.com, mgorman@suse.de, rientjes@google.com,
        hannes@cmpxchg.org, vbabka@suse.cz, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: pintu_agarwal@yahoo.com, cpgs@samsung.com, vishnu.ps@samsung.com,
        rohit.kr@samsung.com, ed.savinay@samsung.com
Subject: [PATCH v2 2/2] fs: proc: Include cma info in proc/meminfo
Date: Wed, 22 Oct 2014 19:36:35 +0530
Message-id: <1413986796-19732-2-git-send-email-pintu.k@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1413986796-19732-1-git-send-email-pintu.k@samsung.com>
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
 <1413986796-19732-1-git-send-email-pintu.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsWyRsSkTrd3j3uIwfWXnBZz1q9hs3j8eh6L
	xYyHv1gsXh7StFi0ewGTxbOmL4wWqzf5WqzsbmazOPXnOpPFzedzWCy2d85gt+h//J3d4vKu
	OWwW99b8Z7VYe+Quu8Xkd88YLRYcb2G1uLb3OLNF3/fD7Bbf3t5mt/h7ZT2LRduSjUwWz5tb
	WSwWH7nNbDG7sY/RYkrfXUYHKY/Db94ze1zu62XyWLCp1GPTp0nsHl1vrzB5nJjxm8Vj3slA
	jweHNrN4rPvzisnj49NbLB7v911l8+jbsorR48yCI+wem09Xe3zeJOexfstWpgDBKC6blNSc
	zLLUIn27BK6MOf/XsxVsF62Yt/Q4WwNjk2AXIyeHhICJxKdPU1kgbDGJC/fWs3UxcnEICSxl
	lPh85D47TNHkdz3MEIlFjBLfdz1hhHB6mCQW/poH1s4moC7x481vsISIwGdmiTmvH7KCJJgF
	SiQWrlgPViQs4CQx5+0jZhCbRUBVYuecCYwgNq+As8SKrg9ANgfQOgWJOZNsQMKcAi4Sr6+v
	BisXEqiV2PjtEBvERR84JJ7+dYQYIyDxbfIhFohWWYlNB5ghSiQlDq64wTKBUXgBI8MqRtHU
	guSC4qT0IiO94sTc4tK8dL3k/NxNjMBEcPrfs74djDcPWB9iFOBgVOLhdWBzDxFiTSwrrsw9
	xGgKtGEis5Rocj4w3eSVxBsamxlZmJqYGhuZW5opifMmSP0MFhJITyxJzU5NLUgtii8qzUkt
	PsTIxMEp1cDI/mr1+bglzfLn7C8HHLu652ail/qJasEnr9T2aPYcn27yrvjSe54JRxKn3Sv4
	y6oTIeKSXVOd5vPFY+mdmx/XLpZnaZiuNTHbmvfY3w5XkSnPpta/NXFpKbcNuNcjv43f64bQ
	+RPByoJ62+7MsVPuVJY4bTUv+uOiznBn/xcX9Gqebdx5h2maEktxRqKhFnNRcSIAcIhybP8C	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAd2ePe4hBu+fWVvMWb+GzeLx63ks
	FjMe/mKxeHlI02LR7gVMFs+avjBarN7ka7Gyu5nN4tSf60wWN5/PYbHY3jmD3aL/8Xd2i8u7
	5rBZ3Fvzn9Vi7ZG77BaT3z1jtFhwvIXV4tre48wWfd8Ps1t8e3ub3eLvlfUsFm1LNjJZPG9u
	ZbFYfOQ2s8Xsxj5Giyl9dxkdpDwOv3nP7HG5r5fJY8GmUo9Nnyaxe3S9vcLkcWLGbxaPeScD
	PR4c2szise7PKyaPj09vsXi833eVzaNvyypGjzMLjrB7bD5d7fF5k5zH+i1bmQIEoxoYbTJS
	E1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAAaOkUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzJjzfz1bwXbRinlLj7M1MDYJdjFyckgI
	mEhMftfDDGGLSVy4t56ti5GLQ0hgEaPE911PGCGcHiaJhb/msYBUsQmoS/x48xssISLwmVli
	zuuHrCAJZoESiYUr1oMVCQs4Scx5+whsLIuAqsTOORMYQWxeAWeJFV0fgGwOoHUKEnMm2YCE
	OQVcJF5fXw1WLiRQK7Hx2yG2CYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEJ5pn
	UjsYVzZYHGIU4GBU4uF1YHMPEWJNLCuuzD3EKMHBrCTCq1QPFOJNSaysSi3Kjy8qzUktPsRo
	CnTURGYp0eR8YBLMK4k3NDYxNzU2tTSxMDGzVBLnPdBqHSgkkJ5YkpqdmlqQWgTTx8TBKdXA
	WLdSzpvpqmP+pgjLZu7NlWy9obfTHjF3BgqZvGlZxLGG3zjT83atZ/QWvZKTlZLzL8/NYgu7
	7Pva1GI2t0uG+sfSSJWpN6O+/k1P+Bu/v+L10vxVm8Ruvbp/xXyxZX5K6f3Vt+Y7/WLz9Emt
	XfZo6Xbpb/sO8JUX/f1XxKf6ocjd4DBrVniwEktxRqKhFnNRcSIAvrMbYkoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch include CMA info (CMATotal, CMAFree) in /proc/meminfo.
Currently, in a CMA enabled system, if somebody wants to know the
total CMA size declared, there is no way to tell, other than the dmesg
or /var/log/messages logs.
With this patch we are showing the CMA info as part of meminfo, so that
it can be determined at any point of time.
This will be populated only when CMA is enabled.

Below is the sample output from a ARM based device with RAM:512MB and CMA:16MB.

MemTotal:         471172 kB
MemFree:          111712 kB
MemAvailable:     271172 kB
.
.
.
CmaTotal:          16384 kB
CmaFree:            6144 kB

This patch also fix below checkpatch errors that were found during these changes.

ERROR: space required after that ',' (ctx:ExV)
199: FILE: fs/proc/meminfo.c:199:
+       ,atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
        ^

ERROR: space required after that ',' (ctx:ExV)
202: FILE: fs/proc/meminfo.c:202:
+       ,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
        ^

ERROR: space required after that ',' (ctx:ExV)
206: FILE: fs/proc/meminfo.c:206:
+       ,K(totalcma_pages)
        ^

total: 3 errors, 0 warnings, 2 checks, 236 lines checked

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
---
 fs/proc/meminfo.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index aa1eee0..d3ebf2e 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -12,6 +12,9 @@
 #include <linux/vmstat.h>
 #include <linux/atomic.h>
 #include <linux/vmalloc.h>
+#ifdef CONFIG_CMA
+#include <linux/cma.h>
+#endif
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include "internal.h"
@@ -138,6 +141,10 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 		"AnonHugePages:  %8lu kB\n"
 #endif
+#ifdef CONFIG_CMA
+		"CmaTotal:       %8lu kB\n"
+		"CmaFree:        %8lu kB\n"
+#endif
 		,
 		K(i.totalram),
 		K(i.freeram),
@@ -187,12 +194,16 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		vmi.used >> 10,
 		vmi.largest_chunk >> 10
 #ifdef CONFIG_MEMORY_FAILURE
-		,atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
+		, atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 10)
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
+		, K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
 		   HPAGE_PMD_NR)
 #endif
+#ifdef CONFIG_CMA
+		, K(totalcma_pages)
+		, K(global_page_state(NR_FREE_CMA_PAGES))
+#endif
 		);
 
 	hugetlb_report_meminfo(m);
-- 
1.7.9.5

