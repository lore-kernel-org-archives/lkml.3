Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbaIKMfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:35:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51887 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755498AbaIKMeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Steven J. Hill" <Steven.Hill@imgtec.com>,
        "Zhangjin Wu" <wuzhangjin@gmail.com>, linux-mips@linux-mips.org,
        "Fuxin Zhang" <zhangfx@lemote.com>, "Binbin Zhou" <zhoubb@lemote.com>,
        "Ralf Baechle" <ralf@linux-mips.org>,
        "Huacai Chen" <chenhc@lemote.com>, "John Crispin" <john@phrozen.org>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.213733521@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 029/131] MIPS: tlbex: Fix a missing statement for HUGETLB
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhc@lemote.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/mm/tlbex.c | 1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -1282,6 +1282,7 @@ static void __cpuinit build_r4000_tlb_re
 	}
 #ifdef CONFIG_HUGETLB_PAGE
 	uasm_l_tlb_huge_update(&l, p);
+	UASM_i_LW(&p, K0, 0, K1);
 	build_huge_update_entries(&p, htlb_info.huge_pte, K1);
 	build_huge_tlb_write_entry(&p, &l, &r, K0, tlb_random,
 				   htlb_info.restore_scratch);

