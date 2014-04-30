Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbaD3E7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 00:59:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63351 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaD3E7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:40 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-96-5360833b7318
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 01/12] ARM: EXYNOS: Make exynos machine_ops as static
Date: Wed, 30 Apr 2014 14:17:26 +0900
Message-id: <1398835057-3860-2-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t8zA13r5oRggwv32CyWTbrLZtG74Cqb
	xabH11gtLu+aw2Yx4/w+Jovbl3ktFm39wm6xfsZrFoubz7YzWexoWc3iwOXR0tzD5rF5Sb1H
	35ZVjB6fN8kFsERx2aSk5mSWpRbp2yVwZUydeIWx4ClnRd/bC4wNjJM5uhg5OSQETCQ2LnjA
	DGGLSVy4t56ti5GLQ0hgGaPE9aWzGWGKLn/Zxg6RWMQo8WvpBKiqNiaJHav+grWzCehKPHk/
	F8wWEciWuNJ4nxmkiFlgN6NEY+M8oA4ODmEBD4mfE7xAalgEVCV2bT3ADmLzCrhLzGx6zw5S
	IiGgIDFnkg1ImBOoeuHt36wgthBQSUNDDyPISAmBVewSk3vXsUHMEZD4NvkQC0SvrMSmA1Df
	SEocXHGDZQKj8AJGhlWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIWHft4Px5gHrQ4zJQOMm
	MkuJJucD4yavJN7Q2MzIwtTE1NjI3NKMNGElcd5FD5OChATSE0tSs1NTC1KL4otKc1KLDzEy
	cXBKNTD2Cggef32iR+yBIcOvXJ/im5t0b0jKy9/IdVvest1mnc6OFMbpv6Uv37av7thvYDRl
	97fFLW4/nfbmFh0q0t65Xk5ZP0+TtfgP68QVd/bcceKdvGNqYiTPwdvmRal8h6sPMBac3i8v
	Vqeke/qsJfOXya/7TULyeyJSEoKYs6KEq02vbRCpXq3EUpyRaKjFXFScCAAsHeg2kQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV3r5oRgg5a/jBbLJt1ls+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wWi7Z+YbdYP+M1i8XNZ9uZLHa0rGZx4PJoae5h89i8pN6j
	b8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVc
	fAJ03TJzgO5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZMnXiFseAp
	Z0Xf2wuMDYyTOboYOTkkBEwkLn/Zxg5hi0lcuLeerYuRi0NIYBGjxK+lE6CcNiaJHav+MoNU
	sQnoSjx5PxfMFhHIlrjSeJ8ZpIhZYDejRGPjPKAODg5hAQ+JnxO8QGpYBFQldm09ALaBV8Bd
	YmbTe3aQEgkBBYk5k2xAwpxA1Qtv/2YFsYWAShoaehgnMPIuYGRYxSiaWpBcUJyUnmukV5yY
	W1yal66XnJ+7iREcVc+kdzCuarA4xCjAwajEwyuwNT5YiDWxrLgy9xCjBAezkgjv+cqEYCHe
	lMTKqtSi/Pii0pzU4kOMyUBHTWSWEk3OB0Z8Xkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE
	0hNLUrNTUwtSi2C2MHFwSjUwhl7xDMn65corO3edmpja3JjfoRuFW7pZxBUaNnrOnmF19ZAD
	xxm3+OyH7zi266/ILbpXN9VeSvI309xQ1hzrG8wH9XwaE56UPvNfeWV5E1OdK8PRa67vGS6W
	HVswf+85O73T1z538k6puKS8ZFZSV0Y3xwGxCuN9FZMzp07ymX07u9sqxrhRiaU4I9FQi7mo
	OBEAqRTX3u4CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As machine function ops are used only in this file let's make
them static.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/exynos.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 3d69e8d..06dcce5 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -198,7 +198,7 @@ static struct map_desc exynos5_iodesc[] __initdata = {
 	},
 };
 
-void exynos_restart(enum reboot_mode mode, const char *cmd)
+static void exynos_restart(enum reboot_mode mode, const char *cmd)
 {
 	struct device_node *np;
 	u32 val = 0x1;
@@ -239,7 +239,7 @@ void __init exynos_cpufreq_init(void)
 	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
 }
 
-void __init exynos_init_late(void)
+static void __init exynos_init_late(void)
 {
 	if (of_machine_is_compatible("samsung,exynos5440"))
 		/* to be supported later */
@@ -300,7 +300,7 @@ static void __init exynos_map_io(void)
 		iotable_init(exynos5250_iodesc, ARRAY_SIZE(exynos5250_iodesc));
 }
 
-void __init exynos_init_io(void)
+static void __init exynos_init_io(void)
 {
 	debug_ll_io_init();
 
-- 
1.7.10.4

