Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbaIWCny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 22:43:54 -0400
Received: from mail.kernel.org ([198.145.19.201]:38505 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbaIWCkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 22:40:39 -0400
From: Zefan Li <lizf@kernel.org>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Florian Fainelli <florian@openwrt.org>,
        linux-mips@linux-mips.org, david.daney@cavium.com,
        Ralf Baechle <ralf@linux-mips.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 35/45] MIPS: perf: Fix build error caused by unused counters_per_cpu_to_total()
Date: Tue, 23 Sep 2014 10:31:37 +0800
Message-Id: <1411439507-30391-35-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411439259-30224-1-git-send-email-lizf@kernel.org>
References: <1411439259-30224-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Florian Fainelli <florian@openwrt.org>

3.4.104-rc1 review patch.  If anyone has any objections, please let me know.

------------------

commit 6c37c9580409af7dc664bb6af0a85d540d63aeea upstream.

cc1: warnings being treated as errors
arch/mips/kernel/perf_event_mipsxx.c:166: error: 'counters_per_cpu_to_total' defined but not used
make[2]: *** [arch/mips/kernel/perf_event_mipsxx.o] Error 1
make[2]: *** Waiting for unfinished jobs....

It was first introduced by 82091564cfd7ab8def42777a9c662dbf655c5d25 [MIPS:
perf: Add support for 64-bit perf counters.] in 3.2.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Cc: linux-mips@linux-mips.org
Cc: david.daney@cavium.com
Patchwork: https://patchwork.linux-mips.org/patch/3357/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/mips/kernel/perf_event_mipsxx.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 811084f..52f60e5 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -162,11 +162,6 @@ static unsigned int counters_total_to_per_cpu(unsigned int counters)
 	return counters >> vpe_shift();
 }
 
-static unsigned int counters_per_cpu_to_total(unsigned int counters)
-{
-	return counters << vpe_shift();
-}
-
 #else /* !CONFIG_MIPS_MT_SMP */
 #define vpe_id()	0
 
-- 
1.7.9.5

