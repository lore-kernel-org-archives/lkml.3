Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaDRICF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:02:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13907 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaDRH7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 03:59:12 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-52-5350db4fa6ec
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v3 3/7] arm64: Introduce a kernel configuration option for
 VA_BITS
Date: Fri, 18 Apr 2014 16:59:10 +0900
Message-id: <000401cf5adc$15147180$3f3d5480$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9a1JRat0vdpPpLScqPvatVAM6zLg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsVy+t8zI13/2wHBBtd3CVr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG
	9O6FbAWTeSuet19namC8ztXFyMkhIWAisbzrEhOELSZx4d56ti5GLg4hgWWMElduv2eHKXo5
	5y2YLSQwnVFizZskCPsPo8TRk+UgNpuApsSjuz3sIM0iAjsYJSavXcQK4jALPGSU+Pl2PzNI
	lbBAiMT2h1PB1rEIqErsefwFLM4rYCkx/eF0dghbUOLH5HssIDazgJbE+p3HmSBseYnNa94y
	Q1ykILHj7GtGEFtEQE9iT8scqHoRiX0v3jGCLJYQaOWQ+HnnJQvEMgGJb5MPAdkcQAlZiU0H
	oOZIShxccYNlAqPYLCSrZyFZPQvJ6llIVixgZFnFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJ
	ERLVvTsYbx+wPsSYDLR+IrOUaHI+MCnklcQbGpsZWZiamBobmVuakSasJM6b9DApSEggPbEk
	NTs1tSC1KL6oNCe1+BAjEwenVAPjjEzjLbnzX7hml9T9vhFSV7g0MrbZZPo580usS3y+Oed+
	EeTWO132JlP/1sNX1zbtdd91qEFA56qbT/LM41cOBb5KYjz/7aCC3kvLrUUOtstO2uvasZ9o
	vu1uaXj7fP/1dVqM94olFb5NFpXpMDre7H9lQYfrovsNmyo+5a0/c63+eMKm1X06SizFGYmG
	WsxFxYkAB01j8gADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jQV3/2wHBBjNW8lr8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WKecvYLD7MWMno
	wOOxZt4aRo/fvyYxety5tofN4/ymNcwem5fUe/RtWcXo8XmTXAB7VAOjTUZqYkpqkUJqXnJ+
	SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QpUoKZYk5pUChgMTiYiV9O0wT
	QkPcdC1gGiN0fUOC4HqMDNBAwjrGjOndC9kKJvNWPG+/ztTAeJ2ri5GTQ0LAROLlnLfsELaY
	xIV769lAbCGB6YwSa94kQdh/GCWOniwHsdkENCUe3e0BqufiEBHYwSgxee0iVhCHWeAho8TP
	t/uZQaqEBUIktj+cygRiswioSux5/AUszitgKTH94XR2CFtQ4sfkeywgNrOAlsT6nceZIGx5
	ic1r3jJDXKQgsePsa0YQW0RAT2JPyxyoehGJfS/eMU5gFJiFZNQsJKNmIRk1C0nLAkaWVYyi
	qQXJBcVJ6bmGesWJucWleel6yfm5mxjBKeOZ1A7GlQ0WhxgFOBiVeHgF9AKChVgTy4orcw8x
	SnAwK4nwKpcChXhTEiurUovy44tKc1KLDzEmA306kVlKNDkfmM7ySuINjU3MjCyNzCyMTMzN
	SRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoHR2eTFmf7A64x5c+6tOXBEIifP6X9uickf
	D6Xb715KXHo6ezF7sE3c9Xsuhan7bPPYr4mdO7e0LkTiyNxb+VHFXsW7X3wUi7GQkI0XDanU
	mrKv1bP0SNfFN+u590aEPH1SsLR47duwb0oeXCfjs8OXXGev/8uRmXLe3OemvtPfuZdORPrO
	PM2sxFKckWioxVxUnAgAHPL3PF0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a kernel configuration for VA_BITS.

It helps to prevent unnecessary #ifdef statements insertions
for VA_BITS when implementing different page sizes and level of
translation tables.

Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
---
 arch/arm64/Kconfig              |    8 ++++++++
 arch/arm64/include/asm/memory.h |    6 +-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1a2faf9..431acbc 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -186,6 +186,14 @@ config ARM64_3_LEVELS
 
 endchoice
 
+config ARM64_VA_BITS
+	int "Virtual address space size"
+	range 39 39 if ARM64_4K_PAGES && ARM64_3_LEVELS
+	range 42 42 if ARM64_64K_PAGES && ARM64_2_LEVELS
+	help
+	  This feature is determined by a combination of page size and
+	  level of translation tables.
+
 config CPU_BIG_ENDIAN
        bool "Build big-endian kernel"
        help
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index e94f945..f6e7480 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -41,11 +41,7 @@
  * The module space lives between the addresses given by TASK_SIZE
  * and PAGE_OFFSET - it must be within 128MB of the kernel text.
  */
-#ifdef CONFIG_ARM64_64K_PAGES
-#define VA_BITS			(42)
-#else
-#define VA_BITS			(39)
-#endif
+#define VA_BITS			(CONFIG_ARM64_VA_BITS)
 #define PAGE_OFFSET		(UL(0xffffffffffffffff) << (VA_BITS - 1))
 #define MODULES_END		(PAGE_OFFSET)
 #define MODULES_VADDR		(MODULES_END - SZ_64M)
-- 
1.7.10.4


