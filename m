Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbaEMNGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:06:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12433 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760593AbaEMNGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:06:36 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-af-537218dae101
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com, t.figa@samsung.com
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, ben-linux@fluff.org,
        arnd@arndb.de, olof@lixom.net, marc.zyngier@arm.com,
        thomas.abraham@linaro.org, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, sajjan.linux@gmail.com,
        tushar.behera@linaro.org, sachin.kamat@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv5 2/5] ARM: EXYNOS: Support secondary CPU boot of Exynos3250
Date: Tue, 13 May 2014 22:05:05 +0900
Message-id: <1399986308-23744-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com>
References: <1399986308-23744-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsWyRsSkUPe2RFGwQf8bVou/k46xW0xad4DJ
	4vJ+bYvrX56zWsw/co7V4vOHFqD4/QksFr0LrrJZnG16w26x6fE1VovLu+awWcw4v4/J4vZl
	Xou/d/6xWZy6/pnN4uSfXkaLJ4c/slrMmPySzWL9jNcsFsdmLGG0aP+7l81i787JjA5iHmvm
	rWH0aGnuYfP4/WsSo8ffVS+YPXbOusvucefaHjaPzUvqPa6caGL16NuyitHj8ya5AK4oLpuU
	1JzMstQifbsErowdO6+xFVzgqpj/9TZ7A+Ntji5GTg4JAROJrj93mSBsMYkL99azgdhCAksZ
	JZa8LIKp+dH6EijOBRRfxCjRdvIbE4TTxCTRfmgdWAebgJbE/hc3wGwRAV2JKTPvsILYzAKt
	LBJ9W2pAbGEBH4nTT++zg9gsAqoSW/sbWUBsXgFXib93jjJCbJOT+LDnEVgNp4CbxK/bLewQ
	F7lKLDt7F2yxhMBSDokNH+ZADRKQ+Db5ENAgDqCErMSmA8wQcyQlDq64wTKBUXgBI8MqRtHU
	guSC4qT0IlO94sTc4tK8dL3k/NxNjMBIPf3v2cQdjPcPWB9iTAYaN5FZSjQ5HxjpeSXxhsZm
	RhamJqbGRuaWZqQJK4nzpj9KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuC3bYsv5dku+
	mTvrorzudQY3NZhz68jOrFueLb9fZk5nydbwyM/rxLYYeybeSGeey36lvnrFaqcbfze1XnK3
	WMI5S+X9I+XwzctkP9119TuferzziibvtkTdtdcXfRN9IP1RdmHJXMaw4zOmhvJycVw8H3l6
	g50qs3hP+pyjGdPnFE1uv+NYrcRSnJFoqMVcVJwIAKokkePqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAd1bEkXBBs/bLCz+TjrGbjFp3QEm
	i8v7tS2uf3nOajH/yDlWi88fWoDi9yewWPQuuMpmcbbpDbvFpsfXWC0u75rDZjHj/D4mi9uX
	eS3+3vnHZnHq+mc2i5N/ehktnhz+yGoxY/JLNov1M16zWBybsYTRov3vXjaLvTsnMzqIeayZ
	t4bRo6W5h83j969JjB5/V71g9tg56y67x51re9g8Ni+p97hyoonVo2/LKkaPz5vkAriiGhht
	MlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4AeVVIoS8wp
	BQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBm7Nh5ja3gAlfF/K+32RsYb3N0MXJy
	SAiYSPxofckGYYtJXLi3Hsjm4hASWMQo0XbyGxOE08Qk0X5oHVgVm4CWxP4XN8BsEQFdiSkz
	77CC2MwCrSwSfVtqQGxhAR+J00/vs4PYLAKqElv7G1lAbF4BV4m/d44yQmyTk/iw5xFYDaeA
	m8Sv2y1gthBQzbKzd5kmMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcCJ5J7WBc
	2WBxiFGAg1GJh/encWGwEGtiWXFl7iFGCQ5mJRFe909AId6UxMqq1KL8+KLSnNTiQ4zJQFdN
	ZJYSTc4HJqm8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamC0
	YBJ8Fdpw2Ej+3uMX13ZxdakbNy7eL31LzTvj6R5TuVmiqZOa0sT+Zae+uG1x5v3hwN9r/KOD
	PjOoCVTezxN08Sz/M0c8cNb8zWkb5TglWKSnb9/Cq8rXZrfN87nChaCCeScTVwW+XdDROy0m
	W9VjsuK06XrH+u/vXL8zLNN8bsmyrRv4Sx2UWIozEg21mIuKEwE1VpOxSAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the offset of CPU boot address and don't need to send smc call
of SMC_CMD_CPU1BOOT command for secondary CPU boot because Exynos3250 removes
WFE in secure mode.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/firmware.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/firmware.c b/arch/arm/mach-exynos/firmware.c
index 739bdc8..eb91d23 100644
--- a/arch/arm/mach-exynos/firmware.c
+++ b/arch/arm/mach-exynos/firmware.c
@@ -30,6 +30,13 @@ static int exynos_do_idle(void)
 static int exynos_cpu_boot(int cpu)
 {
 	/*
+	 * Exynos3250 doesn't need to send smc command for secondary CPU boot
+	 * because Exynos3250 removes WFE in secure mode.
+	 */
+	if (soc_is_exynos3250())
+		return 0;
+
+	/*
 	 * The second parameter of SMC_CMD_CPU1BOOT command means CPU id.
 	 * But, Exynos4212 has only one secondary CPU so second parameter
 	 * isn't used for informing secure firmware about CPU id.
@@ -50,7 +57,7 @@ static int exynos_set_cpu_boot_addr(int cpu, unsigned long boot_addr)
 
 	boot_reg = sysram_ns_base_addr + 0x1c;
 
-	if (!soc_is_exynos4212())
+	if (!soc_is_exynos4212() && !soc_is_exynos3250())
 		boot_reg += 4*cpu;
 
 	__raw_writel(boot_addr, boot_reg);
-- 
1.8.0

