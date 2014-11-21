Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbaKUNpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:45:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:43903 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaKUNp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:45:27 -0500
X-AuditID: cbfee68e-f79b46d000002b74-39-546f41f59d39
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org, balbi@ti.com,
        kishon@ti.com
Cc: linux-omap@vger.kernel.org, gregkh@linuxfoundation.org,
        tomasz.figa@gmail.com, s.nawrocki@samsung.com, robh+dt@kernel.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 02/11] dwc3: exynos: Remove local variable for clock from probe
Date: Fri, 21 Nov 2014 19:05:45 +0530
Message-id: <1416576954-11997-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSpfvVMT/E4PxOAYuD9+st5h85x2rR
	duUgu0Xz4vVsFr0LrrJZXHjaw2ZxedccNovZS/pZLGac38dksWhZK7NF694j7BaH37SzWkz4
	fYHNYtWuP4wOfB47Z91l99i0qpPNY//cNewes+/+YPTo27KK0eP4je1MHp83yQWwR3HZpKTm
	ZJalFunbJXBlrDzTwViwirvi5tN/jA2MSzi7GDk5JARMJJZsPcEMYYtJXLi3nq2LkYtDSGAp
	o8SclsOsXYwcYEXde4sh4tMZJS4+XcgM4UxgkpjWvYAdpJtNQFei6e0uRhBbRGA2o0TbQSGQ
	ImaBe4wSn99/ZwGZJCzgLzG52x+khkVAVWLNqX8sIDavgIfEvxvz2SCWKUjMmWQDEuYU8JRo
	WX+ZCcQWAipZs2s3I8hICYF77BJ/fvUxQcwRkPg2+RALRK+sxKYDUM9IShxccYNlAqPwAkaG
	VYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxiB0XP637O+HYw3D1gfYhTgYFTi4Z0xNS9EiDWx
	rLgy9xCjKdCGicxSosn5wBjNK4k3NDYzsjA1MTU2Mrc0UxLnTZD6GSwkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qBMfaW49pX2hy3l17daX7U4rjzrcKqC3b+TB/ePLINcdr+kkVglWzVFff5
	1TM0/+tNubzt0co5mQ9nV117eFxu23QexVcsonrnGyWeawgdvnugKp3d2kyz5cHDh7wrvpk1
	1Rz8LfE1tS4mJP6ZaeulWqfpX04fTdI9ZmlirijAfZsnzDnlovbpRUosxRmJhlrMRcWJAEp1
	qdeZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jQd2vjvkhBrPOs1kcvF9vMf/IOVaL
	tisH2S2aF69ns+hdcJXN4sLTHjaLy7vmsFnMXtLPYjHj/D4mi0XLWpktWvceYbc4/Kad1WLC
	7wtsFqt2/WF04PPYOesuu8emVZ1sHvvnrmH3mH33B6NH35ZVjB7Hb2xn8vi8SS6APaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6GYlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bKMx2MBau4K24+/cfYwLiEs4uRg0NC
	wESie29xFyMnkCkmceHeerYuRi4OIYHpjBIXny5khnAmMElM617ADlLFJqAr0fR2FyOILSIw
	m1Gi7aAQSBGzwD1Gic/vv7OATBUW8JeY3O0PUsMioCqx5tQ/FhCbV8BD4t+N+WwQixUk5kyy
	AQlzCnhKtKy/zARiCwGVrNm1m3ECI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGx
	+UxqB+PKBotDjAIcjEo8vB+m54UIsSaWFVfmHmKU4GBWEuEtF84PEeJNSaysSi3Kjy8qzUkt
	PsRoCnTURGYp0eR8YNrIK4k3NDYxNzU2tTSxMDGzVBLnvXEzN0RIID2xJDU7NbUgtQimj4mD
	U6qBcZFOw3WJ68a/+t3zLHMTusrMamKNtmjy/1h76MdrzpJ/X/buOmDi+iSw/8GGlsTblvMD
	fWTOfal7+1CaRUfjJVNVek372Wo2H63zUmHnf8Z+//7p4sG+Eo2vwRs4AvqDBB79Z33T/jrs
	6M4zjBIf+nnvmj+fmp+0/n/736M21VmR9b1+3G6KSizFGYmGWsxFxYkAT4ftC+MCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to keep one local variable for clock, and
then assign the same to 'clk' member of dwc3_exynos.
Just cleaning it up.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/dwc3-exynos.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 3951a65..7109de7 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -106,7 +106,6 @@ static int dwc3_exynos_remove_child(struct device *dev, void *unused)
 static int dwc3_exynos_probe(struct platform_device *pdev)
 {
 	struct dwc3_exynos	*exynos;
-	struct clk		*clk;
 	struct device		*dev = &pdev->dev;
 	struct device_node	*node = dev->of_node;
 
@@ -133,15 +132,13 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	clk = devm_clk_get(dev, "usbdrd30");
-	if (IS_ERR(clk)) {
+	exynos->dev	= dev;
+
+	exynos->clk = devm_clk_get(dev, "usbdrd30");
+	if (IS_ERR(exynos->clk)) {
 		dev_err(dev, "couldn't get clock\n");
 		return -EINVAL;
 	}
-
-	exynos->dev	= dev;
-	exynos->clk	= clk;
-
 	clk_prepare_enable(exynos->clk);
 
 	exynos->vdd33 = devm_regulator_get(dev, "vdd33");
@@ -185,7 +182,7 @@ err4:
 err3:
 	regulator_disable(exynos->vdd33);
 err2:
-	clk_disable_unprepare(clk);
+	clk_disable_unprepare(exynos->clk);
 	return ret;
 }
 
-- 
1.7.10.4

