Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaJVOQw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:16:52 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19937 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaJVOQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:16:50 -0400
X-AuditID: cbfee68e-f79b46d000002b74-af-5447bc4b02c9
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
Subject: [PATCH v2 1/2] mm: cma: split cma-reserved in dmesg log
Date: Wed, 22 Oct 2014 19:36:34 +0530
Message-id: <1413986796-19732-1-git-send-email-pintu.k@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAzWSe0hTYRjG+875ds7ZyjrOrK9BIQsts+vm7KskBIM+iKBW/WNQLj2otans
	InYRKlO81LoYtXLEUiPL6WoWRaXplLxCgtXyWmE5S026YDdnba3++708z/u87x8PR0s/QBmX
	lm4U9OkarZyRQPvc6JwVWx5t3rl62hOKrQ47g4dGr0BsefMT4veuSFz20Ebh4eNfAa5ybsU3
	inMZ3D7lpnCPxwrxvUILi08PfWNx9wMrgwftv0W4unmAxSUfhwG2tZwQ4Rd1LTQ2f2ti8eR4
	H4u9zxwQ51fcprAnNw/i8uY+GpceMwN83jwA4mSkaWyCJt3mUxSxOU3E+fkcS4rGn1Gk1fIL
	kitt28lrVy0kNVMfKPLpXS8kE/XPGWK+cxOQTlszS2o7DpMvzkXEcecutS04QRKbLGjTsgT9
	qo2JktTLHerMe7Lsqs5x0VFwNrQIiDnER6PLQ9NMgOehrkGHjyWclL8GUGNLKfPfdGG04p9Q
	BpD9VB4VGE5S6FZv118Xwy9B38d+Ab8wl/9CI+voG5FfoHkjulrpgH4O4ePQ21eDfxny4eiJ
	t571cxAfjwosT33M+c6FIeu5WD+K+U2ovSzHj1Kf4/yUyZ+O+DEO3a4vFgVSeDRZ4oKBzYXI
	2UAHfl6AGitfwjMgxAZm3AShQmZSpmFfil6x0qDRGUzpKSuTMnRO4KtAx/Sw+T7oadjgAjwH
	5LOC4pjNO6UiTZbhoM4FVL4LZ2lZaFKGrzXpxr1rlDEKrIpWKRVr18XI5wclyn7skPIpGqNw
	QBAyBf1evUkrGFyA4sSyoyDKe8mubizh+n8uV5v6F+t21eyvYjuGg1N3HzpmVxdujahLIM0x
	I0pYneh1q8rt7trc/KHJZEEcT8RMAQqDraL3iuvVpcrwRQnKmb1zcL+4/Ajblv84bGqkbL1z
	dpT7yMWnse58T2ShPnlPdk5PSd7IWMXSCJ1apY0vUCbIoSFVs2YZrTdo/gCGKiRi/QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAV3vPe4hBlv6OC3mrF/DZvH49TwW
	ixkPf7FYvDykabFo9wImi2dNXxgtVm/ytVjZ3cxmcerPdSaLm8/nsFhs75zBbtH/+Du7xeVd
	c9gs7q35z2qx9shddovJ754xWiw43sJqcW3vcWaLvu+H2S2+vb3NbvH3ynoWi7YlG5ksnje3
	slgsPnKb2WJ2Yx+jxZS+u4wOUh6H37xn9rjc18vksWBTqcemT5PYPbreXmHyODHjN4vHvJOB
	Hg8ObWbxWPfnFZPHx6e3WDze77vK5tG3ZRWjx5kFR9g9Np+u9vi8Sc5j/ZatTAGCUQ2MNhmp
	iSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTnAgFFSKEvMKQUK
	BSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZsw6HVSwXapi9Zm3rA2ME0W7GDk5JARM
	JKa9XsIGYYtJXLi3Hsjm4hASWMQosaa3lQnC6WGS2HDrAlgVm4C6xI83vxlBEiICn5kl5rx+
	yAqSYBYokVi4Yj0LiC0s4CDx5P49MJtFQFXi2N997CA2r4CzRMeM80A2B9A6BYk5k2xATE4B
	F4lTi2pBTCGgiil/Sicw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZxinknvYFzV
	YHGIUYCDUYmH14HNPUSINbGsuDL3EKMEB7OSCK9SPVCINyWxsiq1KD++qDQntfgQoynQSROZ
	pUST84HpL68k3tDYxNzU2NTSxMLEzFJJnPdgq3WgkEB6YklqdmpqQWoRTB8TB6dUA6PdH7bV
	T476K5S3B8lxfcn7cbD3kbjpjrobPzsPTP94aFKw/e/XWhW/LCOnXjx5Qubps9dvTnY9SXOX
	+XQ7yuFM1r35ynNubT2r+1Kcp8Xaava/Zb6+oZJ/vfoOG/7bcOz1kb8nu9ObU53kfUJ2HjjI
	a+dkt2Lvaf2GJQeivX66dWhmq4R8u/hGiaU4I9FQi7moOBEAswMAskcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the system boots up, in the dmesg logs we can see
