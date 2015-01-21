Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbbAUXpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 18:45:08 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:21108 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbbAUXom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 18:44:42 -0500
X-AuditID: cbfee691-f79b86d000004a5a-3c-54c039e817b7
From: Chanwoo Choi <cw00.choi@samsung.com>
To: s.nawrocki@samsung.com, tomasz.figa@gmail.com, mturquette@linaro.org
Cc: kgene@kernel.org, pankaj.dubey@samsung.com, inki.dae@samsung.com,
        chanho61.park@samsung.com, sw0312.kim@samsung.com,
        cw00.choi@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Inha Song <ideal.song@samsung.com>
Subject: [PATCH 9/9] clk: samsung: Add CLKOUT driver support for Exynos5433 SoC.
Date: Thu, 22 Jan 2015 08:44:38 +0900
Message-id: <1421883878-4980-10-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421883878-4980-1-git-send-email-cw00.choi@samsung.com>
References: <1421883878-4980-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsWyRsSkUPeF5YEQg6sH1Swu79e2uP7lOavF
	rr/3GS0m3Z/AYtH/+DWzxeVdc9gsZpzfx2TxdMJFNotFW7+wWxx+085qMWPySzaLVbv+MDrw
	eOycdZfdY9OqTjaPO9f2sHn0bVnF6PF5k1wAaxSXTUpqTmZZapG+XQJXxtul01gKmtgruhae
	Y2xgnMHWxcjBISFgIvH5un4XIyeQKSZx4d56oDAXh5DAUkaJGy1vGSESJhIf+i8xQSSmM0q0
	3D7FCOE0MUl8eHmaDaSKTUBLYv+LG2C2iICHxOlnN1lAipgFfjJK3Ls0hxlknbBAgMTkhwUg
	NSwCqhL9OyazgNi8Aq4SHY132CG2KUgsWz6TFcTmBIo3d04EqxEScJFYuP442BUSAvvYJXZP
	XsoOMUhA4tvkQywQ78hKbDrADDFHUuLgihssExiFFzAyrGIUTS1ILihOSi8y1StOzC0uzUvX
	S87P3cQIjIvT/55N3MF4/4D1IUYBDkYlHt4XivtDhFgTy4orcw8xmgJtmMgsJZqcD4y+vJJ4
	Q2MzIwtTE1NjI3NLMyVxXh3pn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGJln+dq3Mc89
	H7ml8UfyERaPE1X8f1NObH57/UjvOfGiRtFHorMSY5bwxzBJf4iQurzrQIYPo2sNSxKThZBV
	wvSI6cmLZTavnbptpoPTwSetDIc3FuZsZCzZWP5tjV/kh84kprc7OrcJqS4ym7/lf96VfP0P
	Zf4Rm22D+R2CG2++evrTvzYgUomlOCPRUIu5qDgRAH0YWWqGAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jQd0XlgdCDJ4+lbW4vF/b4vqX56wW
	u/7eZ7SYdH8Ci0X/49fMFpd3zWGzmHF+H5PF0wkX2SwWbf3CbnH4TTurxYzJL9ksVu36w+jA
	47Fz1l12j02rOtk87lzbw+bRt2UVo8fnTXIBrFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7x
	pmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QPcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUN
	CYLrMTJAAwlrGDPeLp3GUtDEXtG18BxjA+MMti5GTg4JAROJD/2XmCBsMYkL99YDxbk4hASm
	M0q03D7FCOE0MUl8eHkarINNQEti/4sbYLaIgIfE6Wc3WUCKmAV+MkrcuzSHuYuRg0NYIEBi
	8sMCkBoWAVWJ/h2TWUBsXgFXiY7GO+wQ2xQkli2fyQpicwLFmzsngtUICbhILFx/nGkCI+8C
	RoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFx90xqB+PKBotDjAIcjEo8vC8U94cIsSaW
	FVfmHmKU4GBWEuH10DgQIsSbklhZlVqUH19UmpNafIjRFOiqicxSosn5wJSQVxJvaGxiZmRp
	ZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXAeKT+ft32Rcv8qwI447ibrjzzE7j0
	55ABz55/fw+4mLBXV2+ySmqYfsAj54hi4+q+0NqtmxMcJi48Hj5lN0P1x7wfB84vr+A2yK4L
	/1NcuXS64lm9Z9KLDwUsl92jGlgd3MbC9PKW9CyVFyv8ZZbfvlIkYnvC6qSlxiZxXxPeyPeN
	vvwSYVuYlFiKMxINtZiLihMBLztDctECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Inha Song <ideal.song@samsung.com>

This patch add CLKOUT driver support for Exynos5433 SoC.

Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Inha Song <ideal.song@samsung.com>
Acked-by: Inki Dae <inki.dae@samsung.com>
---
 drivers/clk/samsung/clk-exynos-clkout.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos-clkout.c b/drivers/clk/samsung/clk-exynos-clkout.c
index 3a7cb25..1eb16b8 100644
--- a/drivers/clk/samsung/clk-exynos-clkout.c
+++ b/drivers/clk/samsung/clk-exynos-clkout.c
@@ -151,3 +151,5 @@ CLK_OF_DECLARE(exynos5250_clkout, "samsung,exynos5250-pmu",
 		exynos5_clkout_init);
 CLK_OF_DECLARE(exynos5420_clkout, "samsung,exynos5420-pmu",
 		exynos5_clkout_init);
+CLK_OF_DECLARE(exynos5433_clkout, "samsung,exynos5433-pmu",
+		exynos5_clkout_init);
-- 
1.8.5.5

