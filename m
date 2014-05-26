Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaEZPtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:49:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33606 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaEZPtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:49:45 -0400
Date: Mon, 26 May 2014 08:49:17 -0700
From: tip-bot for Arnd Bergmann <tipbot@zytor.com>
Message-ID: <tip-8d2af85e87eda746ff50801f5decd8aed9aed28e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, arnd@arndb.de,
        hpa@zytor.com, mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, arnd@arndb.de,
        grant.likely@linaro.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <12285212.fBJyVfk69p@wuerfel>
References: <12285212.fBJyVfk69p@wuerfel>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] ARM: iop13xx: fix msi support with sparse IRQ
Git-Commit-ID: 8d2af85e87eda746ff50801f5decd8aed9aed28e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8d2af85e87eda746ff50801f5decd8aed9aed28e
Gitweb:     http://git.kernel.org/tip/8d2af85e87eda746ff50801f5decd8aed9aed28e
Author:     Arnd Bergmann <arnd@arndb.de>
AuthorDate: Mon, 26 May 2014 17:12:10 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 26 May 2014 17:45:09 +0200

ARM: iop13xx: fix msi support with sparse IRQ

patch 37ebbcff7837 ("arm: iop13xx: Use sparse irqs for MSI") moved
iop13xx over to sparse IRQ support, but this broke the build for the
msi.c file, which now has to include mach/irqs.h itself.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lkml.kernel.org/r/12285212.fBJyVfk69p@wuerfel
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/arm/mach-iop13xx/msi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-iop13xx/msi.c b/arch/arm/mach-iop13xx/msi.c
index 655072d..e7730cf 100644
--- a/arch/arm/mach-iop13xx/msi.c
+++ b/arch/arm/mach-iop13xx/msi.c
@@ -23,6 +23,7 @@
 #include <linux/msi.h>
 #include <asm/mach/irq.h>
 #include <asm/irq.h>
+#include <mach/irqs.h>
 
 /* IMIPR0 CP6 R8 Page 1
  */
