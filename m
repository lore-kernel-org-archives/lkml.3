Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbaGGBx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 21:53:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:51346 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaGGBx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 21:53:26 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-a6-53b9fd895028
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux@arm.linux.org.uk
Cc: santosh.shilimkar@ti.com, will.deacon@arm.com, catalin.marinas@arm.com,
        akpm@linux-foundation.org, damm@opensource.se,
        ard.biesheuvel@linaro.org, olof@lixom.net, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH] ARM: Use 'model' property to set machine_name from Device Tree
Date: Mon, 07 Jul 2014 10:53:11 +0900
Message-id: <1404697991-32191-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkQLfz785gg87FhhZz1q9hs/j/YTej
	xftlPYwW1788Z7W4//gWk8XZpjfsFpseX2O1uLxrDpvF7cu8Fqeuf2azeN23htlixuSXbBYv
	P55gceD1WDNvDaNHS3MPm8eda3vYPE7M+M3isXlJvceVE02sHit/XGL36NuyitHj+I3tTB6f
	N8kFcEVx2aSk5mSWpRbp2yVwZZw88pqpYAlbxe23fewNjAtYuxg5OSQETCR6+i+wQdhiEhfu
	rQeyuTiEBJYySnzbtIu5i5EDrGjbdkuQGiGB6YwSrUvNIWqamCTOP77OCJJgE9CS2P/iBtgg
	EQEpiRk7l7KDFDELnGSSaPjSyAySEBbwl3jffAmsgUVAVaL52mQWEJtXwFVi2Z0eJogr5CQ+
	7HnEDmFfYpdYfUoTol5A4tvkQywQB8lKbDrADFEiKXFwxQ2WCYyCCxgZVjGKphYkFxQnpReZ
	6hUn5haX5qXrJefnbmIExsfpf88m7mC8f8D6EGMy0LiJzFKiyfnA+MoriTc0NjOyMDUxNTYy
	tzQjTVhJnDf9UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsa8f4fP7Mu5EngoWeCD0q7C
	OU/YTBNLpPkf7uy5+qasXPb86Ym2Ok3ilz2+JWsZ/6jPmJtrUWd8QUIhNXCTfF5jhKDbnr/W
	Z4x2Lt3gOtF7steJ/9dmNJ3baTh5/qy/a9e8rOl8u/lY5KtF/M8W7P3B96+uK+Dl58gtMu/P
	Ptz1JMzy0f/4RcL2SizFGYmGWsxFxYkAjf9psKUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t9jQd3OvzuDDTYf0bSYs34Nm8X/D7sZ
	Ld4v62G0uP7lOavF/ce3mCzONr1ht9j0+BqrxeVdc9gsbl/mtTh1/TObxeu+NcwWMya/ZLN4
	+fEEiwOvx5p5axg9Wpp72DzuXNvD5nFixm8Wj81L6j2unGhi9Vj54xK7R9+WVYwex29sZ/L4
	vEkugCuqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0z
	B+h4JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGySOvmQqWsFXcftvH
	3sC4gLWLkYNDQsBEYtt2yy5GTiBTTOLCvfVsILaQwHRGidal5l2MXEB2E5PE+cfXGUESbAJa
	Evtf3AArEhGQkpixcyk7SBGzwEkmiYYvjcwgCWEBf4n3zZfAGlgEVCWar01mAbF5BVwllt3p
	YYLYJifxYc8j9gmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMffM+kdjKsaLA4x
	CnAwKvHwHli1M1iINbGsuDL3EKMEB7OSCO8ZN6AQb0piZVVqUX58UWlOavEhRlOg7ROZpUST
	84GpIa8k3tDYxMzI0sjc0MLI2FxJnPdgq3WgkEB6YklqdmpqQWoRTB8TB6dUA6OVnuuiCX8b
	FmUu3Vyq+7w+1tjDJ40v78dH9f8y766/4LujOVlk8eppXLJH3MqYwyvvWDvJdxdqqcxPur/q
	oLiS/IagkM+TPpmtC5jcE2/r3bhbXr2e9XDZx5uOkr1e59jmLLqx/tfDRw1P5iy8X2Lx/E37
	gjdOruISuZpH3iS9X7nuTK9rhIYSS3FGoqEWc1FxIgDhsQ9R1QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use 'model' property from Device Tree to set machine_name.
The arm64 has already got the machine_name from Device Tree.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/kernel/setup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 8a16ee5..698616f 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -878,7 +878,11 @@ void __init setup_arch(char **cmdline_p)
 	if (!mdesc)
 		mdesc = setup_machine_tags(__atags_pointer, __machine_arch_type);
 	machine_desc = mdesc;
+#if CONFIG_OF
+	machine_name = of_flat_dt_get_machine_name();
+#else
 	machine_name = mdesc->name;
+#endif
 
 	if (mdesc->reboot_mode != REBOOT_HARD)
 		reboot_mode = mdesc->reboot_mode;
-- 
1.8.0

