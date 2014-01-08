Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbaAHN3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:29:36 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:14025 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbaAHN3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:29:32 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-ae-52cd52ba142a
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        kgene.kim@samsung.com
Cc: will.deacon@arm.com, sboyd@codeaurora.org,
        gregory.clement@free-electrons.com, catalin.marinas@arm.com,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        David Garbett <david.garbett@arm.com>
Subject: [PATCH] arm: Add Arm Erratum 773769 for Large data RAM latency.
Date: Wed, 08 Jan 2014 19:03:11 +0530
Message-id: <1389187991-26446-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmkeLIzCtJLcpLzFFi42JZI2JSq7sr6GyQwewTlhbvl/UwWrz9sovZ
	4uyyg2wWbVcOsltsanvLaNG74CqbxabH11gtLu+aw2Yx4/w+Jovbl3ktvm7ZzWjx40w3i8XL
	jydYHHg91sxbw+jR0tzD5jG74SKLx+W+XiaPJ5suMnpsXlLv0bdlFaPH501yARxRXDYpqTmZ
	ZalF+nYJXBn/13IUTDKpuLjsNFsDY7NGFyMnh4SAicTKZ2/ZIWwxiQv31rN1MXJxCAksZZR4
	cOseG0zR2VXXoRKLGCW+Tm1jh3D6mCRWXHgJVsUmoCvR9HYXI0hCRGAOo8S5R/uZQRxmkKqp
	N+6AVQkLeEhMWLoFbCGLgKrEvhn/GUFsXqD4y033oA5RlOh+NgFsn4TAPnaJn5tOMUI0CEh8
	m3yIpYuRAyghK7HpADNEvaTEwRU3WCYwCi5gZFjFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJ
	ERgRp/89693BePuA9SHGZKBxE5mlRJPzgRGVVxJvaGxmZGFqYmpsZG5pRpqwkjhv0sOkICGB
	9MSS1OzU1ILUovii0pzU4kOMTBycUg2MCdNvVBfrG0z40H5NaMWaNZcZNtgzz/Nkc9zBbtPn
	zNXm8d3cVKtrRUOE7qqCvqWfvnFwvw573buj45T2LzZj/t1KL6R6f6ZGv7qZtt3JvfwFc2ka
	r86XVXalz9eUbv7wa9e1NbmTPD4eaGHe/WQi//LEtDuWetx8BteqZ2xcIxktev1Zi7GsEktx
	RqKhFnNRcSIA6NgWfJ4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t9jAd1dQWeDDPbt0Ld4v6yH0eLtl13M
	FmeXHWSzaLtykN1iU9tbRoveBVfZLDY9vsZqcXnXHDaLGef3MVncvsxr8XXLbkaLH2e6WSxe
	fjzB4sDrsWbeGkaPluYeNo/ZDRdZPC739TJ5PNl0kdFj85J6j74tqxg9Pm+SC+CIamC0yUhN
	TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6WUmhLDGnFCgU
	kFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOY8X8tR8Ekk4qLy06zNTA2a3QxcnJICJhI
	nF11nQ3CFpO4cG89kM3FISSwiFHi69Q2dginj0lixYWXYFVsAroSTW93MYIkRATmMEqce7Sf
	GcRhBqmaeuMOWJWwgIfEhKVb2EFsFgFViX0z/jOC2LxA8Zeb7rFD7FOU6H42gW0CI/cCRoZV
	jKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMHx9kxqB+PKBotDjAIcjEo8vDfUzgQJsSaWFVfm
	HmKU4GBWEuHVUz4bJMSbklhZlVqUH19UmpNafIgxGWj7RGYp0eR8YCrIK4k3NDYxNzU2tTSx
	MDGzJE1YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbGFKbFGvcX2E+osN9qVcn2Zd/yhSe/
	lPCKe3Kl3F3mbn7Uqf0D35fchs+XLL+5bt9158qn6Veyyxj4S/lT3jJPD4u4Luh8j7PocpUL
	84Tg3pP72tdIeuzann5bwOJmfeGqA7feMzeltTcemqGbmf+7XDzi5c/VCo8/ih7/83bqadf3
	+h8KQj7dVGIpzkg01GIuKk4EALBiYIP7AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The erratum-773769 occurs on Arm Coretex-A15 (rev r2p0),
