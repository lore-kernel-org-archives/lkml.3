Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbaBEUDZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:03:25 -0500
Received: from mail1.windriver.com ([147.11.146.13]:47839 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbaBEUDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Romain Francoise <romain@orebokech.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 001/213] x86, random: make ARCH_RANDOM prompt if EMBEDDED, not EXPERT
Date: Wed, 5 Feb 2014 14:59:16 -0500
Message-ID: <1391630568-49251-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Romain Francoise <romain@orebokech.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

Before v2.6.38 CONFIG_EXPERT was known as CONFIG_EMBEDDED but the
Kconfig entry was not changed to match when upstream commit
628c6246d47b85f5357298601df2444d7f4dd3fd ("x86, random: Architectural
inlines to get random integers with RDRAND") was backported.

Signed-off-by: Romain Francoise <romain@orebokech.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0a813f82eb9b..b87027b463a3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1462,7 +1462,7 @@ config ARCH_USES_PG_UNCACHED
 
 config ARCH_RANDOM
 	def_bool y
-	prompt "x86 architectural random number generator" if EXPERT
+	prompt "x86 architectural random number generator" if EMBEDDED
 	---help---
 	  Enable the x86 architectural RDRAND instruction
 	  (Intel Bull Mountain technology) to generate random numbers.
-- 
1.8.5.2

