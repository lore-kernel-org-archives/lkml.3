Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaHMLth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:49:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27676 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaHMLte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:49:34 -0400
X-AuditID: cbfee68f-b7fa26d0000039a0-d4-53eb50c9bc0c
Date: Wed, 13 Aug 2014 20:49:29 +0900
From: Inha Song <ideal.song@samsung.com>
To: Inha Song <ideal.song@samsung.com>
Cc: broonie@kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        lee.jones@linaro.org, ckeepax@opensource.wolfsonmicro.com,
        lgirdwood@gmail.com, sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: [alsa-devel] [PATCH v2 1/2] mfd: arizona: Add support for INn_Mode
 register control
Message-id: <20140813204929.2d528448@songinha-Samsung-DeskTop-System>
In-reply-to: <20140809173138.767b97fd@songinha-Samsung-DeskTop-System>
References: <20140809173138.767b97fd@songinha-Samsung-DeskTop-System>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42JZI2JSrHsq4HWwweWLjBZXLh5ispj68Amb
	xb8pN9gtrn95zmox/8g5Vov+NwtZLXb9vc9oce7VSkaL+1+PMlp8u9LBZHF51xw2i6XXLzJZ
	LH/7n81iwvS1LBate4+wW5zuZnUQ8NjwuYnNY828NYwel/t6mTx2zrrL7rFy+Rc2j02rOtk8
	7lzbw+Yx72Sgx8uJv9k8+rasYvT4vEkugDuKyyYlNSezLLVI3y6BK6Ot7RxTwQ2uij13LrI1
	MF7j6GLk5JAQMJFoPXmLGcIWk7hwbz1bFyMXh5DAUkaJ638OMMEU3V+2lwUiMZ1R4sPfy6wQ
	Tj+TxPZPzxhBqlgEVCWOfdjEBmKzCWhIfP+8GWysiICaxIw7vUwgDcwCvcwSD89/YAdJCAvE
	SXQtagBr5hVwlfh58iTYOk4BN4lHB2eD2UJA8WdnVkHdZyOxeuc6Zoh6QYkfk++xgNjMAloS
	m7c1sULY8hKb17wFquEAqt/DIXGPCeI2AYlvkw+xQIRlJTYdgJooKXFwxQ2WCYxis5AMnYVk
	6CwkQxcwMq9iFE0tSC4oTkovMtYrTswtLs1L10vOz93ECEwEp/8969/BePeA9SHGZKCVE5ml
	RJPzgYkkryTe0NjMyMLUxNTYyNzSjDRhJXHe+w+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFw
	SjUwtr3encR7k68x3SUixmHWPdZqQbOjCj4X7mrcvugZ7Z902uGDxb6C4nxl1hOcV2/IBS2c
	Z/hRa8uKII6eL8uFed5Yv97UdlfpmvixJZ8TmS7blXQc4F/GfjC/P+Hf+9u3tzTY2Bd+nb+r
	59OsN88WKF75wV3in9cSoNsbEyDLee29yOf2pBOZSizFGYmGWsxFxYkAAE6GEBoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jQd2TAa+DDV62mVlcuXiIyWLqwyds
	Fv+m3GC3uP7lOavF/CPnWC363yxktdj19z6jxblXKxkt7n89ymjx7UoHk8XlXXPYLJZev8hk
	sfztfzaLCdPXsli07j3CbnG6m9VBwGPD5yY2jzXz1jB6XO7rZfLYOesuu8fK5V/YPDat6mTz
	uHNtD5vHvJOBHi8n/mbz6NuyitHj8ya5AO6oBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMz
	A0NdQ0sLcyWFvMTcVFslF58AXbfMHKCHlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB
	9RgZoIGENYwZbW3nmApucFXsuXORrYHxGkcXIyeHhICJxP1le1kgbDGJC/fWs3UxcnEICUxn
	lPjw9zIrhNPPJLH90zNGkCoWAVWJYx82sYHYbAIaEt8/b2YGsUUE1CRm3OllAmlgFuhllnh4
	/gM7SEJYIE6ia1EDWDOvgKvEz5MnmUBsTgE3iUcHZ4PZQkDxZ2dWMUOcYSOxeuc6Zoh6QYkf
	k++BnccsoCWxeVsTK4QtL7F5zVvmCYwCs5CUzUJSNgtJ2QJG5lWMoqkFyQXFSem5hnrFibnF
	pXnpesn5uZsYwanmmdQOxpUNFocYBTgYlXh4K3hfBQuxJpYVV+YeYpTgYFYS4T1s8zpYiDcl
	sbIqtSg/vqg0J7X4EKMpMDgmMkuJJucD02BeSbyhsYmZkaWRuaGFkbG5kjjvgVbrQCGB9MSS
	1OzU1ILUIpg+Jg5OqQZGpoWioqyikl72ScpFn6Xlf6Teu7H05I9YayvvHdKelpz3FikevxTq
	9r3tWKH+6WJ1BcMYg1Kt1pJ3GpeTlndkihzYfs3Eopwr/JTVCWueh65Fb51s+a8uc9mw8p/U
	UW7jLX5x3CfceQKaBNnEg7UitJW3XBeVq5srcOn57661WU8/uX878lyJpTgj0VCLuag4EQBB
	3DziSwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some boards need to set the INn_MODE[1:0] register to change
the input signal patch. This wlf,inmode property is optional.
If present values must be specified by the number of
ARIZONA_MAX_INPUT.

Example:
   - wlf,inmode = <2 0 2 0>;	/* IN1, IN3 use DMIC */

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 drivers/mfd/arizona-core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 10a0cb9..2b68ccd 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
 static int arizona_of_get_core_pdata(struct arizona *arizona)
 {
 	struct arizona_pdata *pdata = &arizona->pdata;
-	int ret, i;
+	int ret, i, proplen;
 
 	pdata->reset = arizona_of_get_named_gpio(arizona, "wlf,reset", true);
 
@@ -560,6 +560,15 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 			ret);
 	}
 
+	proplen = of_property_count_u32_elems(arizona->dev->of_node,
+					      "wlf,inmode");
+	if (proplen > 0 && proplen <= ARRAY_SIZE(arizona->pdata.inmode)) {
+		for (i = 0; i < proplen; i++)
+			of_property_read_u32_index(arizona->dev->of_node,
+						   "wlf,inmode", i,
+						    &arizona->pdata.inmode[i]);
+	}
+
 	return 0;
 }
 
-- 
2.0.0.390.gcb682f8
