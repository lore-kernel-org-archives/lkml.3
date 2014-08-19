Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaHSLOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:14:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24706 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaHSLOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:14:01 -0400
X-AuditID: cbfee691-b7f306d000003d81-8c-53f331789526
Date: Tue, 19 Aug 2014 20:14:00 +0900
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: [alsa-devel] [PATCH v4 1/2] mfd: arizona: Add support for INn_Mode
 register control
Message-id: <20140819201400.4adecd96@songinha-Samsung-DeskTop-System>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsWyRsSkQLfC8HOwwfxPnBZXLh5ispj68Amb
	xb8pN9gtrn95zmox/8g5Vov+NwtZLc69Wslocf/rUUaLb1c6mCwu75rDZrH0+kUmi+Vv/7NZ
	TJi+lsWide8RdovT3awO/B4bPjexeayZt4bR43JfL5PHzll32T1WLv/C5rFpVSebx51re9g8
	5p0M9Hg58TebR9+WVYwenzfJBXBHcdmkpOZklqUW6dslcGV8PHKRseA+d8Ws93PYGxhvcnYx
	cnJICJhIPP9ynBXCFpO4cG89WxcjF4eQwFJGiavfT7PCFO2av44JIrGIUeLNyWfMEE4/k8SP
	h+eYQapYBFQlLj88BWazCWhIfP+8GcwWARp7e04nWAOzwE8mieYVT8ASwgJxEltenGYEsXkF
	XCX+vJzEBLHORmL1znXMEHFBiR+T77GA2MwCWhKbtzWxQtjyEpvXvAUbKiEwlUOivfshK8QV
	AhLfJh8CauAASshKbDrADDFTUuLgihssExhFZiEZOwvJ2FlIxi5gZF7FKJpakFxQnJReZKpX
	nJhbXJqXrpecn7uJERjTp/89m7iD8f4B60OMyUArJzJLiSbnA1NCXkm8obGZkYWpiamxkbml
	GWnCSuK86Y+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwGn3dbrq8tufyBPcbzAsqeX2z
	wibFVavPmjfLb6k367/cFUvf6TM2m65ZzvqtNOMdZz+TlIR57K/Hfaw8DCmeh3jXNQfsWPog
	MG1zlpmP2tdPkYKBxhfzI9aob1UyyD761b3x6Zb7DxJ9lmtYOClPvhvoE5WRfXn7qXmPjZKd
	Ba5sDeYpjgpTYinOSDTUYi4qTgQAJYlJGf8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd0Kw8/BBp0rGC2uXDzEZDH14RM2
	i39TbrBbXP/ynNVi/pFzrBb9bxayWpx7tZLR4v7Xo4wW3650MFlc3jWHzWLp9YtMFsvf/mez
	mDB9LYtF694j7Banu1kd+D02fG5i81gzbw2jx+W+XiaPnbPusnusXP6FzWPTqk42jzvX9rB5
	zDsZ6PFy4m82j74tqxg9Pm+SC+COamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
	MFdSyEvMTbVVcvEJ0HXLzAH6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpI
	WMOY8fHIRcaC+9wVs97PYW9gvMnZxcjJISFgIrFr/jomCFtM4sK99WxdjFwcQgKLGCXenHzG
	DOH0M0n8eHiOGaSKRUBV4vLDU2A2m4CGxPfPm8FsEaDu23M6wRqYBX4ySTSveAKWEBaIk9jy
	4jQjiM0r4Crx5+UkqHU2Eqt3rmOGiAtK/Jh8jwXEZhbQkti8rYkVwpaX2LzmLfMERr5ZSMpm
	ISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzghPFMagfjygaLQ4wCHIxKPLwK
	Xz4GC7EmlhVX5h5ilOBgVhLh7ZD+HCzEm5JYWZValB9fVJqTWnyI0RTo7YnMUqLJ+cBkllcS
	b2hsYmZkaWRuaGFkbK4kznug1TpQSCA9sSQ1OzW1ILUIpo+Jg1OqgbGKYcaqXpUbl0Qk5807
	03X3T2yjn9X7xslvK6yv7j7NmCM1STydfell/hD38tU8yv7RMm4R32Y+vfnsc93S1Ws/3i3Z
	7u7Ia9vr9Pf8v9/8ue1KwactP7StS5M2uCX65/6V+Y5Vu/kYUpe9/FFyYsXL5cdDn9zqva6V
	edClXuB369tJ2TnXc5uVWIozEg21mIuKEwHmk75rLgMAAA==
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
