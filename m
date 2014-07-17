Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbaGQJgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:36:23 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17783 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbaGQJgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:36:20 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-d7-53c79911cae1
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: [PATCH] CMA: generalize CMA reserved area management functionality
 (fixup)
Date: Thu, 17 Jul 2014 11:36:07 +0200
Message-id: <1405589767-17513-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.9.2
In-reply-to: <53C78ED7.7030002@samsung.com>
References: <53C78ED7.7030002@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t/xy7qCM48HG/yaK2Vx4so/Ros569ew
	WTx+PY/F4kNTK7PFl5/XGS2aF69ns1jZ3cxm8eaTtsWcqYUWmx5fY7W4vGsOm8W9Nf9ZLW5f
	5rX4/f0fq8XaI3fZLRYcb2G1WPb1PbvFmiOL2S32bwNKXDo+k9lBxKOluYfN4//BScwePW9a
	WD02repk89j0aRK7R9fbK0weJ2b8ZvF4cGgzi8f+uWvYPTYvqfc4P2Mho8e6P6+YPN7vu8rm
	MXdXH6NH35ZVjB6bT1cHCEZx2aSk5mSWpRbp2yVwZRzduJK1YCZbxamL81kaGHtYuxg5OCQE
	TCRudZR2MXICmWISF+6tZwOxhQSWMkocvM7fxcgFZPcxSexu+s8CkmATMJToetvFBpIQEdjG
	KPHyxlwmEIdZ4AqLxL2lnWDtwgKhEpsnr2cGsVkEVCU+9y9nArF5BTwk+p5fZ4NYJyfx/+UK
	sDingLbE5P4dbCAXCQloSZzuS5/AyLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkj0
	fNnBuPiY1SFGAQ5GJR7ezs/HgoVYE8uKK3MPMUpwMCuJ8G7rOh4sxJuSWFmVWpQfX1Sak1p8
	iJGJg1OqgXHSvLRpjt4FzHM/tVbNcDMRV+xveanop1Jbwi3GX3k7raTrk6zC7/p11+8v0Pd/
	aXj5a9RM45AT/kG3W2ZP7ZwfcUI7p/XH9LPL5FaKGX9KVk2W7qzIOzU/KTRisb1puuPE36ce
	X5mrolnoOTPN7p9dm8MRhXCZZP3HjaySGfzcmU8fT1l0RomlOCPRUIu5qDgRAJ3wGFN8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX_CMA_AREAS is used by other subsystems (i.e. arch/arm/mm/dma-mapping.c),
so we need to provide correct definition even if CMA is disabled.
This patch fixes this issue.

Reported-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 include/linux/cma.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 9a18a2b1934c..c077635cad76 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -5,7 +5,11 @@
  * There is always at least global CMA area and a few optional
  * areas configured in kernel .config.
  */
+#ifdef CONFIG_CMA
 #define MAX_CMA_AREAS	(1 + CONFIG_CMA_AREAS)
+#else
+#define MAX_CMA_AREAS	(0)
+#endif
 
 struct cma;
 
-- 
1.9.2

