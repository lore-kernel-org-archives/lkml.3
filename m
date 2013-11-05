Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3KEDCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:02:48 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13848 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3KEDCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:02:46 -0500
X-AuditID: cbfee691-b7f866d000001b8c-62-52785fd57177
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        akpm@linux-foundation.org
Cc: Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH] pwm: samsung: memory leak bugfix in pwm_samsung_free
Date: Tue, 05 Nov 2013 12:02:40 +0900
Message-id: <1383620560-3567-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWyRsSkQPdqfEWQwY0XPBZz1q9hs+g8+4TZ
	4vKuOWwWd++uYrRYsKfEYv2M1ywWP3fNY3Fg99g56y67x4kZv1k8+rasYvT4vEkugCWKyyYl
	NSezLLVI3y6BK6Nn5i62gnPsFae3JDQwbmfrYuTkkBAwkbh6ej4rhC0mceHeeqA4F4eQwFJG
	iRvTjjDBFDWcnMQIYgsJLGKUaF/KA1HUxiTx+cpzZpAEm4CuxJMDl8FsEYFUiW3bT7CDFDEL
	TGWUuH54NztIQljAVeLd469ANgcHi4CqxM99diBhXgF3ia1fdzKChCUEFCTmTLIBaZUQ+M0m
	MXkPxHUsAgIS3yYfYoGokZXYdIAZ4jZJiYMrbrBMYBRcwMiwilE0tSC5oDgpvchUrzgxt7g0
	L10vOT93EyMwTE//ezZxB+P9A9aHGJOBxk1klhJNzgeGeV5JvKGxmZGFqYmpsZG5pRlpwkri
	vOmPkoKEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MPIwlNnsZ1u3qnqORpTK1hPq72qPSZX/
	u+f1XyHyWr6r+sXwC7qz64M9k6NT/jq4O67UfjQ9LHKHyqKFnk83Fn1ZJXfrXN1MtfS1zv6s
	r5cJW8Tr6m+xcE6dvKUrcoaonM71qbf8l3c8OnjmeZn53T/R3k9aYjx0M6Ydn+f18I/Bjvr7
	aUwF05VYijMSDbWYi4oTAWLzOUdpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jAd2r8RVBBm/2sFrMWb+GzaLz7BNm
	i8u75rBZ3L27itFiwZ4Si/UzXrNY/Nw1j8WB3WPnrLvsHidm/Gbx6NuyitHj8ya5AJaoBkab
	jNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKALlBTKEnNK
	gUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZPTN3sRWcY684vSWhgXE7WxcjJ4eE
	gIlEw8lJjBC2mMSFe+vB4kICixgl2pfydDFyAdltTBKfrzxnBkmwCehKPDlwGcwWEUiV2Lb9
	BDtIEbPAVEaJ64d3s4MkhAVcJd49/gpkc3CwCKhK/NxnBxLmFXCX2Pp1JyNIWEJAQWLOJJsJ
	jNwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRHwTOpHYwrGywOMQpwMCrx8D44Wx4k
	xJpYVlyZe4hRgoNZSYRXObIiSIg3JbGyKrUoP76oNCe1+BBjMtDuicxSosn5wAjNK4k3NDYx
	M7I0Mje0MDI2J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQZGreWip2ILVb7U3HYtPyxV
	J+WnzTb7GlvyX8UlkcsjTj37M3GyfJ/l3w9nvNvcniqzPdlSeMhE/OXUmCPzzvB+23krtLjc
	YsuiENGToZoLVou3i6z7ciDeO/5nxit/Zb98Y5ZbP2MlZsXfilw/XTFHbK4G334/nVCe1q/V
	WsohhreuH5V+u/C3EktxRqKhFnNRcSIAxszrMcYCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is certainly a kind of memory leak since allocated data (i.e.
chip_data) is set NULL before freeing it by calling devm_kfree(). This
patch fixes the memory leak bug by modifying its call order.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
Reviewed-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/pwm/pwm-samsung.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index fcc8b9a..07b2d9d 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -224,8 +224,8 @@ static int pwm_samsung_request(struct pwm_chip *chip, struct pwm_device *pwm)
 
 static void pwm_samsung_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
-	pwm_set_chip_data(pwm, NULL);
 	devm_kfree(chip->dev, pwm_get_chip_data(pwm));
+	pwm_set_chip_data(pwm, NULL);
 }
 
 static int pwm_samsung_enable(struct pwm_chip *chip, struct pwm_device *pwm)
-- 
1.7.9.5

