Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab3CUTMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 15:12:22 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:58368 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645Ab3CUTMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 15:12:21 -0400
Message-ID: <1363893139.1390.151.camel@x61.thuisdomein>
Subject: [PATCH] tile: remove two outdated Kconfig entries
From: Paul Bolle <pebolle@tiscali.nl>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 20:12:19 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 19:12:19.0862 (UTC) FILETIME=[025FF360:01CE2668]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tile support got added in v2.6.36. Its main Kconfig file was added with
two outdated Kconfig entries. DEFAULT_MIGRATION_COST is unused since
v2.6.23, and SEMAPHORE_SLEEPERS is unused since v2.6.26. Remove these
outdated entries now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/tile/Kconfig | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 25877ae..2f8ccff 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -40,9 +40,6 @@ config MMU
 config GENERIC_CSUM
 	def_bool y
 
-config SEMAPHORE_SLEEPERS
-	def_bool y
-
 config HAVE_ARCH_ALLOC_REMAP
 	def_bool y
 
@@ -67,12 +64,6 @@ config HUGETLB_SUPER_PAGES
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
-# We have a very flat architecture from a migration point of view,
-# so save boot time by presetting this (particularly useful on tile-sim).
-config DEFAULT_MIGRATION_COST
-	int
-	default "10000000"
-
 # We only support gcc 4.4 and above, so this should work.
 config ARCH_SUPPORTS_OPTIMIZED_INLINING
 	def_bool y
-- 
1.7.11.7

