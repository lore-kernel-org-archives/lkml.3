Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab3H3EL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 00:11:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57068 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753651Ab3H3EL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 00:11:57 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-30-52201b8c7fed
From: Jingoo Han <jg1.han@samsung.com>
To: "'Hans J. Koch'" <hjk@hansjkoch.de>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] drivers: uio_dmem_genirq: use dev_get_platdata()
Date: Fri, 30 Aug 2013 13:11:56 +0900
Message-id: <002b01cea537$10ed8930$32c89b90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6lNxC0zCCz2b5JSCutk7ruoAGsQQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zY90eaYUgg9NTmS2aF69nszh6djq7
	xeWFl1gtLu+aw+bA4jH/oZfH/rlr2D36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr43LzQvaC
	Q+wVm76sZm5g3MzWxcjJISFgIrHwXh8LhC0mceHeerC4kMAyRonls9K6GDnAapZ/D+xi5AIK
	L2KUuDNjFxuE84tR4vHCVewgDWwCahJfvhxmB2kQEVCX+NkSB2IyC1RKLO6OAakQFnCVWLjq
	Ath4FgFViVNrXjOC2LwCthJrfr+HsgUlfky+B3YOs4CWxPqdx5kgbHmJzWveMkOcoy7x6K8u
	SFhEQE/i6pJXjBAlIhL7XrxjBLlMQmATu8SyCTsYIXYJSHybfIgFoldWYtMBZohvJSUOrrjB
	MoFRbBaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiJrt4djLcP
	WB9iTAZaP5FZSjQ5HxideSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUX
	leakFh9iZOLglGpgdOPQmc6t6s16RO169Y6bgmynL+rmXGTas/Kdx+6LM/7kXZ1xIllWIS/d
	87dXWNoO46hfIoFFnLfCd0ld16w+t3v+sfdHnCcyb7FgfemZzMG4ZU/uDpvqD925n00fKT+z
	7PS3F/4ap/HLQDR1ZYk295fF/wLL5jOHdRn+99MXuxQSlnPVRmqjEktxRqKhFnNRcSIAKYZm
	1sQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgG63tEKQwacVNhbNi9ezWRw9O53d
	4vLCS6wWl3fNYXNg8Zj/0Mtj/9w17B59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmHG5eSF7wSH2ik1fVjM3MG5m62Lk4JAQMJFY/j2wi5ETyBSTuHBv
	PVCYi0NIYBGjxJ0Zu6CcX4wSjxeuYgepYhNQk/jy5TA7SLOIgLrEz5Y4EJNZoFJicXcMSIWw
	gKvEwlUX2EBsFgFViVNrXjOC2LwCthJrfr+HsgUlfky+xwJiMwtoSazfeZwJwpaX2LzmLTPE
	aeoSj/7qgoRFBPQkri55xQhRIiKx78U7xgmMArOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgp
	PddIrzgxt7g0L10vOT93EyM4ep9J72Bc1WBxiFGAg1GJh7dhqnyQEGtiWXFl7iFGCQ5mJRHe
	+G1AId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYSTc4HJpa8knhDYxMzI0sjMwsjE3Nz0oSVxHkP
	tloHCgmkJ5akZqemFqQWwWxh4uCUamCcWb3ve51nUuuhCx9Lb90Ry7W6EyDFM9H7u/jdhc2W
	4aE/Sk87F98WizxQn7fpCF+B2DTmsolecd+ZePofiJ3r+Fn1Y/cEnwu/Vx/vNVPcN6k0PneJ
	phiTuv0MTjkF/wcPPwmm98SVysSnRZyaO1l65yqrDefTUs3mSL8QsD31ewlrTqW/aq0SS3FG
	oqEWc1FxIgCbB7CPIgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/uio/uio_dmem_genirq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index 125d0e5..1270f3b 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -146,7 +146,7 @@ static int uio_dmem_genirq_irqcontrol(struct uio_info *dev_info, s32 irq_on)
 
 static int uio_dmem_genirq_probe(struct platform_device *pdev)
 {
-	struct uio_dmem_genirq_pdata *pdata = pdev->dev.platform_data;
+	struct uio_dmem_genirq_pdata *pdata = dev_get_platdata(&pdev->dev);
 	struct uio_info *uioinfo = &pdata->uioinfo;
 	struct uio_dmem_genirq_platdata *priv;
 	struct uio_mem *uiomem;
-- 
1.7.10.4


