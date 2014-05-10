Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaEJGi3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 02:38:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44373 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaEJGiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 02:38:24 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-a8-536dc95e646a
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v4 01/11] ARM: EXYNOS: Make exynos machine_ops as static
Date: Sat, 10 May 2014 15:56:28 +0900
Message-id: <1399704998-13321-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399704998-13321-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t8zI924k7nBBjduGlssm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYInisklJzcksSy3St0vgyjh6ZwFbwQH+ise3ShsYO3m7GDk4JARMJFbfEeti
	5AQyxSQu3FvP1sXIxSEksIxRYv2ec8wwNVM3qUHEpzNKvHrZxgThtDFJLJ/ZwgzSzSagK/Hk
	/VwwW0QgW+JK431mkCJmgd2MEo2N89hAEsICHhKrGycxgUxlEVCV+NRbBxLmBQrffPWADWKZ
	gsScSTYgYU4BT4mvXxczgdhCQCUPupeCjZQQWMUucfDzTbBdLAICEt8mH2KB6JWV2HSAGeIZ
	SYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJOD7dzDePWB9iDEZaNxE
	ZinR5HxgxOSVxBsamxlZmJqYGhuZW5qRJqwkznv/YVKQkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBsbyGUw/31V0nslv33WRdfadb1LLxSzfHOkV91dR+MBUzBC3+Yhk+AGT3IOzl93+flAm
	tGjhj6lrn81gXLrDJ/4dc37cmf1W72yqZyQICksxdmRWLc56r1ddWj1d7JPMjmnHmx3Ur+46
	VKp+vjn0rPiEff/ecVRqr2jkjln/TI3lvObf6Vwuu4yVWIozEg21mIuKEwEi5CdXjgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jQd24k7nBBlt+6Vksm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLBY3n21nstjRsprFgcujpbmHzWPzknqP
	vi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hx9M4CtoID
	/BWPb5U2MHbydjFycEgImEhM3aTWxcgJZIpJXLi3nq2LkYtDSGA6o8Srl21MEE4bk8TymS3M
	IFVsAroST97PBbNFBLIlrjTeZwYpYhbYzSjR2DiPDSQhLOAhsbpxEhPIBhYBVYlPvXUgYV6g
	8M1XD9ggFitIzJlkAxLmFPCU+Pp1MROILQRU8qB7KfMERt4FjAyrGEVTC5ILipPSc430ihNz
	i0vz0vWS83M3MYIj6pn0DsZVDRaHGAU4GJV4eAvf5gQLsSaWFVfmHmKU4GBWEuFdcTA3WIg3
	JbGyKrUoP76oNCe1+BBjMtBNE5mlRJPzgdGeVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB
	9MSS1OzU1ILUIpgtTBycUg2Mob6ljr8CJ6xWf3MnoVrbtLls2651pS/TvPN/Ldwl27ghmOF9
	jNlH0x0BBSGs9j+mWxxkPW34NzYy7vxFrj0tN6bdMzMySmw89s/8jJnL8yWS9fqCrg/8w8su
	lh1RquY5HfhrctzX5oNGc68VRlzOOrrYXEs7XSx9zpeJf9rmL1JgPcjD8XSFEktxRqKhFnNR
	cSIAaIjJJ+wCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As machine function ops are used only in this file let's make
them static. Also remove unused and unwanted declarations from
common.h.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/common.h |    8 --------
 arch/arm/mach-exynos/exynos.c |    6 +++---
 2 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-exynos/common.h b/arch/arm/mach-exynos/common.h
index c8893b3..69739e4 100644
--- a/arch/arm/mach-exynos/common.h
+++ b/arch/arm/mach-exynos/common.h
@@ -15,15 +15,7 @@
 #include <linux/reboot.h>
 #include <linux/of.h>
 
-void mct_init(void __iomem *base, int irq_g0, int irq_l0, int irq_l1);
-
-struct map_desc;
 extern void __iomem *sram_ns_base_addr;
-void exynos_init_io(void);
-void exynos_restart(enum reboot_mode mode, const char *cmd);
-void exynos_cpuidle_init(void);
-void exynos_cpufreq_init(void);
-void exynos_init_late(void);
 
 void exynos_firmware_init(void);
 
diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 7d9d8762..bf8a473 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -148,7 +148,7 @@ static struct map_desc exynos5_iodesc[] __initdata = {
 	},
 };
 
-void exynos_restart(enum reboot_mode mode, const char *cmd)
+static void exynos_restart(enum reboot_mode mode, const char *cmd)
 {
 	struct device_node *np;
 	u32 val = 0x1;
@@ -189,7 +189,7 @@ void __init exynos_cpufreq_init(void)
 	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
 }
 
-void __init exynos_init_late(void)
+static void __init exynos_init_late(void)
 {
 	if (of_machine_is_compatible("samsung,exynos5440"))
 		/* to be supported later */
@@ -236,7 +236,7 @@ static void __init exynos_map_io(void)
 		iotable_init(exynos5_iodesc, ARRAY_SIZE(exynos5_iodesc));
 }
 
-void __init exynos_init_io(void)
+static void __init exynos_init_io(void)
 {
 	debug_ll_io_init();
 
-- 
1.7.10.4

