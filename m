Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105AbaLBWGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:06:05 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38963 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaLBWGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:06:04 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: arm: mach-davinci: serial.c:  Cleaning up function that are not used anywhere
Date: Tue,  2 Dec 2014 23:08:40 +0100
Message-Id: <1417558120-26540-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove function serial_read_reg() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/arm/mach-davinci/serial.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm/mach-davinci/serial.c b/arch/arm/mach-davinci/serial.c
index 5e93a73..951b620 100644
--- a/arch/arm/mach-davinci/serial.c
+++ b/arch/arm/mach-davinci/serial.c
@@ -31,16 +31,6 @@
 #include <mach/serial.h>
 #include <mach/cputype.h>
 
-static inline unsigned int serial_read_reg(struct plat_serial8250_port *up,
-					   int offset)
-{
-	offset <<= up->regshift;
-
-	WARN_ONCE(!up->membase, "unmapped read: uart[%d]\n", offset);
-
-	return (unsigned int)__raw_readl(up->membase + offset);
-}
-
 static inline void serial_write_reg(struct plat_serial8250_port *p, int offset,
 				    int value)
 {
-- 
1.7.10.4

