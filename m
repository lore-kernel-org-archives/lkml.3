Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaEZPMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:12:45 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53803 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaEZPMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:12:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: iop13xx: fix msi support with sparse IRQ
Date: Mon, 26 May 2014 17:12:10 +0200
Message-ID: <12285212.fBJyVfk69p@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:fyurViAzxsLcgItJbqJclaOnfSlOKsex/W+BybRaSNT
 j0tSDU0ak+GXQFG2y52ckvIgu9ulTT/86YxEqLfnYSjV7ewP/j
 9/s1U8u2dgqaB7WVeGkOyV0uRRevMwPUyTK7aJQr/2RKzIn9IX
 8gASYHNeYb3no4fGYfRbAiwdseKZYEQksxY09m150vJbvoNh09
 WwAa43T1lJzdKc/PBmmnSXaWbbzAvHiJTOI4kOb9p6ACD9D/6j
 J1DJoZYDyDjKHPNocRK0rg0SALw15WSE8XciOMSdhX2SJb+A7j
 c1wF1v1j171ei/s3wPHJ+WmJU0aCWMeLBfIb3y5bdGcr9QhPXe
 GdBb4s/0AYiqH4AZidIc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch 37ebbcff7837 ("arm: iop13xx: Use sparse irqs for MSI") moved
iop13xx over to sparse IRQ support, but this broke the build for the
msi.c file, which now has to include mach/irqs.h itself.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Grant Likely <grant.likely@linaro.org>

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

