Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaJLMDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 08:03:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43340 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaJLMDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 08:03:52 -0400
X-AuditID: cbfee68f-f791c6d000004834-d6-543a6e2670f6
From: Pintu Kumar <pintu.k@samsung.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, liwanp@linux.vnet.ibm.com,
        zhangyanfei@cn.fujitsu.com, rientjes@google.com, edumazet@google.com,
        chaowang@redhat.com, fabf@skynet.be, catalin.marinas@arm.com,
        nasa4836@gmail.com, av1474@comtv.ru, gioh.kim@lge.com,
        rob.jones@codethink.co.uk
Cc: cpgs@samsung.com, pintu.k@samsung.com, pintu_agarwal@yahoo.com,
        vishnu.ps@samsung.com, rohit.kr@samsung.com, ed.savinay@samsung.com,
        iqbal.ams@samsung.com
Subject: [PATCH 1/1] [mm]: vmalloc: replace printk with pr_warn
Date: Sun, 12 Oct 2014 17:26:01 +0530
Message-id: <1413114961-10831-1-git-send-email-pintu.k@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsWyRsSkWlctzyrEoPGyiMWc9WvYLJ782spk
	8X5ZD6PFry/vWCxeHtK0WLR7AZPF02OP2C26fv9ks3jW9IXRYvavSUwWl3fNYbO4t+Y/q8W2
	wzuYLNrOT2Cz6Pt+mN3i29vb7BZtSzYyWexcyGHxvLmVxWJK311Gi0vHZzI7iHqsmbeG0eP/
	wUnMHs9eTmby+HP8CJPHzll32T0WbCr12PRpErtH19srTB4nZvxm8XhwaDOLx/t9V9k8+ras
	YvS42/2P2ePzJjmPWbMOMwXwR3HZpKTmZJalFunbJXBlPLvRz1SwhLVi35LdTA2Mc1m6GDk4
	JARMJJ5fM+9i5AQyxSQu3FvP1sXIxSEksJRRoqv9CAtEwkSifdszVojEdEaJRa0XmCGcHiaJ
	lva/rCBVbALqEj/e/GYEsUUETjBJ3JxRClLELLCIUaL38E0mkISwgL3E7dV72EFsFgFViY0r
	JjOD2LwCzhKTmxaxQ5ykIDFnkg1Ir4TAWg6JYz9WQtULSHybfAjqbFmJTQeYIa6TlDi44gbL
	BEbBBYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzECI/T0v2f9OxjvHrA+xCjAwajEw/tC
	3ipEiDWxrLgy9xCjKdCGicxSosn5wDSQVxJvaGxmZGFqYmpsZG5ppiTOu1DqZ7CQQHpiSWp2
	ampBalF8UWlOavEhRiYOTqkGxrab7HW62Yu9LqYpLGo5um5h7Csh7Zec7wu0NEM/qf2SbH4W
	vZQrVXxll+9UOZa2n3xz8hMOVnb+uBW5wnfr3tjPpe6Hgx0OGL3ltmRt2/xpClOxUlT6gp2P
	GHmnXb3T26V27OVu81NmqrM97Ty+CO+TbYieWS5W1PI764mDxel155LXd7TVKbEUZyQaajEX
	FScCAB81vBHLAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xoK5anlWIwZPZHBZz1q9hs3jyayuT
	xftlPYwWv768Y7F4eUjTYtHuBUwWT489Yrfo+v2TzeJZ0xdGi9m/JjFZXN41h83i3pr/rBbb
	Du9gsmg7P4HNou/7YXaLb29vs1u0LdnIZLFzIYfF8+ZWFospfXcZLS4dn8nsIOqxZt4aRo//
	Bycxezx7OZnJ48/xI0weO2fdZfdYsKnUY9OnSeweXW+vMHmcmPGbxePBoc0sHu/3XWXz6Nuy
	itHjbvc/Zo/Pm+Q8Zs06zBTAH9XAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGu
	pJCXmJtqq+TiE6DrlpkD9LySQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCG
	MePZjX6mgiWsFfuW7GZqYJzL0sXIySEhYCLRvu0ZK4QtJnHh3nq2LkYuDiGB6YwSi1ovMEM4
	PUwSLe1/warYBNQlfrz5zQhiiwicYJK4OaMUpIhZYBGjRO/hm0wgCWEBe4nbq/ewg9gsAqoS
	G1dMZgaxeQWcJSY3LQKKcwCtU5CYM8lmAiP3AkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5
	mxjBCeCZ9A7GVQ0WhxgFOBiVeHhfyFuFCLEmlhVX5h5ilOBgVhLhPRUJFOJNSaysSi3Kjy8q
	zUktPsRoCrR8IrOUaHI+MDnllcQbGpuYmxqbWppYmJhZKonzHmy1DhQSSE8sSc1OTS1ILYLp
	Y+LglGpgDN8UVS1TzFShym3dvd5424s79+ZOflWp+Gey24zsVfUhr+41H36e9I195/4DC8sO
	GtpIun/bIM2ZdbEizFzg2b1cnn3xfhJVBiWBKlrSj5Ie1ExbvaNkdmNWk3gH39tddx9o8buG
	Pd2VHj61wcok0/GM8K94VcO17Pa63jeiVFcxPMpWP66uxFKckWioxVxUnAgAcdgngBYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces printk(KERN_WARNING..) with pr_warn.
Thus it also reduces one line extra because of formatting.

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
---
 mm/vmalloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 90520af..8a18196 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -463,8 +463,7 @@ overflow:
 		goto retry;
 	}
 	if (printk_ratelimit())
-		printk(KERN_WARNING
-			"vmap allocation for size %lu failed: "
+		pr_warn("vmap allocation for size %lu failed: "
 			"use vmalloc=<size> to increase size.\n", size);
 	kfree(va);
 	return ERR_PTR(-EBUSY);
-- 
1.7.9.5

