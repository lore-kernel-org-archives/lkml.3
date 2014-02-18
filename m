Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbaBRO36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:29:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:12903 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbaBRO3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:29:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="483436686"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/20] lto: Don't let LATENCYTOP and LOCKDEP select KALLSYMS_ALL
Date: Tue, 18 Feb 2014 15:28:45 +0100
Message-Id: <1392733738-8290-8-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

KALLSYMS_ALL enables including data variables into KALLSYMS.
With plain KALLSYMS only functions are included.

LATENCYTOP and LOCKDEP select KALLSYMS_ALL in addition to KALLSYMS.
It's unclear what they actually need _ALL for; they should
only need function backtraces and afaik never touch variables.

LTO currently does not support KALLSYMS_ALL, which prevents
LATENCYTOP and LOCKDEP from working and gives Kconfig errors.
Disable the requirement for KALLSYMS_ALL for them, just use
KALLSYMS.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 lib/Kconfig.debug | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a48abea..5cbf0c5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -928,7 +928,6 @@ config LOCKDEP
 	select STACKTRACE
 	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND && !S390 && !MICROBLAZE && !ARC
 	select KALLSYMS
-	select KALLSYMS_ALL
 
 config LOCK_STAT
 	bool "Lock usage statistics"
@@ -1396,7 +1395,6 @@ config LATENCYTOP
 	depends on PROC_FS
 	select FRAME_POINTER if !MIPS && !PPC && !S390 && !MICROBLAZE && !ARM_UNWIND && !ARC
 	select KALLSYMS
-	select KALLSYMS_ALL
 	select STACKTRACE
 	select SCHEDSTATS
 	select SCHED_DEBUG
-- 
1.8.5.2

