Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaLEXGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:06:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbaLEXGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:06:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Huacai Chen <chenhc@lemote.com>,
        Markos Chandras <Markos.Chandras@imgtec.com>
Subject: [PATCH 3.10 02/45] MIPS: Loongson: Make platform serial setup always built-in.
Date: Fri,  5 Dec 2014 14:44:45 -0800
Message-Id: <20141205223317.138391667@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223316.738290875@linuxfoundation.org>
References: <20141205223316.738290875@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/loongson/common/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/mips/loongson/common/Makefile
+++ b/arch/mips/loongson/common/Makefile
@@ -10,7 +10,8 @@ obj-$(CONFIG_GPIOLIB) += gpio.o
 # Serial port support
 #
 obj-$(CONFIG_EARLY_PRINTK) += early_printk.o
-obj-$(CONFIG_SERIAL_8250) += serial.o
+loongson-serial-$(CONFIG_SERIAL_8250) := serial.o
+obj-y += $(loongson-serial-m) $(loongson-serial-y)
 obj-$(CONFIG_LOONGSON_UART_BASE) += uart_base.o
 obj-$(CONFIG_LOONGSON_MC146818) += rtc.o
 


