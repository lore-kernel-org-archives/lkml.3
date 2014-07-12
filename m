Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaGLLgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 07:36:50 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:27785 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbaGLLgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 07:36:32 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8KALscwVNXQ56W/2dsb2JhbABZgw6tMQEBAQEBAQUBbgGcAAGBDRd1hAQBBVYjEFE5HhmIRgG0Q5InF4V7iGxkBxaELQWbDpQdg0Y7gTE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: paulus@samba.org, benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 5/7] hugetlb: replace sscanf by kstrtoul
Date: Sat, 12 Jul 2014 13:36:18 +0200
Message-Id: <1405164980-9525-6-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405164980-9525-1-git-send-email-fabf@skynet.be>
References: <1405164980-9525-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See checkpatch warning
"Prefer kstrto<type> to single variable sscanf"

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 arch/powerpc/mm/hugetlbpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 7e70ae9..9118313 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -350,7 +350,7 @@ static int __init do_gpage_early_setup(char *param, char *val,
 		size = memparse(val, NULL);
 	} else if (strcmp(param, "hugepages") == 0) {
 		if (size != 0) {
-			if (sscanf(val, "%lu", &npages) <= 0)
+			if (kstrtoul(val, 0, &npages))
 				npages = 0;
 			gpage_npages[shift_to_mmu_psize(__ffs(size))] = npages;
 			size = 0;
-- 
1.9.1

