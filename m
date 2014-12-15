Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaLOOoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:44:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38787 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbaLOO2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, linux-mips@linux-mips.org,
        Huacai Chen <chenhc@lemote.com>,
        Markos Chandras <Markos.Chandras@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 109/168] MIPS: Loongson: Make platform serial setup always built-in.
Date: Mon, 15 Dec 2014 14:26:03 +0000
Message-Id: <1418653622-21105-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

commit 26927f76499849e095714452b8a4e09350f6a3b9 upstream.

If SERIAL_8250 is compiled as a module, the platform specific setup
for Loongson will be a module too, and it will not work very well.
At least on Loongson 3 it will trigger a build failure,
since loongson_sysconf is not exported to modules.

Fix by making the platform specific serial code always built-in.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reported-by: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Cc: Huacai Chen <chenhc@lemote.com>
Cc: Markos Chandras <Markos.Chandras@imgtec.com>
Patchwork: https://patchwork.linux-mips.org/patch/8533/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/loongson/common/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/loongson/common/Makefile b/arch/mips/loongson/common/Makefile
index 0bb9cc9dc621..d87e03330b29 100644
--- a/arch/mips/loongson/common/Makefile
+++ b/arch/mips/loongson/common/Makefile
@@ -11,7 +11,8 @@ obj-$(CONFIG_PCI) += pci.o
 # Serial port support
 #
 obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
-obj-$(CONFIG_SERIAL_8250) += serial.o
+loongson-serial-$(CONFIG_SERIAL_8250) := serial.o
+obj-y += $(loongson-serial-m) $(loongson-serial-y)
 obj-$(CONFIG_LOONGSON_UART_BASE) += uart_base.o
 obj-$(CONFIG_LOONGSON_MC146818) += rtc.o
 
-- 
2.1.3

