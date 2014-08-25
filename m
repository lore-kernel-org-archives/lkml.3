Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaHYHbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:31:06 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59175 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbaHYHap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:30:45 -0400
X-AuditID: cbfee68e-f79536d000000fd1-5b-53fae619480e
From: Chanwoo Choi <cw00.choi@samsung.com>
To: eduardo.valentin@ti.com, amit.daniel@samsung.com, rui.zhang@intel.com
Cc: kgene.kim@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, galak@codeaurora.org, ch.naveen@samsung.com,
        kyungmin.park@samsung.com, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: [PATCHv4 1/4] thermal: exynos: Fix wrong value of TRIMINFO_RELOAD_SHIFT
Date: Mon, 25 Aug 2014 16:30:22 +0900
Message-id: <1408951825-2639-2-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1408951825-2639-1-git-send-email-cw00.choi@samsung.com>
References: <1408951825-2639-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsWyRsSkRFfy2a9ggzfbtSwaroZY3H1+mNHi
	+pfnrBbzj5xjtViz/yeTxfwr11gt+t8sZLXoXXCVzeJs0xt2i02PgWKXd81hs/jce4TRYsb5
	fUwWS69fZLKYMH0ti0Xr3iPsFk8e9rE5CHqsmbeG0eNyXy+Tx85Zd9k9Fu95yeSxaVUnm8fm
	JfUefVtWMXocv7GdyePzJrkAzigum5TUnMyy1CJ9uwSujIlzJ7EX3GSvuL50BVMD4w22LkZO
	DgkBE4mnc9tZIWwxiQv31gPFuTiEBJYySix69osFpujC73csEInpjBIvT31ihHCamCRW3e8C
	G8UmoCWx/wXEWBEBT4m5C1uYQIqYBaYwS5zqOAq0g4NDWCBAYteLZJAaFgFViVknO5hBbF4B
	F4k3a1oYIbbJSXzY84gdpJxTwFXi7CI7kLAQUMnfaWuYIUr+skuc2+oOMUZA4tvkQywg5RIC
	shKbDkCVSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYgdF2+t+zvh2M
	Nw9YH2IU4GBU4uFdwfkrWIg1say4MvcQoynQhonMUqLJ+cCYziuJNzQ2M7IwNTE1NjK3NFMS
	502Q+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdFzaqHSOm/LmsnbVntqzFr+/FGIxvUN
	i16eUjl46xlT84m+sDCWJfITL5UblC+UlUrbttiDtzS46Xm0pnzszZ+rllvu6AiffV99W6bi
	JlnxW5WGthzr3vjpdO7gNlolMKdYcmZLsPqsVSs0Qg5z+LPa7TU1v1Jn3Xf/1US1wC/clbJq
	b38/u6PEUpyRaKjFXFScCADJV1+RsQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t9jQV3JZ7+CDfZeUbRouBpicff5YUaL
	61+es1rMP3KO1WLN/p9MFvOvXGO16H+zkNWid8FVNouzTW/YLTY9Bopd3jWHzeJz7xFGixnn
	9zFZLL1+kcliwvS1LBate4+wWzx52MfmIOixZt4aRo/Lfb1MHjtn3WX3WLznJZPHplWdbB6b
	l9R79G1Zxehx/MZ2Jo/Pm+QCOKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3M
	lRTyEnNTbZVcfAJ03TJzgH5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLW
	MGZMnDuJveAme8X1pSuYGhhvsHUxcnJICJhIXPj9jgXCFpO4cG89UJyLQ0hgOqPEy1OfGCGc
	JiaJVfe7wDrYBLQk9r+A6BYR8JSYu7CFCaSIWWAKs8SpjqOsXYwcHMICARK7XiSD1LAIqErM
	OtnBDGLzCrhIvFnTwgixTU7iw55H7CDlnAKuEmcX2YGEhYBK/k5bwzyBkXcBI8MqRtHUguSC
	4qT0XCO94sTc4tK8dL3k/NxNjOBofia9g3FVg8UhRgEORiUe3pWcv4KFWBPLiitzDzFKcDAr
	ifBOOQ4U4k1JrKxKLcqPLyrNSS0+xGgKdNREZinR5HxgoskriTc0NjEzsjQyN7QwMjZXEuc9
	2GodKCSQnliSmp2aWpBaBNPHxMEp1cDIHPzwaLr4hNdyc8oMMs+/0JbkDtOZ2HCDY8oiy+tl
	MbOq5lyy5DCd+Nq0d8OVk4/ibY9uTmtdtSF08eGOeXz6/I93XzOfaiP9V25/cZjqc50l6Rcu
	Z3X+CTA98V/xtu+M3Wy676N81nLw52+paFl3/5uFTNcvjsXaEq9zl+TbeLN+z+x4/VRTiaU4
	I9FQi7moOBEAQziOm/wCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix wrong value of TRIMINFO_RELOAD_SHIFT. TRIMINFO_CONTROL register
has 'RELOAD' field at [0] bit.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <cw00.choi@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/thermal/samsung/exynos_tmu_data.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/samsung/exynos_tmu_data.h b/drivers/thermal/samsung/exynos_tmu_data.h
index f0979e5..401bab7 100644
--- a/drivers/thermal/samsung/exynos_tmu_data.h
+++ b/drivers/thermal/samsung/exynos_tmu_data.h
@@ -63,7 +63,7 @@
 #define EXYNOS_THD_TEMP_FALL		0x54
 #define EXYNOS_EMUL_CON		0x80
 
-#define EXYNOS_TRIMINFO_RELOAD_SHIFT	1
+#define EXYNOS_TRIMINFO_RELOAD_SHIFT	0
 #define EXYNOS_TRIMINFO_25_SHIFT	0
 #define EXYNOS_TRIMINFO_85_SHIFT	8
 #define EXYNOS_TMU_RISE_INT_MASK	0x111
-- 
1.8.0

