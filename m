Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbaBXMcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 07:32:21 -0500
Received: from cpanel09.rubas.ch ([195.182.222.79]:44953 "EHLO
	cpanel09.rubas.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbaBXMcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 07:32:19 -0500
X-Greylist: delayed 4125 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2014 07:32:19 EST
From: =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@lists.codethink.co.uk,
        =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
Subject: [PATCH] ARM: kernel: respect device tree status of cpu nodes
Date: Mon, 24 Feb 2014 12:22:40 +0100
Message-Id: <1393240960-31846-1-git-send-email-j@bitron.ch>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel09.rubas.ch
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bitron.ch
X-Get-Message-Sender-Via: cpanel09.rubas.ch: authenticated_id: juerg@bitron.ch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip 'disabled' cpu nodes when building the cpu logical map. This avoids
booting cpus that have been disabled in the device tree.

Signed-off-by: Jürg Billeter <j@bitron.ch>
Reviewed-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 arch/arm/kernel/devtree.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 739c3df..9aed299 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -95,6 +95,10 @@ void __init arm_dt_init_cpu_maps(void)
 		if (of_node_cmp(cpu->type, "cpu"))
 			continue;
 
+		/* Check if CPU is enabled */
+		if (!of_device_is_available(cpu))
+			continue;
+
 		pr_debug(" * %s...\n", cpu->full_name);
 		/*
 		 * A device tree containing CPU nodes with missing "reg"
-- 
1.9.0

