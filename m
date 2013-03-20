Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab3CTKZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 06:25:11 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:61990 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835Ab3CTKZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 06:25:10 -0400
Message-ID: <1363775108.1390.88.camel@x61.thuisdomein>
Subject: [PATCH] memblock: Kill ARCH_POPULATES_NODE_MAP once more
From: Paul Bolle <pebolle@tiscali.nl>
To: Tejun Heo <tj@kernel.org>
Cc: James Hogan <james.hogan@imgtec.com>, Michal Simek <monstr@monstr.eu>,
        microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 11:25:08 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2013 10:25:08.0045 (UTC) FILETIME=[31EDF7D0:01CE2555]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol ARCH_POPULATES_NODE_MAP was killed in v3.3. After
that it popped up again in microblaze and metag. Nobody noticed,
probably because these Kconfig symbols are entirely unused and these
architectures both select HAVE_MEMBLOCK_NODE_MAP. Anyhow, these two
entries can also be killed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/metag/mm/Kconfig   | 3 ---
 arch/microblaze/Kconfig | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/arch/metag/mm/Kconfig b/arch/metag/mm/Kconfig
index 975f2f4..794f26a 100644
--- a/arch/metag/mm/Kconfig
+++ b/arch/metag/mm/Kconfig
@@ -98,9 +98,6 @@ config MAX_ACTIVE_REGIONS
 	default "2" if SPARSEMEM
 	default "1"
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
 
diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
index 1323fa2..173ab2c 100644
--- a/arch/microblaze/Kconfig
+++ b/arch/microblaze/Kconfig
@@ -38,9 +38,6 @@ config RWSEM_GENERIC_SPINLOCK
 config ZONE_DMA
 	def_bool y
 
-config ARCH_POPULATES_NODE_MAP
-	def_bool y
-
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
-- 
1.7.11.7

