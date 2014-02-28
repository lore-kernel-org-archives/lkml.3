Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaB1NLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:11:00 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53627 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751581AbaB1NJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:09:02 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 2/3] arm64: Extend the PCI I/O space to 16MB
Date: Fri, 28 Feb 2014 13:08:32 +0000
Message-Id: <1393592913-24796-3-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393592913-24796-1-git-send-email-Liviu.Dudau@arm.com>
References: <1393592913-24796-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

The patch moves the PCI I/O space (currently at 64K) before the
earlyprintk mapping and extends it to 16MB.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/Documentation/arm64/memory.txt b/Documentation/arm64/memory.txt
index 5e054bf..85e24c4 100644
--- a/Documentation/arm64/memory.txt
+++ b/Documentation/arm64/memory.txt
@@ -35,11 +35,13 @@ ffffffbc00000000	ffffffbdffffffff	   8GB		vmemmap
 
 ffffffbe00000000	ffffffbffbbfffff	  ~8GB		[guard, future vmmemap]
 
-ffffffbffbc00000	ffffffbffbdfffff	   2MB		earlyprintk device
+ffffffbffa000000	ffffffbffaffffff	  16MB		PCI I/O space
+
+ffffffbffb000000	ffffffbffbbfffff	  12MB		[guard]
 
-ffffffbffbe00000	ffffffbffbe0ffff	  64KB		PCI I/O space
+ffffffbffbc00000	ffffffbffbdfffff	   2MB		earlyprintk device
 
-ffffffbffbe10000	ffffffbcffffffff	  ~2MB		[guard]
+ffffffbffbe00000	ffffffbffbffffff	   2MB		[guard]
 
 ffffffbffc000000	ffffffbfffffffff	  64MB		modules
 
@@ -60,11 +62,13 @@ fffffdfc00000000	fffffdfdffffffff	   8GB		vmemmap
 
 fffffdfe00000000	fffffdfffbbfffff	  ~8GB		[guard, future vmmemap]
 
-fffffdfffbc00000	fffffdfffbdfffff	   2MB		earlyprintk device
+fffffdfffa000000	fffffdfffaffffff	  16MB		PCI I/O space
+
+fffffdfffb000000	fffffdfffbbfffff	  12MB		[guard]
 
-fffffdfffbe00000	fffffdfffbe0ffff	  64KB		PCI I/O space
+fffffdfffbc00000	fffffdfffbdfffff	   2MB		earlyprintk device
 
-fffffdfffbe10000	fffffdfffbffffff	  ~2MB		[guard]
+fffffdfffbe00000	fffffdfffbffffff	   2MB		[guard]
 
 fffffdfffc000000	fffffdffffffffff	  64MB		modules
 
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 4cc813e..7846a6b 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -121,7 +121,7 @@ static inline u64 __raw_readq(const volatile void __iomem *addr)
  *  I/O port access primitives.
  */
 #define IO_SPACE_LIMIT		0xffff
-#define PCI_IOBASE		((void __iomem *)(MODULES_VADDR - SZ_2M))
+#define PCI_IOBASE		((void __iomem *)(MODULES_VADDR - SZ_32M))
 
 static inline u8 inb(unsigned long addr)
 {
-- 
1.9.0

