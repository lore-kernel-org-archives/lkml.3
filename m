Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaDPEd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 00:33:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10385 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaDPEdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 00:33:19 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-67-534e080ef0b1
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        steve.capper@linaro.org, sungjinn.chung@samsung.com,
        Arnd Bergmann <arnd@arndb.de>, kgene.kim@samsung.com,
        ilho215.lee@samsung.com
Subject: [PATCH v2 3/7] arm64: Introduce a kernel configuration option for
 VA_BITS
Date: Wed, 16 Apr 2014 13:33:18 +0900
Message-id: <004301cf592c$fdb00c80$f9102580$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9ZKy1VPlIXxfgIQrGg1Hw7n0197g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zI10+Dr9ggw9ntS3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9issmJTUnsyy1SN8ugStj
	evdCtoLJvBXP268zNTBe5+pi5OSQEDCRuPn7OyOELSZx4d56ti5GLg4hgWWMEtt+/WWGKTr6
	fQU7RGI6o8St+c1MIAkhgT+MEnePGoLYbAKaEo/u9oAViQjsYJSYvHYRK4jDLPCQUeLn2/1g
	o4QFQiTuT/3PAmKzCKhKbHk/iw3E5hWwlPj//gyULSjxY/I9sBpmAS2J9TuPM0HY8hKb17yF
	OklBYsfZ12B3iwjoSXzo3QVVIyKx78U7RpDFEgKdHBLznj9nhFgmIPFt8iGgoRxACVmJTQeg
	5khKHFxxg2UCo9gsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5kqFecmFtcmpeul5yfu4kR
	Ete9OxhvH7A+xJgMtH4is5Rocj4wLeSVxBsamxlZmJqYGhuZW5qRJqwkzpv0MClISCA9sSQ1
	OzW1ILUovqg0J7X4ECMTB6dUA2PvhboNUzbWpLqzJ/2a1WS+I9vylMUfVttlp0K8vQ3jNzPV
	Ltgo4btE4f55v0fcan1z/a4ZfvE4l8One+XpVYZPYve+XjolP/vQ2/AoIYunj2Wb318qcJ4c
	JOVvI+OZat3hvy//28q18/M13khczlLpO8V0VXJ9+G1lfXX3DqPf9fvrf3c8SlViKc5INNRi
	LipOBAB80HuHAQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jQV0+Dr9gg7dr1C3+TjrGbvF+WQ+j
	xYvX/xgtjv5byGjRu+Aqm8XHU8fZLTY9vsZqcXnXHDaLGef3MVn8vfOPzWLFvGVsFh9mrGR0
	4PFYM28No8fvX5MYPe5c28PmcX7TGmaPzUvqPfq2rGL0+LxJLoA9qoHRJiM1MSW1SCE1Lzk/
	JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoUiWFssScUqBQQGJxsZK+HaYJ
	oSFuuhYwjRG6viFBcD1GBmggYR1jxvTuhWwFk3krnrdfZ2pgvM7VxcjJISFgInH0+wp2CFtM
	4sK99WxdjFwcQgLTGSVuzW9mAkkICfxhlLh71BDEZhPQlHh0t4cdpEhEYAejxOS1i1hBHGaB
	h4wSP9/uZwapEhYIkbg/9T8LiM0ioCqx5f0sNhCbV8BS4v/7M1C2oMSPyffAapgFtCTW7zzO
	BGHLS2xe85YZ4iQFiR1nXzOC2CICehIfendB1YhI7HvxjnECo8AsJKNmIRk1C8moWUhaFjCy
	rGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIThrPpHYwrmywOMQowMGoxMM7I8c3WIg1say4
	MvcQowQHs5II75cvQCHelMTKqtSi/Pii0pzU4kOMyUCfTmSWEk3OBya0vJJ4Q2MTMyNLIzML
	IxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgnB5r4OnIKrzn+znuwysWJXkaXyyy
	ZBdSElKyFW5UDyxdovb78KYHr2esKyvcYGrREHf4/8OPj55cVLjCL6I7p8/O7PVe96anLysc
	Yl/OrXGe8vKoVt2dvP9bfIv3Ckx+mrXWzFTjUaKK3QXJhMIO11opUyHpwMCHcZM7j/7YOfHx
	qWRLxoowJZbijERDLeai4kQA/l5Cg14DAAA=
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


