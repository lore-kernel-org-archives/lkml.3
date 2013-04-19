Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968318Ab3DSMGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 08:06:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968237Ab3DSMGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:06:13 -0400
From: Michal Marek <mmarek@suse.cz>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: MFD_TPS65912 needs MFD_CORE
Date: Fri, 19 Apr 2013 14:05:56 +0200
Message-Id: <1366373156-24248-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With MFD_TPS65912=y and MFD_CORE=m/n, the build fails with

drivers/mfd/tps65912-core.c:147: undefined reference to `mfd_add_devices'
drivers/mfd/tps65912-core.c:164: undefined reference to `mfd_remove_devices'
drivers/mfd/tps65912-core.c:171: undefined reference to `mfd_remove_devices'

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 60611cd..5faf7c2 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -805,6 +805,7 @@ config MFD_TPS65910
 config MFD_TPS65912
 	bool "TI TPS65912 Power Management chip"
 	depends on GPIOLIB
+	select MFD_CORE
 	help
 	  If you say yes here you get support for the TPS65912 series of
 	  PM chips.
-- 
1.8.2.1

