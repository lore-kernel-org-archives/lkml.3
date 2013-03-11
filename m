Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3CKXpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:45:08 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:56175 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549Ab3CKXpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:45:07 -0400
Message-ID: <1363045495.3137.126.camel@x61.thuisdomein>
Subject: [PATCH] powerpc: Remove last traces of POWER4_ONLY
From: Paul Bolle <pebolle@tiscali.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Mar 2013 00:44:55 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2013 23:44:56.0468 (UTC) FILETIME=[6F8A7540:01CE1EB2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol POWER4_ONLY got removed in commit
694caf0255dcab506d1e174c96a65ab65d96e108 ("powerpc: Remove
CONFIG_POWER4_ONLY"). Remove its last traces.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/powerpc/platforms/Kconfig.cputype | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index cea2f09..18e3b76 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -124,9 +124,8 @@ config 6xx
 	select PPC_HAVE_PMU_SUPPORT
 
 config POWER3
-	bool
 	depends on PPC64 && PPC_BOOK3S
-	default y if !POWER4_ONLY
+	def_bool y
 
 config POWER4
 	depends on PPC64 && PPC_BOOK3S
@@ -145,8 +144,7 @@ config TUNE_CELL
 	  but somewhat slower on other machines. This option only changes
 	  the scheduling of instructions, not the selection of instructions
 	  itself, so the resulting kernel will keep running on all other
-	  machines. When building a kernel that is supposed to run only
-	  on Cell, you should also select the POWER4_ONLY option.
+	  machines.
 
 # this is temp to handle compat with arch=ppc
 config 8xx
-- 
1.7.11.7

