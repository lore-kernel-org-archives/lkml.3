Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455AbaJJFTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 01:19:01 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:41799 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaJJFS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 01:18:59 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Matthew Vick <matthew.vick@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Linux NICS <linux.nics@intel.com>,
        e1000-devel@lists.sourceforge.net (open list:INTEL ETHERNET DR...),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] networking: fm10k: Fix build failure
Date: Fri, 10 Oct 2014 01:19:06 -0400
Message-Id: <1412918346-24763-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest linus git tip (3.18-rc1) fails with the following build failure. Fix
this by making PTP support explicit for fm10k driver.

rivers/built-in.o: In function `fm10k_ptp_register':
(.text+0x12e760): undefined reference to `ptp_clock_registER'
drivers/built-in.o: In function `fm10k_ptp_unregister':
(.text+0x12e7dc): undefined reference to `ptp_clock_unregister'
Makefile:930: recipe for target 'vmlinux' failed

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/net/ethernet/intel/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
index 6a6d5ee..6919adb 100644
--- a/drivers/net/ethernet/intel/Kconfig
+++ b/drivers/net/ethernet/intel/Kconfig
@@ -304,6 +304,7 @@ config FM10K
 	tristate "Intel(R) FM10000 Ethernet Switch Host Interface Support"
 	default n
 	depends on PCI_MSI
+	select PTP_1588_CLOCK
 	---help---
 	  This driver supports Intel(R) FM10000 Ethernet Switch Host
 	  Interface.  For more information on how to identify your adapter,
-- 
1.9.1

