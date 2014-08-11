Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaHKJUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 05:20:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50315 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbaHKJUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:20:45 -0400
X-AuditID: cbfee68e-b7fab6d000004d4a-8a-53e88ae8706b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/2] extcon: sm5502: Fix bug to check cable type
Date: Mon, 11 Aug 2014 18:20:37 +0900
Message-id: <1407748837-15153-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407748837-15153-1-git-send-email-cw00.choi@samsung.com>
References: <1407748837-15153-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWyRsSkUPdF14tgg48H9Syuf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6Mqyu3sRWs4a3obJ3N2sDY
	xd3FyMkhIWAicX59FzuELSZx4d56ti5GLg4hgaWMEh/23GaBKdq3aQEjRGIRo8T+mb9ZIJwm
	JolPd+cyglSxCWhJ7H9xgw3EFhFQkNjc+4wVxGYWiJc4290NViMs4CDxc/pLsDiLgKrElo3f
	mEFsXgFXiXN7pzFBbJMD2vwI6CQODk4BN4n16+tAwkJAJd86G5hA9koIvGeTeDrjBtQcAYlv
	kw+xgNRLCMhKbDrADDFGUuLgihssExiFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQI
	DNXT/5717WC8ecD6EGMy0LiJzFKiyfnAUM8riTc0NjOyMDUxNTYytzQjTVhJnHfRw6QgIYH0
	xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYw2Cw1mfzHdU/gsLSHcJj72yPdZ5ge/rPlpOn/Siv22
	p62n9Qc7fdY7esncTZXNjS2t/eibuqbmNXzHFTKUbmwIf3Bldq+F7Rf/VJcPMdpd5WfW3H64
	tua766se7pfv6rfHnawunV6S8sRi+2qXrdxTq7jLSqIZ/9T/Px34TjlkX4fprzi1/RJKLMUZ
	iYZazEXFiQC9PefVawIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+xgO6LrhfBBgdWqFtc//Kc1eJs0xt2
	i8u75rBZ3G5cwebA4tG3ZRWjx+dNcgFMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhDWMGVdXbmMrWMNb0dk6m7WBsYu7i5GTQ0LARGLfpgWMELaYxIV769m6GLk4hAQWMUrs
	n/mbBcJpYpL4dHcuWBWbgJbE/hc32EBsEQEFic29z1hBbGaBeImz3d1gNcICDhI/p78Ei7MI
	qEps2fiNGcTmFXCVOLd3GhPENjmJD3sesXcxcnBwCrhJrF9fBxIWAir51tnANIGRdwEjwypG
	0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Eh4JrWDcWWDxSFGAQ5GJR7eg1+eBwuxJpYVV+Ye
	YpTgYFYS4f1p8SJYiDclsbIqtSg/vqg0J7X4EKMp0FETmaVEk/OBUZpXEm9obGJmZGlkbmhh
	ZGyuJM57oNU6UEggPbEkNTs1tSC1CKaPiYNTqoHR6G8Nq39F9iv/XTO2b7i1ycuPo0FH7Ohs
	6f0fFwmlalaE35isOF9d+k5Kjo7om4nMndfYOl/xefXsUVD7dzRoav+cLdmFXTMPf5+qwH52
	+WLJghev4iObfqX6ZD012fidm33iv+V3Xiv0J/NfSO5ryju4/qFVWmeTj/67b/ct++7XpOe6
	Z3QosRRnJBpqMRcVJwIAVS+iEpoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix bug when checking cable type. SM5502 have to use ADC value
to get correct cable type and fix warning message about coding style.

	drivers/extcon/extcon-sm5502.c:398 sm5502_muic_cable_handler()
		warn: we tested 'attached' before and it was 'false'

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-sm5502.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-sm5502.c b/drivers/extcon/extcon-sm5502.c
index aab630e..2555974 100644
--- a/drivers/extcon/extcon-sm5502.c
+++ b/drivers/extcon/extcon-sm5502.c
@@ -282,7 +282,7 @@ static int sm5502_muic_set_path(struct sm5502_muic_info *info,
 /* Return cable type of attached or detached accessories */
 static unsigned int sm5502_muic_get_cable_type(struct sm5502_muic_info *info)
 {
-	unsigned int cable_type = -1, adc, dev_type1;
+	unsigned int adc, cable_type, dev_type1;
 	int ret;
 
 	/* Read ADC value according to external cable or button */
@@ -296,7 +296,7 @@ static unsigned int sm5502_muic_get_cable_type(struct sm5502_muic_info *info)
 	 * If ADC is SM5502_MUIC_ADC_GROUND(0x0), external cable hasn't
 	 * connected with to MUIC device.
 	 */
-	cable_type &= SM5502_REG_ADC_MASK;
+	cable_type = adc & SM5502_REG_ADC_MASK;
 	if (cable_type == SM5502_MUIC_ADC_GROUND)
 		return SM5502_MUIC_ADC_GROUND;
 
@@ -391,7 +391,7 @@ static int sm5502_muic_cable_handler(struct sm5502_muic_info *info,
 	/* Get the type of attached or detached cable */
 	if (attached)
 		cable_type = sm5502_muic_get_cable_type(info);
-	else if (!attached)
+	else
 		cable_type = prev_cable_type;
 	prev_cable_type = cable_type;
 
-- 
1.8.0

