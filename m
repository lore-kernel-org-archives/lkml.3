Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbaHYJ3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:29:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58694 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbaHYJ3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:29:17 -0400
X-AuditID: cbfee68d-f79c46d000000b84-0b-53fb01e5b8a1
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, cw00.choi@samsung.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [RESEND PATCH v4 1/2] mfd: arizona: Add support for
 INn_Mode register control
Date: Mon, 25 Aug 2014 18:25:39 +0900
Message-id: <1408958740-1037-2-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1408958740-1037-1-git-send-email-ideal.song@samsung.com>
References: <1408958740-1037-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsWyRsSkUPcp4+9gg08XzS2uXDzEZDH14RM2
	i39TbrBbXP/ynNVi/pFzrBb9bxayWuz6e5/R4tyrlYwW978eZbS4vGsOm8XS6xeZLJa//c9m
	MWH6WhaL1r1H2C1Od7M68Hts+NzE5rFm3hpGj8t9vUweK5d/YfPYtKqTzePOtT1sHvNOBnq8
	nPibzaNvyypGj8+b5AK4orhsUlJzMstSi/TtErgyjlxuZS94yF0x6/0c9gbGm5xdjJwcEgIm
	Ei93/2GBsMUkLtxbz9bFyMUhJLCUUWJiz0v2LkYOsKLHnbUQ8emMEqe+bGCCcOYwSVz8sYMd
	pJtNQEPi++fNzCC2CNCk23M6mUGKmAU6mCWmbNvFCDJJWCBVouuZGEgNi4CqxI93y5hAbF4B
	V4nJz96yQlyhLbGvYSYbiM0p4CaxZ/0xsPlCQDUbFk8Du05C4C+7xJotsxghBglIfJt8iAXi
	UlmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxiBUXb637Pe
	HYy3D1gfYhTgYFTi4V3B+StYiDWxrLgy9xCjKdCGicxSosn5wFjOK4k3NDYzsjA1MTU2Mrc0
	UxLnVZT6GSwkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBseqzvhqjWYEN37wJbDl+2Uzpzls+
	OvFYhGXM+Hz2f9ia4A0lYsfKePZGzWrqKGgqiTjTy8Wtu1yO+f1kmz239k14fiDZi/t569Jr
	i+MfBmZqXmqKyMs+dXXTgvRDjKw/V96KqHtqJGfVlGZcWzY9bNkka9+q+z6Mb75cM3t5Of5L
	/Z93KxiuK7EUZyQaajEXFScCAJC7uv2tAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQd2njL+DDd6dM7C4cvEQk8XUh0/Y
	LP5NucFucf3Lc1aL+UfOsVr0v1nIarHr731Gi3OvVjJa3P96lNHi8q45bBZLr19kslj+9j+b
	xYTpa1ksWvceYbc43c3qwO+x4XMTm8eaeWsYPS739TJ5rFz+hc1j06pONo871/awecw7Gejx
	cuJvNo++LasYPT5vkgvgimpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshL
	zE21VXLxCdB1y8wBekNJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmHHk
	cit7wUPuilnv57A3MN7k7GLk4JAQMJF43FnbxcgJZIpJXLi3nq2LkYtDSGA6o8SpLxuYIJw5
	TBIXf+xgB6liE9CQ+P55MzOILQLUcXtOJzNIEbNAB7PElG27GEGmCgukSnQ9EwOpYRFQlfjx
	bhkTiM0r4Cox+dlbVoht2hL7GmaygdicAm4Se9YfA5svBFSzYfE0tgmMvAsYGVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBMfwM6kdjCsbLA4xCnAwKvHwruT8FSzEmlhWXJl7iFGCg1lJ
	hFfjD1CINyWxsiq1KD++qDQntfgQoynQVROZpUST84HpJa8k3tDYxMzI0sjc0MLI2FxJnPdA
	q3WgkEB6YklqdmpqQWoRTB8TB6dUA+N2rRzVL7I75ZdM2/fmQkfUI5FPQhvNhCWfHH2ntVy2
	NuWxZ+nHaGv5f+luH3ct4C6W81rw+LTgzp8n2/87nJkcGm8fd60ta07g4d8z975YonFsl9nn
	cotMro7QhkMmM7bUeivPdV/zkOn6hMg/X6rPxq5IMQ5Ypmmy6NXMHrbXgpNX5KaW//mpxFKc
	kWioxVxUnAgAfzG8KvcCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some boards need to set the INn_MODE[1:0] register to change
the input signal patch. This wlf,inmode property is optional.
If present, values must be specified less than or equal to
the number of input singals. If values less than the number
of input signals, elements that has not been specifed are set
to 0 by default.

Example:
   - wlf,inmode = <2 0 2>;	/* IN1, IN3 use DMIC */

Signed-off-by: Inha Song <ideal.song@samsung.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 10a0cb9..81e6db8 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
 static int arizona_of_get_core_pdata(struct arizona *arizona)
 {
 	struct arizona_pdata *pdata = &arizona->pdata;
-	int ret, i;
+	int ret, i, proplen;
 
 	pdata->reset = arizona_of_get_named_gpio(arizona, "wlf,reset", true);
 
@@ -560,6 +560,12 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 			ret);
 	}
 
+	proplen = of_property_count_u32_elems(arizona->dev->of_node,
+					      "wlf,inmode");
+	if (proplen > 0 && proplen <= ARRAY_SIZE(arizona->pdata.inmode))
+		of_property_read_u32_array(arizona->dev->of_node, "wlf,inmode",
+					   arizona->pdata.inmode, proplen);
+
 	return 0;
 }
 
-- 
2.0.0.390.gcb682f8

