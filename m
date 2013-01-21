Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3AURRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:17:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3AURR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:17:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: [PATCH 02/15] ARM: mvebu: build coherency_ll.S for arch=armv7-a
Date: Mon, 21 Jan 2013 17:15:55 +0000
Message-Id: <1358788568-11137-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358788568-11137-1-git-send-email-arnd@arndb.de>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:NKGlpfLDnBN9pv1qZPb7qv0Y5VYdRavw5riuCwp0Co9
 yXvNx6ZixPi8RFgXwFCDUtAhpu3fUK00xJJoUdZI7e284ByMR9
 5cH5iphRgSlPMLRSaCJeNTCFeAQxBr4NjGB/OGujee7IZDUDRD
 XYXRvSJKk0tY+sQ0+asX9t6grXwIW1cDdflTJO46wNzaY7iBYJ
 XsgHGyu5TVv6sZ0nMs8o4iOxHY3r0pkkCjx3TpXGXcNY1YSZoX
 BHKF8M65tl7KS+WhJmOjfd7Z0V5h0v3eMc/jtbExvSKDMhophE
 OwY7awsrHqwhQa23ztsFoeqRf7CahmrrHSHaRx2+3Jkukk/kII
 sSmR21DeAfStmHJUF4FCqd14CiahaIzdwGpalXWbS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a multiplatform kernel, one can enable mach-mvebu
together with one or more ARMv6 platforms, which leads
to all files being built for v6. The coherency_ll.S
uses the "dsb" instruction that is only available for
v7, causing a build error in this case. Since the
file is only used on v7 based machines, it is safe
to build it using an ".arch armv7-a" statement.

Without this patch, building allyesconfig results in:

arch/arm/mach-mvebu/coherency_ll.S: Assembler messages:
arch/arm/mach-mvebu/coherency_ll.S:45: Error: selected processor does not support ARM mode `dsb'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/coherency_ll.S |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-mvebu/coherency_ll.S b/arch/arm/mach-mvebu/coherency_ll.S
index 53e8391..7648bda 100644
--- a/arch/arm/mach-mvebu/coherency_ll.S
+++ b/arch/arm/mach-mvebu/coherency_ll.S
@@ -25,6 +25,7 @@
  * r0: Coherency fabric base register address
  * r1: HW CPU id
  */
+	.arch armv7-a
 ENTRY(ll_set_cpu_coherent)
 	/* Create bit by cpu index */
 	mov	r3, #(1 << 24)
-- 
1.7.10.4