when L2 Data Ram latency is set to 4 cycles or more; or
when ACP is in use, or with L2 Data RAM slice configured.
Therefore, the effective latency as calculated in Table 7-2 of
Cotex-A15 (rev r2p0) trm should be 3 cycles or less.

On Exynos5250 based systems the effective data ram latency
is 4 cycles, since we have DATA_RAM_SETUP bit enabled (L2CTRL[5]=1b'1)
and DATA_RAM_LATENCY bits set to 0x2 (L2CTLR[2:0]=3b'010) therefore,
the effective L2 data RAM latency becomes 4 cycles.
So erratum '773769' occurs causing a corrupted L2 Cache.

This patch gives a workaround to the mentioned erratum, using below
mentioned algo:
----------------------------------------------------------------
if data RAM setup = 1
  then check if effective latency i.e (latency + setup + 1) > 3
  if 'true'
    then clear data RAM setup
      goto branch 'a'
if data RAM setup = 0
  a: then check if data RAM latency > 0x10
    if true then force data RAM latency = 0x10
----------------------------------------------------------------
so that the effective data RAM latency reduces to 3 cycles or less
and hence prevent hitting the erratum.

NOTE: The Exynos5250 based products have already been shipped, which
      makes it impossible to add the change in bootloader, so we are
      adding the required change in kernel.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Olof Johansson <olofj@chromium.org>
Cc: David Garbett <david.garbett@arm.com>
---
 arch/arm/Kconfig             |   15 ++++++++
 arch/arm/mach-exynos/Kconfig |    1 +
 arch/arm/mm/proc-v7.S        |   79 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c59fa19..2e6f36c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1250,6 +1250,21 @@ config ARM_ERRATA_751472
 	  operation is received by a CPU before the ICIALLUIS has completed,
 	  potentially leading to corrupted entries in the cache or TLB.
 
+config ARM_ERRATA_773769
+	bool "ARM errata: Large data RAM latencies can lead to rare data corruption"
+	depends on CPU_V7
+	help
+	  This option enables the workaround for the erratum 773769, which affects
+	  Cortex-A15 (rev r2p0).
+	  In systems with L2 Data RAM latency programmed to 4 or more cycles,
+	  or with ACP in use, or with a L2 Data RAM slice configured, it is
+	  possible that a rare collision between non-cacheable stores and
+	  L1 data cache evictions which can lead to data corruption in L2 cache
+	  or memory.
+	  This workaround is to configure an effective Data RAM latency of 3 or
+	  less. Also note that, if a Data RAM slice is configured in A15 then
+	  there is no workaround.
+
 config PL310_ERRATA_753970
 	bool "PL310 errata: cache sync operation may be faulty"
 	depends on CACHE_PL310
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 4c414af..29f505f 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -82,6 +82,7 @@ config SOC_EXYNOS5250
 	default y
 	depends on ARCH_EXYNOS5
 	select ARCH_HAS_BANDGAP
+	select ARM_ERRATA_773769
 	select PINCTRL_EXYNOS
 	select PM_GENERIC_DOMAINS if PM
 	select S5P_PM if PM
diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index bd17819..0674c4c 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -141,6 +141,49 @@ ENTRY(cpu_v7_do_resume)
 	mcr	p15, 0, r4, c10, c2, 0	@ write PRRR
 	mcr	p15, 0, r5, c10, c2, 1	@ write NMRR
 #endif	/* CONFIG_MMU */
+
+#ifdef CONFIG_ARM_ERRATA_773769
+	/* get the arm rev id */
+	mrc	p15, 0, r3, c0, c0, 0		@ read main ID register
+	and	r4, r3, #0xff000000		@ ARM?
+	teq	r4, #0x41000000
+	bne	8f
+	and	r5, r3, #0x00f00000		@ variant
+	and	r7, r3, #0x0000000f		@ revision
+	orr	r7, r7, r5, lsr #20-4		@ combine variant and revision
+	ubfx	r3, r3, #4, #12			@ primary part number
+
+	ldr	r4, =0x00000c0f			@ Cortex-A15 primary part number
+	teq	r3, r4
+	bne	8f
+
+	ALT_SMP(cmp r7, #0x21)			@ present prior to r2p1
+	ALT_UP_B(8f)
+	mrclt	p15, 0, r3, c1, c0, 0		@ read system control register
+	andlt	r3, r3, #0x4			@ mask for C bit
+	cmplt	r3, #0x0			@ check if cache is on/off
+	bne	8f				@ Do nothing when cache is on
+
+	mrceq	p15, 1, r5, c9, c0, 2		@ read L2 control register
+	andeq	r3, r5, #(1 << 5)		@ mask for data RAM setup
+	lsreq	r3, r3, #0x5
+	cmpeq	r3, #0x1			@ check if data RAM setup = 1
+	bne	9f
+	and	r4, r5, #0x7			@ mask for data RAM latency
+	add	r4, r4, r3
+	add	r4, r4, #0x1			@ effective latency
+	cmp	r4, #0x3
+	bicgt	r5, r5, #(1 << 5)		@ clear data RAM setup bit
+
+9:	and	r4, r5, #0x7			@ mask for data RAM latency
+	cmp	r4, #0x2			@ check if data RAM latency > 2
+	ble	10f
+	bic	r5, r5, #0x7			@ clear data RAM latency bits
+	orr	r5, r5, #0x2			@ force data RAM latency = 2
+10:	mcr	p15, 1, r5, c9, c0, 2		@ set L2 control register
+8:
+#endif
+
 	mrc	p15, 0, r4, c1, c0, 1	@ Read Auxiliary control register
 	teq	r4, r9			@ Is it already set?
 	mcrne	p15, 0, r9, c1, c0, 1	@ No, so write it
@@ -349,6 +392,42 @@ __v7_setup:
 	mcrle	p15, 0, r10, c1, c0, 1		@ write aux control register
 #endif
 
+#ifdef CONFIG_ARM_ERRATA_773769
+	ALT_SMP(cmp r6, #0x21)			@ present prior to r2p1
+	ALT_UP_B(5f)
+	mrclt	p15, 0, r3, c1, c0, 0		@ read system control register
+	andlt	r3, r3, #0x4			@ mask for C bit
+	cmplt	r3, #0x0			@ check if cache is on/off
+	bne	5f				@ Do nothing when cache is on
+	/*
+	 * if data RAM setup = 1
+	 * 	then check if effective latency i.e (latency + setup + 1) > 3
+	 *		if true then clear data RAM setup
+	 *		goto branch 'a'
+	 * if data RAM setup = 0
+	 *	a: then check if data RAM latency > 0x10
+	 *		if true then force data RAM latency = 0x10
+	 */
+	mrceq	p15, 1, r5, c9, c0, 2		@ read L2 control register
+	andeq	r3, r5, #(1 << 5)		@ mask for data RAM setup
+	lsreq	r3, r3, #0x5
+	cmpeq	r3, #0x1			@ check if data RAM setup = 1
+	bne	6f
+	and	r10, r5, #0x7			@ mask for data RAM latency
+	add	r10, r10, r3
+	add	r10, r10, #0x1			@ effective latency
+	cmp	r10, #0x3
+	bicgt	r5, r5, #(1 << 5)		@ clear data RAM setup bit
+
+6:	and	r10, r5, #0x7			@ mask for data RAM latency
+	cmp	r10, #0x2			@ check if data RAM latency > 2
+	ble	7f
+	bic	r5, r5, #0x7			@ clear data RAM latency bits
+	orr	r5, r5, #0x2			@ force data RAM latency = 2
+7:	mcr	p15, 1, r5, c9, c0, 2		@ set L2 control register
+5:
+#endif
+
 4:	mov	r10, #0
 	mcr	p15, 0, r10, c7, c5, 0		@ I+BTB cache invalidate
 	dsb
-- 
1.7.10.4

