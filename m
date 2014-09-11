Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbaIKMst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:48:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51600 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755423AbaIKMeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, linux-mips@linux-mips.org,
        "Florian Fainelli" <florian@openwrt.org>, david.daney@cavium.com,
        "Ralf Baechle" <ralf@linux-mips.org>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.444243504@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 096/131] MIPS: perf: Fix build error caused by unused
 counters_per_cpu_to_total()
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian@openwrt.org>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/kernel/perf_event_mipsxx.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index f29099b..eb5e394 100644
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
 

