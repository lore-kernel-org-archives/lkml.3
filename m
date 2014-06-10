Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaFJHCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:02:36 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:6876 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaFJHCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:02:35 -0400
Message-ID: <5396ACF1.1020107@huawei.com>
Date: Tue, 10 Jun 2014 15:00:01 +0800
From: Wang Weidong <wangweidong1@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <linux@arm.linux.org.uk>
CC: <will.deacon@arm.com>, <gregory.clement@free-electrons.com>,
        <nico@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: Thumb-2: Fix out-of-range offset for Thumb-2 in, proc-macros.S
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.75]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STR Instruction Encoding T4 points that the <imm> is in the
range 0-255.So split the instruction into two for Thumb-2. Just
like commit 874d5d3ccc("ARM: 6623/1: Thumb-2: Fix out-of-range
offset for Thumb-2 in proc-v7.S").

Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
---
 arch/arm/mm/proc-macros.S | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/proc-macros.S b/arch/arm/mm/proc-macros.S
index ee1d805..63f710c 100644
--- a/arch/arm/mm/proc-macros.S
+++ b/arch/arm/mm/proc-macros.S
@@ -252,7 +252,9 @@
 	tst	r3, #L_PTE_PRESENT | L_PTE_YOUNG	@ present and young?
 	movne	r2, #0				@ no -> fault
 
-	str	r2, [r0, #2048]!		@ hardware version
+ ARM(	str	r2, [r0, #2048]! 		) @ hardware version
+ THUMB( add	r0, r0, #2048 			)
+ THUMB( str	r2, [r0] 			)
 	mov	ip, #0
 	mcr	p15, 0, r0, c7, c10, 1		@ clean L1 D line
 	mcr	p15, 0, ip, c7, c10, 4		@ data write barrier
-- 
1.7.12


