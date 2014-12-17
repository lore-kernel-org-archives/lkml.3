Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaLQOa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:30:59 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52765 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaLQOa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:30:58 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-83-549193a0dd67
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: akpm@linux-foundation.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        David Rientjes <rientjes@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "nadia.derbey@bull.net" <Nadia.Derbey@bull.net>, aquini@redhat.com,
        Joe Perches <joe@perches.com>, avagin@openvz.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kostya Serebryany <kcc@google.com>,
        Dmitry Chernenkov <dmitryc@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-mm@kvack.org
Subject: [PATCH 1/2] hugetlb, sysctl: pass '.extra1 = NULL' rather then
 '.extra1 = &zero'
Date: Wed, 17 Dec 2014 17:30:49 +0300
Message-id: <1418826650-10145-1-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 2.2.0
In-reply-to: <548CA6B6.3060901@colorfullife.com>
References: <548CA6B6.3060901@colorfullife.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t/xq7oLJk8MMfhymd9i269HbBZz1q9h
	s+jZvZPJYsbDXywWK5ZeY7FYfXMNo8Xzhw/ZLSY8bGO3mH3/MVDi2X0mi+3P3jJZ3Hw+h8Vi
	ZecDVov+x9/ZLS7vmsNmcW/Nf1aLffensFp8WHuKxeJE31omi7YlG5kcRDxeLNzC7DHx6UxW
	j5fbN7B57Jx1l91jwaZSjz0TT7J5bPo0id3jxIzfLB7zTgZ6TDr8mcnjy6przB7v911l8+jb
	sorRY+rseo/Pm+QC+KO4bFJSczLLUov07RK4Ml5fVyxYzF2x965nA+M/ji5GTg4JAROJ+409
	zBC2mMSFe+vZuhi5OIQEljJKXFiyjhHC6WOSePTuGVgVm4CexL9Z29lAbBEBWYmpf8+zgBQx
	Czxjlbh+pBOsSFggWqJxyVwmEJtFQFXiwvVlYDavgJvErhtt7BDr5CS23HoEZnMKGEhMaHsG
	ViMkoC/xYf991gmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihETN1x2MS49ZHWIU
	4GBU4uF9cX1CiBBrYllxZe4hRgkOZiUR3s+BE0OEeFMSK6tSi/Lji0pzUosPMTJxcEo1MIbG
	3Sl8/l49YcHFK7nrjPcH/ZuvOINL4Uxb/IMN7z96f3gtx+bM/Gxy5aL7wnFVrse1a+4szzp3
	/vDKFNEzyv7bv+98qMmTPCOlRnH3gwb5IlfHJUabj1Rsa7uxZUGYu0msO4NQq0zZ9EuHg38e
	O3Ba7uX8oj8ed11YVA8KTlToj/8q/l7ZNVSJpTgj0VCLuag4EQCc1w7reAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity") replaced
'unsigned long hugetlb_zero' with 'int zero' leading to out-of-bounds access
in proc_doulongvec_minmax().
Use '.extra1 = NULL' instead of '.extra1 = &zero'. Passing NULL is equivalent to
passing minimal value, which is 0 for unsigned types.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Suggested-by: Manfred Spraul <manfred@colorfullife.com>
Fixes: ed4d4902ebdd ("mm, hugetlb: remove hugetlb_zero and hugetlb_infinity")
Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 kernel/sysctl.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 137c7f6..88ea2d6 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1248,7 +1248,6 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= hugetlb_sysctl_handler,
-		.extra1		= &zero,
 	},
 #ifdef CONFIG_NUMA
 	{
@@ -1257,7 +1256,6 @@ static struct ctl_table vm_table[] = {
 		.maxlen         = sizeof(unsigned long),
 		.mode           = 0644,
 		.proc_handler   = &hugetlb_mempolicy_sysctl_handler,
-		.extra1		= &zero,
 	},
 #endif
 	 {
@@ -1280,7 +1278,6 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(unsigned long),
 		.mode		= 0644,
 		.proc_handler	= hugetlb_overcommit_handler,
-		.extra1		= &zero,
 	},
 #endif
 	{
-- 
2.2.0

