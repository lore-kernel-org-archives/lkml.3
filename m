Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644AbaDNHk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:40:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13857 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaDNHkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:40:52 -0400
X-AuditID: cbfee68e-b7f566d000002344-39-534b9103663d
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, Arnd Bergmann <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
Subject: [PATCH 4/8] arm64: Introduce a kernel configuration option for VA_BITS
Date: Mon, 14 Apr 2014 16:40:51 +0900
Message-id: <000201cf57b4$dbe63260$93b29720$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9XrUy/hcb4eczCQ7qwkj0Y19kvsA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zfV3mid7BBvt2SVv8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WHGSsZHbg91sxb
	w+jx+9ckRo871/aweZzftIbZY/OSeo++LasYPT5vkgtgj+KySUnNySxLLdK3S+DKmN69kK1g
	Mm/F8/brTA2M17m6GDk5JARMJH4/uccMYYtJXLi3nq2LkYtDSGAZo8TVdS2sXYwcYEWb1nNA
	xKczSlw6PpMFwvnDKHFg8mNGkG42AU2JR3d72EESIgI7GCUmr13ECuIwC5xglFh6Zy0rSJWw
	gL/E7IV3mEBsFgFVic5VP8DivAKWEg+eP4CyBSV+TL7HAmIzC2hJrN95nAnClpfYvOYt1K0K
	EjvOvgbbLCKgJ/HpCEQvs4CIxL4X7xhBFksItHJIPFj2DmqZgMS3yYdYIP6Rldh0AGqOpMTB
	FTdYJjCKzUKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCHR3LeD
	8eYB60OMyUDrJzJLiSbnA5NBXkm8obGZkYWpiamxkbmlGWnCSuK8ix4mBQkJpCeWpGanphak
	FsUXleakFh9iZOLglGpgXJlSKLzk14xlRtee/J15TSrumZBMoiDriZfPWLnlMhSWzgtJUGdz
	s8k/p6PCZMXxgbNcX0D/q0cJS9Yig7kLL8U/d7etKGp1FX98hbsy+r1qj5faM78mxmkMvTYz
	eZY/SZyZxnFxw4Utx2ZxObr19LBzZPGeeqzmMiN2aylj0oHYL9w/bK8qsRRnJBpqMRcVJwIA
	DdiTovwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jQV3mid7BBn9niVv8nXSM3eL9sh5G
	ixev/zFaHP23kNGid8FVNouPp46zW2x6fI3V4vKuOWwWM87vY7L4e+cfm8WHGSsZHbg91sxb
	w+jx+9ckRo871/aweZzftIbZY/OSeo++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV
	8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmDG9eyFbwWTeiuft15kaGK9zdTFycEgImEhsWs/RxcgJZIpJXLi3
	nq2LkYtDSGA6o8Sl4zNZIJw/jBIHJj9mBKliE9CUeHS3hx0kISKwg1Fi8tpFrCAOs8AJRoml
	d9ayglQJC/hLzF54hwnEZhFQlehc9QMszitgKfHg+QMoW1Dix+R7LCA2s4CWxPqdx5kgbHmJ
	zWveMkPcpCCx4+xrsM0iAnoSn45A9DILiEjse/GOcQKjwCwko2YhGTULyahZSFoWMLKsYhRN
	LUguKE5KzzXUK07MLS7NS9dLzs/dxAhOFc+kdjCubLA4xCjAwajEw5uw3TNYiDWxrLgy9xCj
	BAezkgjvtgyvYCHelMTKqtSi/Pii0pzU4kOMyUCfTmSWEk3OB6axvJJ4Q2MTMyNLIzMLIxNz
	c9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpg3OBRpHT+aZH88VTOXUFHpgY5Lg4vDsuv
	X3eK97Dimssf3BRjIp5+SuOa83tS6O7lD37o3DFJXKkrI8PpacVh1Tsn32CiG7M9+1XfvL1T
	RKW6anfaGx+9mntCj9klK+7TpfPHZaKk5RN8LDYqrzZfVsHR99PlQN6Two9yXt8nPOdRuSt9
	M3axEktxRqKhFnNRcSIAUGecA1kDAAA=
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


