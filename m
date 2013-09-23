Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3IWKN6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:13:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21843 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3IWKN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:13:56 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-48-524014628f84
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: ben-linux@fluff.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        t.figa@samsung.com, m.szyprowski@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] DT: S5P: If detected device tree skip irq init
Date: Mon, 23 Sep 2013 12:13:42 +0200
Message-id: <1379931222-29307-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphluLIzCtJLcpLzFFi42I5/e+xoG6SiEOQwdn51haT1h1gsuhdcJXN
	4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv81qcXnOK2WLtkbvsFutnvGZx4PJoae5h8/i76gWz
	x+Yl9R4H3+1h8ujbsorR4/MmuQC2KC6blNSczLLUIn27BK6Me6evshVMZK/4vDe2gbGJrYuR
	k0NCwETi/9F2VghbTOLCvfVAcS4OIYHpjBILP7SzgCSEBNqZJN78EQax2QTMJSY+2wQWFxGQ
	lGhq+MMMYjMLrGKSeDsrBMQWFrCX6OlaD1bDIqAqsf7RPLBlvAJ+EqeX3YFarCDx8/IJtgmM
	3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIfRM+kdjKsaLA4xCnAwKvHwRibaBwmx
	JpYVV+YeYpTgYFYS4fVjdQgS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9sSQ1OzW1
	ILUIJsvEwSnVwBjya6HV+sMyAsdsWHXlDNJeiXMstsp0YVeKkZb7dfw3Z+2e+kJD1V031hxy
	UhM1teR5Uyx8e+KnGrHNMheYTZ/lb6nbuvH86aT8b9aiPHdjA389Ze1TnCa/47/hguX6ezZp
	72IQ/fhvRkx6kvnNvcY5TbEK/82vXb17uOFjRE4Hn6blioDHGkosxRmJhlrMRcWJAGBEQoof	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It prevents from executing code already called by device tree.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/plat-samsung/s5p-irq-eint.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/plat-samsung/s5p-irq-eint.c b/arch/arm/plat-samsung/s5p-irq-eint.c
index faa6516..ebee4dc 100644
--- a/arch/arm/plat-samsung/s5p-irq-eint.c
+++ b/arch/arm/plat-samsung/s5p-irq-eint.c
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/gpio.h>
 #include <linux/irqchip/arm-vic.h>
+#include <linux/of.h>
 
 #include <plat/regs-irqtype.h>
 
@@ -202,6 +203,9 @@ static int __init s5p_init_irq_eint(void)
 {
 	int irq;
 
+	if (of_have_populated_dt())
+		return -ENODEV;
+
 	for (irq = IRQ_EINT(0); irq <= IRQ_EINT(15); irq++)
 		irq_set_chip(irq, &s5p_irq_vic_eint);
 
-- 
1.8.1.2

