Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaH3C1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 22:27:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31434 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaH3C10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 22:27:26 -0400
X-AuditID: cbfee68f-f797f6d000001173-ed-5401368be880
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, cw00.choi@samsung.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [PATCH v5 1/2] mfd: arizona: Add support for INn_Mode
 register control
Date: Sat, 30 Aug 2014 11:27:18 +0900
Message-id: <1409365639-5320-2-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1409365639-5320-1-git-send-email-ideal.song@samsung.com>
References: <1409365639-5320-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsWyRsSkRLfbjDHEYPdmLosrFw8xWUx9+ITN
	4t+UG+wW1788Z7WYf+Qcq0X/m4WsFrv+3me0OPdqJaPF/a9HGS0u75rDZrH0+kUmi+Vv/7NZ
	TJi+lsWide8RdovT3awO/B4bPjexeayZt4bR43JfL5PHyuVf2Dw2repk87hzbQ+bx7yTgR4v
	J/5m8+jbsorR4/MmuQCuKC6blNSczLLUIn27BK6MzgMvWApucFfs/9vN1MB4jLOLkZNDQsBE
	4sK6J4wQtpjEhXvr2boYuTiEBJYyShy/1MgMUzTr63t2iMR0Romeq1eZIZw5TBI7ZhwAa2cT
	0JD4/nkzWIcI0KjbczrBipgFOpglpmzbBVYkLBAncWZtMxOIzSKgKvFtyyywOK+Aq8Src7fY
	INZpS+xrmAlmcwq4SdxfvxCsRgio5vbOPWBnSAh8ZZd4uf8ZM8QgAYlvkw+xdDFyACVkJTYd
	gDpbUuLgihssExiFFzAyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIjLTT/57172C8e8D6
	EKMAB6MSD++FlwwhQqyJZcWVuYcYTYE2TGSWEk3OB8ZzXkm8obGZkYWpiamxkbmlmZI470Kp
	n8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGAtvMN+qZOP5z/Lh9LMni6Y+yC35u9iQpa9x
	2tm7b+c92W165I+WYL3gk1daugmVHxNNn5lmfX+3ULdAu8I7S9a7unvh/99/jm/qs/DLvTin
	9PU9ySuX/y/K0hWfYbT8usbG1TzGqcItma8nPGBVznC+fbSLY5b7hH8h1+5Ect46L6Oyp7RF
	tl6JpTgj0VCLuag4EQCs9kBFrwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQd1uM8YQg/dNzBZXLh5ispj68Amb
	xb8pN9gtrn95zmox/8g5Vov+NwtZLXb9vc9oce7VSkaL+1+PMlpc3jWHzWLp9YtMFsvf/mez
	mDB9LYtF694j7Banu1kd+D02fG5i81gzbw2jx+W+XiaPlcu/sHlsWtXJ5nHn2h42j3knAz1e
	TvzN5tG3ZRWjx+dNcgFcUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJ
	uam2Si4+AbpumTlAbygplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYMzoP
	vGApuMFdsf9vN1MD4zHOLkZODgkBE4lZX9+zQ9hiEhfurWfrYuTiEBKYzijRc/UqM4Qzh0li
	x4wDjCBVbAIaEt8/b2YGsUWAOm7P6QQrYhboYJaYsm0XWJGwQJzEmbXNTCA2i4CqxLcts8Di
	vAKuEq/O3WKDWKctsa9hJpjNKeAmcX/9QrAaIaCa2zv3sE9g5F3AyLCKUTS1ILmgOCk911Cv
	ODG3uDQvXS85P3cTIziOn0ntYFzZYHGIUYCDUYmH98JLhhAh1sSy4srcQ4wSHMxKIrxSj4FC
	vCmJlVWpRfnxRaU5qcWHGE2BrprILCWanA9MMXkl8YbGJmZGlkbmhhZGxuZK4rwHWq0DhQTS
	E0tSs1NTC1KLYPqYODilGhhnxzklV+0LY/SaevHeW31Bb199Rv+83zdXGUyVTZdUTq9vui64
	Wbk07d7m7wn++kqbDq+ufMj1/E1+3v7Aj4YH3OpzT57uqU7TnBd5s0N46eQkDeYKpyTl2XMS
	w+PXvvs879i3btu93XInAp7tW/HvUbW0/prMueHpXO+kJyqbMBtPZJ/EGq/EUpyRaKjFXFSc
	CABgggP5+QIAAA==
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
 drivers/mfd/arizona-core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 10a0cb9..31757f7 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -534,7 +534,11 @@ EXPORT_SYMBOL_GPL(arizona_of_get_named_gpio);
 static int arizona_of_get_core_pdata(struct arizona *arizona)
 {
 	struct arizona_pdata *pdata = &arizona->pdata;
+	struct property *prop;
+	const __be32 *cur;
+	u32 val;
 	int ret, i;
+	int count = 0;
 
 	pdata->reset = arizona_of_get_named_gpio(arizona, "wlf,reset", true);
 
@@ -560,6 +564,15 @@ static int arizona_of_get_core_pdata(struct arizona *arizona)
 			ret);
 	}
 
+	of_property_for_each_u32(arizona->dev->of_node, "wlf,inmode", prop,
+				 cur, val) {
+		if (count == ARRAY_SIZE(arizona->pdata.inmode))
+			break;
+
+		arizona->pdata.inmode[count] = val;
+		count++;
+	}
+
 	return 0;
 }
 
-- 
2.0.0.390.gcb682f8

