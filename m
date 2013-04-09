Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965424Ab3DIJXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:23:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30032 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936673Ab3DIJXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:23:41 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-fc-5163de1afa32
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] usb: ehci-s5p: fix: Fix null pointer dereferencing
Date: Tue, 09 Apr 2013 14:51:52 +0530
Message-id: <1365499312-14232-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWyRsSkTlf6XnKgwUVWi7+TjrFbNC9ez2Zx
	eeElVoveBVeBrF1z2CxmnN/HZLFoWSuzxb+f+9gsJvy+wObA6fH71yRGjzvX9rB57J+7ht1j
	9t0fjB59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CV0dK4lq1gFkdF98sV7A2MH9i6GDk5JARM
	JLZefcsIYYtJXLi3HijOxSEksJRRYs28SXBFE/4fZQaxhQSmM0pc+skEUTSFSeL+jZNgRWwC
	uhJNb3eBTRIRcJBYsvQO2CRmgaeMEq0nFrCDJIQFnCW+nDjMCmKzCKhKfO3bBNTAwcEr4CFx
	94U+xDIFiTe3nzGD9EoITGeXOLxpMjNEvYDEt8mHWEDqJQRkJTYdYIaol5Q4uOIGywRGwQWM
	DKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAkP69L9n/TsY7x6wPsSYDDRuIrOUaHI+MCby
	SuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBYM+no
	wvdxJdYBRVo7vy799OCTXpXAXG+HNyU3AieWT2/e9X5i9pcINukFCzbomVsEy780009UvM7J
	vlss6qnIq3Uid7m/PT5WEBEbOmnl9JViHZZ/dvczHn2kEX6+4MnPd8v+CR9R/ndNM33CQdYv
	xvZtSb89ZT0zFYVF9M2umc4qfrKT8ZmmEktxRqKhFnNRcSIALdAmq38CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jQV2pe8mBBqdbTCz+TjrGbtG8eD2b
	xeWFl1gtehdcBbJ2zWGzmHF+H5PFomWtzBb/fu5js5jw+wKbA6fH71+TGD3uXNvD5rF/7hp2
	j9l3fzB69G1ZxejxeZNcAFtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJC
	XmJuqq2Si0+ArltmDtBZSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM
	lsa1bAWzOCq6X65gb2D8wNbFyMkhIWAiMeH/UWYIW0ziwr31YHEhgemMEpd+MnUxcgHZU5gk
	7t84CZZgE9CVaHq7ixHEFhFwkFiy9A4bSBGzwFNGidYTC9hBEsICzhJfThxmBbFZBFQlvvZt
	Amrg4OAV8JC4+0IfYpmCxJvbz5gnMHIvYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc
	M8+kdzCuarA4xCjAwajEw3vhSVKgEGtiWXFl7iFGCQ5mJRHeljvJgUK8KYmVValF+fFFpTmp
	xYcYk4GWT2SWEk3OB8ZzXkm8obGJuamxqaWJhYmZJWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2
	MHFwSjUwljbkBxs1rA9Mz6/jn68Voq/62HGOjYPmZO3aOb++f/rJVlwV/PbbsfdGtzJCz7un
	h834lfHYdwdP/rdTLvbX6z4LbZ225fa+iPoO0YOHU4WclvBq7NJTbMteE5JrNq84/NzPbee0
	rseeqI/hN1r5QHjS7KVpmmtlXWW7e3OU5q1bV20gyhGuxFKckWioxVxUnAgAHj9npd0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

7edb3da makes ehci-s5p as a separate driver. But,
it raised an issue with its driver data.
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

