Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab3F2XZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 19:25:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39866 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3F2XZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 19:25:35 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Lopez <emilio@elopez.com.ar>, linux@arm.linux.org.uk,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] ARM: dt: Only print warning, not WARN() on bad cpu map in device tree
Date: Sat, 29 Jun 2013 16:25:14 -0700
Message-Id: <1372548314-12785-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to recent changes and expecations of proper cpu bindings, there are
now cases for many of the in-tree devicetrees where a WARN() will hit
on boot due to badly formatted /cpus nodes.

Downgrade this to a pr_warn() to be less alarmist, since it's not a
new problem.

Tested on Arndale, Cubox, Seaboard and Panda ES. Panda hits the WARN
without this, the others do not.

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Olof Johansson <olof@lixom.net>
---

Linus, please apply directly for 3.10 if there is still time. Thanks!


-Olof

 arch/arm/kernel/devtree.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 0905502..5859c8b 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -152,9 +152,10 @@ void __init arm_dt_init_cpu_maps(void)
 		tmp_map[i] = hwid;
 	}
 
-	if (WARN(!bootcpu_valid, "DT missing boot CPU MPIDR[23:0], "
-				 "fall back to default cpu_logical_map\n"))
+	if (!bootcpu_valid) {
+		pr_warn("DT missing boot CPU MPIDR[23:0], fall back to default cpu_logical_map\n");
 		return;
+	}
 
 	/*
 	 * Since the boot CPU node contains proper data, and all nodes have
-- 
1.8.1.192.gc4361b8

