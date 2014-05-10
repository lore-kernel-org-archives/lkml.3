Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaEJFsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 01:48:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29998 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaEJFsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 01:48:39 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-6c-536dbdb58158
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, lee.jones@linaro.org, michal.simek@xilinx.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] drivers: mfd: allow property as NULL in
 syscon_early_regmap_lookup_by_phandle
Date: Sat, 10 May 2014 15:06:54 +0900
Message-id: <1399702014-11819-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t8zA92te3ODDVZ0ylrc/3qU0eLyrjls
	Fu9eRlgs2vqF3eJ0N6sDq8eda3vYPOadDPTo27KK0ePzJjmPvZ9/swSwRnHZpKTmZJalFunb
	JXBl3FjewVIwj7ti75o1zA2Mazi7GDk5JARMJKa09LBB2GISF+6tB7K5OIQEljFKXFvWzgZT
	9HvnFiaIxHRGiZ67X5ghnDYmieN7GplAqtgEdCWevJ/LDGKLCChIbO59xtrFyMHBLFAsseF3
	DEhYWCBB4n//HnYQm0VAVeJ9+yVWEJtXwENi+urp7CDlEkCtcybZgIyXEPjMJrFp4jQ2iHoB
	iW+TD7FA1MhKbDrADHGbpMTBFTdYJjAKLmBkWMUomlqQXFCclF5kpFecmFtcmpeul5yfu4kR
	Epp9OxhvHrA+xJgMNG4is5Rocj4wtPNK4g2NzYwsTE1MjY3MLc1IE1YS5130MClISCA9sSQ1
	OzW1ILUovqg0J7X4ECMTB6dUA6NNQ4m2Tp6J7sWPNyZy2zQx3m74clvtPoOnz22XjVGPb/3h
	qd8udezaNfc9biuCFh+8N0fV0H5BpW/zU74/Fq9DV1s3PtYQ8bP8uufYPV3edeH3fnfufcC6
	+H4ye2H1wse3bBU3/LRWDvwQeGrn/uqwkvrNh7iPzL23v+9/x8Myk5pDjlv27F6oxFKckWio
	xVxUnAgAtRjbmmMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t9jQd2te3ODDRb/kbC4//Uoo8XlXXPY
	LN69jLBYtPULu8XpblYHVo871/awecw7GejRt2UVo8fnTXIeez//ZglgjWpgtMlITUxJLVJI
	zUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBWq2kUJaYUwoUCkgsLlbS
	t8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLixvIOlYB53xd41a5gbGNdwdjFyckgImEj83rmF
	CcIWk7hwbz1bFyMXh5DAdEaJnrtfmCGcNiaJ43sawarYBHQlnryfywxiiwgoSGzufcbaxcjB
	wSxQLLHhdwxIWFggQeJ//x52EJtFQFXiffslVhCbV8BDYvrq6ewg5RJArXMm2Uxg5F7AyLCK
	UTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjwn0nvYFzVYHGIUYCDUYmHt/BtTrAQa2JZcWXu
	IUYJDmYlEd7t9bnBQrwpiZVVqUX58UWlOanFhxiTgZZPZJYSTc4HRmVeSbyhsYmZkaWRmYWR
	ibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTBOEBF/x5h07NqPnhru83lsn55O3PuM
	ZSpfZ+CyJ3xP63RW2yzK3tM0QYWtXbr625Xk53cX3OS4tTxAT2nPYi19iWNhE9PS1BOzl5et
	uiLt9DyNd/aLgvL9V9YcqqlUnHy0iMH2X6/c7mfXlJ9Lrm5J0ri+Qd692SLW8VG78RStRW++
	XW4K+hOvxFKckWioxVxUnAgAZdXjzMACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we pass syscon device node itself as first parameter to this function
there is no need to parse and find syscon device node. So by allowing
"property" parameter as NULL allow syscon_early_regmap_lookup_by_phandle to
consider passed argument "np" itself as a syscon device node "syscon_np".
This will help us in avoiding addition of "syscon" property which points
back to it's own device node in device tree.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
Hello,

This patch set depends on early_syscon_initialization patch from
Michal Simek [1]. It allows us to call syscon_early_regmap_lookup_by_phandle
with NULL property. This is similar change posted here [2] for 
syscon_regmap_lookup_by_phandle by me.

[1]: https://lkml.org/lkml/2014/4/8/239
[2]: https://lkml.org/lkml/2014/4/29/661

 drivers/mfd/syscon.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 5457e59..786c6cd 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -103,7 +103,11 @@ struct regmap *syscon_early_regmap_lookup_by_phandle(struct device_node *np,
 	struct device_node *syscon_np;
 	struct syscon *syscon;
 
-	syscon_np = of_parse_phandle(np, property, 0);
+	if (property)
+		syscon_np = of_parse_phandle(np, property, 0);
+	else
+		syscon_np = np;
+
 	if (!syscon_np)
 		return ERR_PTR(-ENODEV);
 
-- 
1.7.10.4

