Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934111AbbA1EUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:20:49 -0500
Received: from mail.kernel.org ([198.145.29.136]:39310 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934010AbbA1EUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:20:42 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Binbin Zhou <zhoubb@lemote.com>, John Crispin <john@phrozen.org>,
        "Steven J. Hill" <Steven.Hill@imgtec.com>, linux-mips@linux-mips.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 074/177] MIPS: tlbex: Fix a missing statement for HUGETLB
Date: Wed, 28 Jan 2015 12:08:34 +0800
Message-Id: <1422418236-12852-147-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 8393c524a25609a30129e4a8975cf3b91f6c16a5 upstream.

In commit 2c8c53e28f1 (MIPS: Optimize TLB handlers for Octeon CPUs)
build_r4000_tlb_refill_handler() is modified. But it doesn't compatible
with the original code in HUGETLB case. Because there is a copy & paste
error and one line of code is missing. It is very easy to produce a bug
with LTP's hugemmap05 test.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Binbin Zhou <zhoubb@lemote.com>
Cc: John Crispin <john@phrozen.org>
Cc: Steven J. Hill <Steven.Hill@imgtec.com>
Cc: linux-mips@linux-mips.org
Cc: Fuxin Zhang <zhangfx@lemote.com>
Cc: Zhangjin Wu <wuzhangjin@gmail.com>
Patchwork: https://patchwork.linux-mips.org/patch/7496/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/mips/mm/tlbex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/mm/tlbex.c b/arch/mips/mm/tlbex.c
index 0bc485b..f5abdfa 100644
--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -1283,6 +1283,7 @@ static void __cpuinit build_r4000_tlb_refill_handler(void)
 	}
 #ifdef CONFIG_HUGETLB_PAGE
 	uasm_l_tlb_huge_update(&l, p);
+	UASM_i_LW(&p, K0, 0, K1);
 	build_huge_update_entries(&p, htlb_info.huge_pte, K1);
 	build_huge_tlb_write_entry(&p, &l, &r, K0, tlb_random,
 				   htlb_info.restore_scratch);
-- 
1.9.1

