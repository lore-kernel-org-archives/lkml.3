Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab3CLEoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 00:44:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:8975 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752871Ab3CLEoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 00:44:13 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856169"
Message-ID: <513EB23D.7020303@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 12:42:37 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: linux@arm.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/18] arm: remove cast for kzalloc return value
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 12:42:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 12:42:58,
	Serialize complete at 2013/03/12 12:42:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kzalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
---
 arch/arm/kernel/topology.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
index 79282eb..f10316b 100644
--- a/arch/arm/kernel/topology.c
+++ b/arch/arm/kernel/topology.c
@@ -100,7 +100,7 @@ static void __init parse_dt_topology(void)
 	int alloc_size, cpu = 0;
 
 	alloc_size = nr_cpu_ids * sizeof(struct cpu_capacity);
-	cpu_capacity = (struct cpu_capacity *)kzalloc(alloc_size, GFP_NOWAIT);
+	cpu_capacity = kzalloc(alloc_size, GFP_NOWAIT);
 
 	while ((cn = of_find_node_by_type(cn, "cpu"))) {
 		const u32 *rate, *reg;
-- 
1.7.1
