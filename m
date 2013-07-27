Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab3G0DHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 23:07:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47212 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3G0DHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 23:07:07 -0400
From: Hanjun Guo <hanjun.guo@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Metcalf <cmetcalf@tilera.com>
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linaro-acpi@lists.linaro.org, Al Stone <al.stone@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Naresh Bhat <naresh.bhat@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        Hanjun Guo <hanjun.guo@linaro.org>
Subject: [PATCH 3/3] tile / cpu topology: remove stale Macro arch_provides_topology_pointers
Date: Sat, 27 Jul 2013 11:00:51 +0800
Message-Id: <1374894051-31634-3-git-send-email-hanjun.guo@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374894051-31634-1-git-send-email-hanjun.guo@linaro.org>
References: <1374894051-31634-1-git-send-email-hanjun.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro arch_provides_topology_pointers is pointless now, remove it.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/tile/include/asm/topology.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/tile/include/asm/topology.h b/arch/tile/include/asm/topology.h
index d5e86c9..d15c0d8 100644
--- a/arch/tile/include/asm/topology.h
+++ b/arch/tile/include/asm/topology.h
@@ -89,9 +89,6 @@ static inline const struct cpumask *cpumask_of_node(int node)
 #define topology_core_id(cpu)                   (cpu)
 #define topology_core_cpumask(cpu)              ((void)(cpu), cpu_online_mask)
 #define topology_thread_cpumask(cpu)            cpumask_of(cpu)
-
-/* indicates that pointers to the topology struct cpumask maps are valid */
-#define arch_provides_topology_pointers         yes
 #endif
 
 #endif /* _ASM_TILE_TOPOLOGY_H */
-- 
1.7.9.5

