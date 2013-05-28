Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341Ab3E1IA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:00:26 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:4263
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933246Ab3E1IAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:00:24 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: [PATCH] powerpc/sysfs: disable hotplug for the boot cpu
Date: Tue, 28 May 2013 15:59:44 +0800
Message-ID: <1369727984-21505-2-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1369727984-21505-1-git-send-email-chenhui.zhao@freescale.com>
References: <1369727984-21505-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some features depend on the boot cpu, for instance, hibernate/suspend.
So disable hotplug for the boot cpu.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
 arch/powerpc/kernel/sysfs.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index e68a845..294b1c4e 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -655,8 +655,10 @@ static int __init topology_init(void)
 		 * CPU.  For instance, the boot cpu might never be valid
 		 * for hotplugging.
 		 */
-		if (ppc_md.cpu_die)
+		if (ppc_md.cpu_die && cpu != boot_cpuid)
 			c->hotpluggable = 1;
+		else
+			c->hotpluggable = 0;
 
 		if (cpu_online(cpu) || c->hotpluggable) {
 			register_cpu(c, cpu);
-- 
1.7.3


