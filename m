Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaBPTAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 14:00:08 -0500
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:50828 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbaBPTAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 14:00:06 -0500
Message-ID: <1392577203.28866.29.camel@x220>
Subject: [PATCH] sh: remove SH_ALPHA_BOARD
From: Paul Bolle <pebolle@tiscali.nl>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Richard Weinberger <richard@nod.at>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 20:00:03 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 19:00:03.0379 (UTC) FILETIME=[4C8A9030:01CF2B49]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol SH_ALPHA_BOARD was added in v2.6.38. It has never
been used. Setting it has no effect. There are no calls for
mach_is_sh_alpha_board(). This symbol can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep".

 arch/sh/boards/Kconfig   | 5 -----
 arch/sh/tools/mach-types | 1 -
 2 files changed, 6 deletions(-)

diff --git a/arch/sh/boards/Kconfig b/arch/sh/boards/Kconfig
index eb1cf84..70c4f51 100644
--- a/arch/sh/boards/Kconfig
+++ b/arch/sh/boards/Kconfig
@@ -3,9 +3,6 @@ menu "Board support"
 config SOLUTION_ENGINE
 	bool
 
-config SH_ALPHA_BOARD
-	bool
-
 config SH_SOLUTION_ENGINE
 	bool "SolutionEngine"
 	select SOLUTION_ENGINE
@@ -345,7 +342,6 @@ config SH_SH2007
 
 config SH_APSH4A3A
 	bool "AP-SH4A-3A"
-	select SH_ALPHA_BOARD
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	depends on CPU_SUBTYPE_SH7785
 	help
@@ -353,7 +349,6 @@ config SH_APSH4A3A
 
 config SH_APSH4AD0A
 	bool "AP-SH4AD-0A"
-	select SH_ALPHA_BOARD
 	select SYS_SUPPORTS_PCI
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
 	depends on CPU_SUBTYPE_SH7786
diff --git a/arch/sh/tools/mach-types b/arch/sh/tools/mach-types
index 569977e..99f524c 100644
--- a/arch/sh/tools/mach-types
+++ b/arch/sh/tools/mach-types
@@ -9,7 +9,6 @@ SE			SH_SOLUTION_ENGINE
 HIGHLANDER		SH_HIGHLANDER
 RTS7751R2D		SH_RTS7751R2D
 RSK			SH_RSK
-ALPHA_BOARD		SH_ALPHA_BOARD
 
 #
 # List of companion chips / MFDs.
-- 
1.8.5.3

