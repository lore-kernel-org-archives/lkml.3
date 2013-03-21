Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3CUUuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:50:15 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:50590 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753007Ab3CUUuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:50:13 -0400
Message-ID: <1363899006.1390.157.camel@x61.thuisdomein>
Subject: [PATCH] Blackfin: remove "config IP_CHECKSUM_L1"
From: Paul Bolle <pebolle@tiscali.nl>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 21:50:06 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 20:50:08.0571 (UTC) FILETIME=[AC65E0B0:01CE2675]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only user of Kconfig symbol IP_CHECKSUM_L1 got removed in v2.6.33,
with commit ddf9ddacef0989fdeb22e182212a232488f0f3ad ("Blackfin: convert
to generic checksum code"). We can remove the Kconfig entry for this
unused symbol now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/blackfin/Kconfig | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index c3f2e0b..a8acb1d 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -866,14 +866,6 @@ config SYS_BFIN_SPINLOCK_L1
 	  If enabled, sys_bfin_spinlock function is linked
 	  into L1 instruction memory. (less latency)
 
-config IP_CHECKSUM_L1
-	bool "Locate IP Checksum function in L1 Memory"
-	default n
-	depends on !SMP
-	help
-	  If enabled, the IP Checksum function is linked
-	  into L1 instruction memory. (less latency)
-
 config CACHELINE_ALIGNED_L1
 	bool "Locate cacheline_aligned data to L1 Data Memory"
 	default y if !BF54x
-- 
1.7.11.7

