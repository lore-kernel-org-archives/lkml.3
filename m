Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbaJaFlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 01:41:53 -0400
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:5776 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753002AbaJaFlw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 01:41:52 -0400
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Ard Biesheuvel'" <ard.biesheuvel@linaro.org>
CC: "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'akinobu.mita@gmail.com'" <akinobu.mita@gmail.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'Joe Perches'" <joe@perches.com>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 31 Oct 2014 13:41:48 +0800
Subject: [RFC V6 3/3] arm64:add bitrev.h file to support rbit instruction
Thread-Topic: [RFC V6 3/3] arm64:add bitrev.h file to support rbit
 instruction
Thread-Index: Ac/0SYsLYyTdMNPAS1SmHcF7f8oZ+gAcg3/QAARpyNA=
Message-ID: <35FD53F367049845BC99AC72306C23D103E010D18274@CNBJMBX05.corpusers.net>
References: <1414392371.8884.2.camel@perches.com>
 <CAL_JsqJYBoG+nrr7R3UWz1wrZ--Xjw5X31RkpCrTWMJAePBgRg@mail.gmail.com>
 <35FD53F367049845BC99AC72306C23D103E010D1825F@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18260@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18261@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18264@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18265@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D103E010D18266@CNBJMBX05.corpusers.net>
 <20141030120127.GC32589@arm.com>
 <CAKv+Gu9g5Q6fjPUy+P8YxkeDrH+bdO4kKGnxTQZRFhQpgPxaPA@mail.gmail.com>
 <20141030135749.GE32589@arm.com>
 <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103E010D18272@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add bitrev.h file to support rbit instruction,
so that we can do bitrev operation by hardware.
Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 arch/arm64/Kconfig              |  1 +
 arch/arm64/include/asm/bitrev.h | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)
 create mode 100644 arch/arm64/include/asm/bitrev.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9532f8d..b1ec1dd 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -35,6 +35,7 @@ config ARM64
 	select HANDLE_DOMAIN_IRQ
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_AUDITSYSCALL
+	select HAVE_ARCH_BITREVERSE
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
diff --git a/arch/arm64/include/asm/bitrev.h b/arch/arm64/include/asm/bitrev.h
new file mode 100644
index 0000000..706a209
--- /dev/null
+++ b/arch/arm64/include/asm/bitrev.h
@@ -0,0 +1,21 @@
+#ifndef __ASM_ARM64_BITREV_H
+#define __ASM_ARM64_BITREV_H
+
+static __always_inline __attribute_const__ u32 __arch_bitrev32(u32 x)
+{
+	__asm__ ("rbit %w0, %w1" : "=r" (x) : "r" (x));
+	return x;
+}
+
+static __always_inline __attribute_const__ u16 __arch_bitrev16(u16 x)
+{
+	return __arch_bitrev32((u32)x) >> 16;
+}
+
+static __always_inline __attribute_const__ u8 __arch_bitrev8(u8 x)
+{
+	return __arch_bitrev32((u32)x) >> 24;
+}
+
+#endif
+
-- 
2.1.1
