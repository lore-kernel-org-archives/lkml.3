Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaDOCCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 22:02:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20238 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbaDOB7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:59:54 -0400
X-AuditID: cbfee68e-b7f566d000002344-52-534c9298b6e9
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk, ben-linux@fluff.org, kgene.kim@samsung.com,
        t.figa@samsung.com, thomas.abraham@linaro.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        sw0312.kim@samsung.com, hyunhee.kim@samsung.com, yj44.cho@samsung.com,
        chanho61.park@samsung.com, arnd@arndb.de, olof@lixom.net,
        marc.zyngier@arm.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCHv2 2/8] ARM: EXYNOS: Add IO mapping for non-secure SYSRAM of
 Exynos3250
Date: Tue, 15 Apr 2014 10:59:46 +0900
Message-id: <1397527192-21988-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
References: <1397527192-21988-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsWyRsSkSHfGJJ9gg7fbpCz+TjrGbjFp3QEm
	i8v7tS2uf3nOajH/yDlWi88fWtgtehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF7cu8Fn/v
	/GOzOHX9M1Bo8ks2i/UzXrNYHJuxhNFi787JjA5CHmvmrWH0aGnuYfP4/WsSo8ffVS+YPe5c
	28PmsXlJvceVE02sHn1bVjF6fN4kF8AZxWWTkpqTWZZapG+XwJUx5f1t1oI1QhWf52U2MB7l
	72Lk5JAQMJE4+n4rG4QtJnHh3nowW0hgKaNET78yTM2JzQuZuhi5gOKLGCVmPX3KCuE0MUnc
	f9TKBFLFJqAlsf/FDbBuEQEFic29z8CKmAXWMktcnNQIlhAWiJCYdmw/C4jNIqAq8enyD1YQ
	m1fAVWJ9RwsrxDo5iQ97HrGD2JwCbhJ77/9lhjgJqGb/bLAzJARaOSTOvvzBBjFIQOLb5ENA
	QzmAErISmw4wQ8yRlDi44gbLBEbhBYwMqxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzEC4+70
	v2d9OxhvHrA+xJgMNG4is5Rocj4wbvNK4g2NzYwsTE1MjY3MLc1IE1YS5130MClISCA9sSQ1
	OzW1ILUovqg0J7X4ECMTB6dUA6PRVEWtSSkzo18YdgV48xcZZszmLozd8c86KZp9f53p68mb
	F3drhz9QWrD6zL9cxrDVOwLFQh5/NtjxaN8Nnc6rLCZH7wbFG6pEneud+jnDZYf87VeN8tl+
	ElapXPNmfblv+VeQ7fnBq3t5Kz7F6vAY3JGf2/X4t77UtvfHHDur0xsespXsXqHEUpyRaKjF
	XFScCABA1fU80QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAd0Zk3yCDZp2CVr8nXSM3WLSugNM
	Fpf3a1tc//Kc1WL+kXOsFp8/tLBb9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaL25d5Lf7e
	+cdmcer6Z6DQ5JdsFutnvGaxODZjCaPF3p2TGR2EPNbMW8Po0dLcw+bx+9ckRo+/q14we9y5
	tofNY/OSeo8rJ5pYPfq2rGL0+LxJLoAzqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ
	19DSwlxJIS8xN9VWycUnQNctMwfoHyWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1G
	BmggYQ1jxpT3t1kL1ghVfJ6X2cB4lL+LkZNDQsBE4sTmhUwQtpjEhXvr2boYuTiEBBYxSsx6
	+pQVwmlikrj/qBWsik1AS2L/ixtsILaIgILE5t5nYEXMAmuZJS5OagRLCAtESEw7tp8FxGYR
	UJX4dPkHK4jNK+Aqsb6jhRVinZzEhz2P2EFsTgE3ib33/zKD2EIgNftnM01g5F3AyLCKUTS1
	ILmgOCk911CvODG3uDQvXS85P3cTIziun0ntYFzZYHGIUYCDUYmH12OCT7AQa2JZcWXuIUYJ
	DmYlEd7XyUAh3pTEyqrUovz4otKc1OJDjMlAV01klhJNzgemnLySeENjEzMjSyNzQwsjY3PS
	hJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYDwYv8fhdNSLnlfnPq6oSXy9j+37PKWJny5e
	4VmqlTP/+9sEPr3jfSFuEyW2vDoZ4ddWwLZLoH1+5XVJQ+mGowy7fu2zNHr3/+LsOKtYjrz1
	Hpqlj83PyT4VNEndXvfpPqv3/0emnxMEekMXROXGK0r0bPoh8dtuXYOz+bWIPJ/Yj32vUrb5
	1SmxFGckGmoxFxUnAgCgqiNALwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The non-secure SYSRAM is used for secondary CPU bring-up. This patch add
IO mapping for non-scure SYSRAM.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Arnd Bergmann suggested that need proper driver instead of static memory mapping.
As Chanho Park reply[2], Sachin Kamat already posted the DT support patch[1]
for memory mapping for SYSRAM.
[1] http://www.spinics.net/lists/linux-samsung-soc/msg27647.html
[2] https://lkml.org/lkml/2014/4/10/161

So, I'm going to re-implement following patch related to static memory mapping
after merged Sachin Kamat patch[1].
  ARM: EXYNOS: Add IO mapping for non-secure SYSRAM of Exynos3250

 arch/arm/mach-exynos/exynos.c           | 12 ++++++++++++
 arch/arm/mach-exynos/include/mach/map.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index a603dfa..c7c9472 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -35,6 +35,15 @@
 #define L2_AUX_VAL 0x7C470001
 #define L2_AUX_MASK 0xC200ffff
 
+static struct map_desc exynos3250_iodesc[] __initdata = {
+	{
+		.virtual	= (unsigned long)S5P_VA_SYSRAM_NS,
+		.pfn		= __phys_to_pfn(EXYNOS3_PA_SYSRAM_NS),
+		.length		= SZ_4K,
+		.type		= MT_DEVICE,
+	},
+};
+
 static struct map_desc exynos4_iodesc[] __initdata = {
 	{
 		.virtual	= (unsigned long)S3C_VA_SYS,
@@ -275,6 +284,9 @@ static int __init exynos_fdt_map_chipid(unsigned long node, const char *uname,
  */
 static void __init exynos_map_io(void)
 {
+	if (soc_is_exynos3250())
+		iotable_init(exynos3250_iodesc, ARRAY_SIZE(exynos3250_iodesc));
+
 	if (soc_is_exynos4())
 		iotable_init(exynos4_iodesc, ARRAY_SIZE(exynos4_iodesc));
 
diff --git a/arch/arm/mach-exynos/include/mach/map.h b/arch/arm/mach-exynos/include/mach/map.h
index 7b046b5..a53981b 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -26,6 +26,7 @@
 #define EXYNOS4_PA_SYSRAM0		0x02025000
 #define EXYNOS4_PA_SYSRAM1		0x02020000
 #define EXYNOS5_PA_SYSRAM		0x02020000
+#define EXYNOS3_PA_SYSRAM_NS		0x0205F000
 #define EXYNOS4210_PA_SYSRAM_NS		0x0203F000
 #define EXYNOS4x12_PA_SYSRAM_NS		0x0204F000
 #define EXYNOS5250_PA_SYSRAM_NS		0x0204F000
-- 
1.8.0

