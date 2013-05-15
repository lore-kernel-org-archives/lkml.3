Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab3EOHvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 03:51:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28151 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752704Ab3EOHvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 03:51:53 -0400
X-IronPort-AV: E=Sophos;i="4.87,676,1363104000"; 
   d="scan'208";a="7274627"
From: liguang <lig.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        srivatsa.bhat@linux.vnet.ibm.com, Thomas Gleixner <tglx@linutronix.de>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH] cpu remove CONFIG_INIT_ALL_POSSIBLE check
Date: Wed, 15 May 2013 15:50:14 +0800
Message-Id: <1368604214-23237-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 15:50:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/15 15:50:41,
	Serialize complete at 2013/05/15 15:50:41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

seems CONFIG_INIT_ALL_POSSIBLE is obsolete now.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 kernel/cpu.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index cd166d3..2697d1a 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -662,12 +662,7 @@ EXPORT_SYMBOL_GPL(cpu_bit_bitmap);
 const DECLARE_BITMAP(cpu_all_bits, NR_CPUS) = CPU_BITS_ALL;
 EXPORT_SYMBOL(cpu_all_bits);
 
-#ifdef CONFIG_INIT_ALL_POSSIBLE
-static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly
-	= CPU_BITS_ALL;
-#else
 static DECLARE_BITMAP(cpu_possible_bits, CONFIG_NR_CPUS) __read_mostly;
-#endif
 const struct cpumask *const cpu_possible_mask = to_cpumask(cpu_possible_bits);
 EXPORT_SYMBOL(cpu_possible_mask);
 
-- 
1.7.2.5

