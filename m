Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaHYHbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:31:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42444 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbaHYHaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:30:39 -0400
X-AuditID: cbfee691-f79546d0000011a1-db-53fae61bb060
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, galak@codeaurora.org, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCHv4 4/4] thermal: exynos: Remove duplicate code when reading
 triminfo register of Exynos5440
Date: Mon, 25 Aug 2014 16:30:25 +0900
Message-id: <1408951825-2639-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1408951825-2639-1-git-send-email-cw00.choi@samsung.com>
References: <1408951825-2639-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWyRsSkQFf62a9gg+8HlCwaroZY3H1+mNHi
	+pfnrBbzj5xjtViz/yeTxfwr11gt+t8sZLXoXXCVzeJs0xt2i02PgWKXd81hs/jce4TRYsb5
	fUwWS69fZLKYMH0ti0Xr3iPsFk8e9rE5CHqsmbeG0eNyXy+Tx85Zd9k9Fu95yeSxaVUnm8fm
	JfUefVtWMXocv7GdyePzJrkAzigum5TUnMyy1CJ9uwSujMWTb7AUXOKsWL5qM0sD4x/2LkYO
	DgkBE4ndTRxdjJxAppjEhXvr2UBsIYGljBIv+1Qg4iYSTbtfMHcxcgHFpzNKfJz+gg3CaWKS
	OPbwCztIFZuAlsT+FzfAukUEPCXmLmxhAiliFpjCLHGq4ygrSEJYIEfi1p3nLCA2i4CqxNfH
	t5hAbF4BF4mmppPMEOvkJD7seQR2HaeAq8TZRXYQF7lI/J22BuwKCYG/7BJX311nhZgjIPFt
	8iEWiG9kJTYdgBojKXFwxQ2WCYzCCxgZVjGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIERtvp
	f88m7mC8f8D6EKMAB6MSD+8Kzl/BQqyJZcWVuYcYTYE2TGSWEk3OB8Z0Xkm8obGZkYWpiamx
	kbmlmZI4r470z2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjBXRzE6/lum9XGf18EDo36Ns
	5rzvbe+qfL+Rns9v92r1ozXWCfcnv78k+lDk4+fLskxqxx+drDu4kbfiaokkz/IPu5suHd3S
	8DqmIPr3vee9Ky5ovJkg/TerN3KOx7Nl9q0hm8r9u8re8bzekHx8sUf9M2/fixJe3w/rPjdP
	3Zb7+PO+BR5T2CuVWIozEg21mIuKEwFy3jfxsQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jQV3pZ7+CDe5Mk7JouBpicff5YUaL
	61+es1rMP3KO1WLN/p9MFvOvXGO16H+zkNWid8FVNouzTW/YLTY9Bopd3jWHzeJz7xFGixnn
	9zFZLL1+kcliwvS1LBate4+wWzx52MfmIOixZt4aRo/Lfb1MHjtn3WX3WLznJZPHplWdbB6b
	l9R79G1Zxehx/MZ2Jo/Pm+QCOKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgH5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MGYsnnyDpeASZ8XyVZtZGhj/sHcxcnJICJhINO1+wQxhi0lcuLeerYuRi0NIYDqjxMfpL6Cc
	JiaJYw+/gHWwCWhJ7H9xgw3EFhHwlJi7sIUJpIhZYAqzxKmOo6wgCWGBHIlbd56zgNgsAqoS
	Xx/fYgKxeQVcJJqaTkKtk5P4sOcR0FAODk4BV4mzi+xAwkJAJX+nrWGewMi7gJFhFaNoakFy
	QXFSeq6hXnFibnFpXrpecn7uJkZwPD+T2sG4ssHiEKMAB6MSD+9Kzl/BQqyJZcWVuYcYJTiY
	lUR4pxwHCvGmJFZWpRblxxeV5qQWH2I0BTpqIrOUaHI+MNXklcQbGpuYGVkamRtaGBmbK4nz
	Hmi1DhQSSE8sSc1OTS1ILYLpY+LglGpgnLjtA9M0g5NfdWbdmaYfv8d0ZcPDayXhYZPmbZB+
	0sDZ/r0lf8+pZdYTDk1MeHvvnuyjNYq/Ngdc3b8tokl+v8tz7qDiz07JlatDj+VEmD91v8qR
	vzB2ipiKmY91Uaxna8lO9x6bkIx+iyCxpWod2wIdJnxpX/7S78Yek78bP1fOZ/i6J/ySixJL
	cUaioRZzUXEiALf1WnH9AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove simply duplicate code when reading triminfo register of Exynos5440.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Reviewed-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index 7234f38..caeb445 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -195,15 +195,13 @@ static int exynos_tmu_initialize(struct platform_device *pdev)
 		 */
 		switch (data->id) {
 		case 0:
+		case 2:
 			trim_info = readl(data->base +
 			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
 			break;
 		case 1:
 			trim_info = readl(data->base + reg->triminfo_data);
 			break;
-		case 2:
-			trim_info = readl(data->base -
-			EXYNOS5440_EFUSE_SWAP_OFFSET + reg->triminfo_data);
 		}
 	} else {
 		/* On exynos5420 the triminfo register is in the shared space */
-- 
1.8.0

