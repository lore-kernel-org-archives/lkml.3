Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934734Ab3DINOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 09:14:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10080 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759517Ab3DINOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 09:14:51 -0400
X-AuditID: cbfee68d-b7f786d000005188-17-516414492f07
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH v2] usb: ehci-s5p: fix: Fix null pointer dereferencing
Date: Tue, 09 Apr 2013 18:42:11 +0530
Message-id: <1365513131-27691-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <CAFp+6iE1Ei=B7+XfZghVivwQ5zdbCnuG+F=qdLX3P19Xo9QdYg@mail.gmail.com>
References: <CAFp+6iE1Ei=B7+XfZghVivwQ5zdbCnuG+F=qdLX3P19Xo9QdYg@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSo+spkhJo8OqMusXfScfYLZoXr2ez
	uLzwEqtF74KrQNauOWwWM87vY7JYtKyV2eLfz31sFhN+X2Bz4PT4/WsSo8eda3vYPPbPXcPu
	MfvuD0aPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyph6YxZLwW6OioP9z1gbGLvYuxg5OSQE
	TCRWr/zJDGGLSVy4t56ti5GLQ0hgKaPE4lfrmGGKGrZOZIJILGKUeNTTxQqSEBKYwiSxZocl
	iM0moCvR9HYXI4gtIuAgsWTpHbBJzAJPGSVaTywAWycs4CaxZfExMJtFQFWi9d4vMJtXwEPi
	6ac/UCcpSLy5/QxoMwcHp0CwxLwbNSCmkECARNu3apCREgKb2CW27l3OCjFGQOLb5EMsIDUS
	ArISmw5A3SwpcXDFDZYJjMILGBlWMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYgTGwOl/z3p3
	MN4+YH2IMRlo3ERmKdHkfGAM5ZXEGxqbGVmYmpgaG5lbmpEmrCTOq9ZiHSgkkJ5YkpqdmlqQ
	WhRfVJqTWnyIkYmDU6qB8Szzw+L5gtKn0rcs7BX+d3uNcZnVzI7d4XlFd77rm+p8KptyOtmO
	WW+99AYh4dibhntva2hI+D9cN8Py68qtL24Uelc9s3i2vHbvqays89KFF25OV3rNIPZuU4BE
	44FA9V991bvaUwonpO94/NNqR/ANhgK+CTnX7/QFZQXfL+WP5ejmyPx1WomlOCPRUIu5qDgR
	AGYA/6SXAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsVy+t9jAV1PkZRAg68XZS3+TjrGbtG8eD2b
	xeWFl1gtehdcBbJ2zWGzmHF+H5PFomWtzBb/fu5js5jw+wKbA6fH71+TGD3uXNvD5rF/7hp2
	j9l3fzB69G1ZxejxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJC
	XmJuqq2Si0+ArltmDtBZSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM
	qTdmsRTs5qg42P+MtYGxi72LkZNDQsBEomHrRCYIW0ziwr31bF2MXBxCAosYJR71dLGCJIQE
	pjBJrNlhCWKzCehKNL3dxQhiiwg4SCxZegesgVngKaNE64kFYFOFBdwktiw+BmazCKhKtN77
	BWbzCnhIPP30B2qzgsSb28+Yuxg5ODgFgiXm3agBMYUEAiTavlVPYORdwMiwilE0tSC5oDgp
	PddQrzgxt7g0L10vOT93EyM4wp5J7WBc2WBxiFGAg1GJh/fCk6RAIdbEsuLK3EOMEhzMSiK8
	F/lSAoV4UxIrq1KL8uOLSnNSiw8xJgPdNJFZSjQ5Hxj9eSXxhsYm5qbGppYmFiZmlqQJK4nz
	Hmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAuIV7p5KiueLUyZO2Cq4qMxVia5y7WP/w258l8urT
	w27bhPxbftf35pqpl//IuMRd4/Y6cG1L/7Ib5xaY8bx5PmdbHMOhFNUCg+X8J2NOPZQvvjPL
	rjjy32XXpbcEef9Zec7RnVawIOpzvUzNGTXGJvckwV71p+7ZfovbSovNW25eszzloMFjocRS
	nJFoqMVcVJwIACv8S3T0AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

7edb3da: (USB: EHCI: make ehci-s5p a separate driver)
raised an issue with ehci-s5p's driver data.
Now that 's5p_ehci_hcd' doesn't maintain pointer to 'usb_hcd'
and s5p_ehci is nothing but a pointer to hcd->priv;
add hcd to the driver data rather than s5p_ehci.

This fixes issues with null pointer dereferencing in
s5p_ehci_shutdown(), s5p_ehci_suspend(), s5p_ehci_resume().

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
CC: Manjunath Goudar <manjunath.goudar@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Jingoo Han <jg1.han@samsung.com>
---

Based on 'usb-next'

 drivers/usb/host/ehci-s5p.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index d8cb0ca..580548a 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -173,7 +173,7 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 		goto fail_add_hcd;
 	}
 
-	platform_set_drvdata(pdev, s5p_ehci);
+	platform_set_drvdata(pdev, hcd);
 
 	return 0;
 
-- 
1.7.6.5