the memory statistics along with total reserved as below.
Memory: 458840k/458840k available, 65448k reserved, 0K highmem

When CMA is enabled, still the total reserved memory remains the same.
However, the CMA memory is not considered as reserved.
But, when we see /proc/meminfo, the CMA memory is part of free memory.
This creates confusion.
This patch corrects the problem by properly subtracting the CMA reserved
memory from the total reserved memory in dmesg logs.

Below is the dmesg snapshot from an arm based device with 512MB RAM and
12MB single CMA region.

Before this change:
Memory: 458840k/458840k available, 65448k reserved, 0K highmem

After this change:
Memory: 458840k/458840k available, 53160k reserved, 12288k cma-reserved, 0K highmem

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
---
v2: Moved totalcma_pages extern declaration to linux/cma.h
    Removed CONFIG_CMA while show cma-reserved, from page_alloc.c
    Moved totalcma_pages declaration to page_alloc.c, so that if will be visible 
    in non-CMA cases.
 include/linux/cma.h |    1 +
 mm/cma.c            |    1 +
 mm/page_alloc.c     |    6 ++++--
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 0430ed0..0b75896 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -15,6 +15,7 @@
 
 struct cma;
 
+extern unsigned long totalcma_pages;
 extern phys_addr_t cma_get_base(struct cma *cma);
 extern unsigned long cma_get_size(struct cma *cma);
 
diff --git a/mm/cma.c b/mm/cma.c
index 963bc4a..8435762 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -288,6 +288,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
 	if (ret)
 		goto err;
 
+	totalcma_pages += (size / PAGE_SIZE);
 	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
 		(unsigned long)base);
 	return 0;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd73f9a..ababbd8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -110,6 +110,7 @@ static DEFINE_SPINLOCK(managed_page_count_lock);
 
 unsigned long totalram_pages __read_mostly;
 unsigned long totalreserve_pages __read_mostly;
+unsigned long totalcma_pages __read_mostly;
 /*
  * When calculating the number of globally allowed dirty pages, there
  * is a certain number of per-zone reserves that should not be
@@ -5520,7 +5521,7 @@ void __init mem_init_print_info(const char *str)
 
 	pr_info("Memory: %luK/%luK available "
 	       "(%luK kernel code, %luK rwdata, %luK rodata, "
-	       "%luK init, %luK bss, %luK reserved"
+	       "%luK init, %luK bss, %luK reserved, %luK cma-reserved"
 #ifdef	CONFIG_HIGHMEM
 	       ", %luK highmem"
 #endif
@@ -5528,7 +5529,8 @@ void __init mem_init_print_info(const char *str)
 	       nr_free_pages() << (PAGE_SHIFT-10), physpages << (PAGE_SHIFT-10),
 	       codesize >> 10, datasize >> 10, rosize >> 10,
 	       (init_data_size + init_code_size) >> 10, bss_size >> 10,
-	       (physpages - totalram_pages) << (PAGE_SHIFT-10),
+	       (physpages - totalram_pages - totalcma_pages) << (PAGE_SHIFT-10),
+	       totalcma_pages << (PAGE_SHIFT-10),
 #ifdef	CONFIG_HIGHMEM
 	       totalhigh_pages << (PAGE_SHIFT-10),
 #endif
-- 
1.7.9.5

