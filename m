Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab3JJBlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 21:41:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15495 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab3JJBlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 21:41:46 -0400
X-AuditID: cbfee68e-b7f756d000004512-f2-525605d19d07
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org, lgirdwood@gmail.com, sbkim73@samsung.com
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] regulator: s5m8767: Modify parse_dt function to parse data
 related to ramp
Date: Thu, 10 Oct 2013 10:41:35 +0900
Message-id: <1381369296-17101-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsWyRsSkWPcia1iQwd3b8hZTHz5hs7j+5Tmr
	xfwj51gtzja9Ybf4dqWDyeLyrjlsFhdXfGFyYPfYOesuu8emVZ1sHn1bVjF6fN4kF8ASxWWT
	kpqTWZZapG+XwJXRs/0ZY8EOzopZ/bdZGhjbOboYOTkkBEwk5p45yA5hi0lcuLeerYuRi0NI
	YCmjxLL/95lhiuZvW8oGYgsJLGKUOLGxFKKokUliaWMHE0iCTUBLYv+LG0BFHBwiAg4Skxfo
	gtQwC/QzSmy+vIUFpEZYIFHibU8zI4jNIqAqsbBzGlicV8BV4vnEW1BXyEl82PMIyv7NJvHn
	YhFEvYDEt8mHWEDmSwjISmw6AHWbpMTBFTdYJjAKLmBkWMUomlqQXFCclF5kpFecmFtcmpeu
	l5yfu4kRGKqn/z3r28F484D1IcZkoHETmaVEk/OBoZ5XEm9obGZkYWpiamxkbmlGmrCSOK9a
	i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkZh5nWXAr5e1cs5V1NX4147JZs389uvD69D
	ZEVqPG7fy2FudzjkWPP68YsP7d+V/Wcf3TeN9aKcaIegXHJ4f+Mrh2JJvevJdudWPG6SL1HW
	Wrhpy+p+K+Go6RqRi9RWq+93r1A7wC8f/+vJP92u87MeShW+aQ86U7/yplyrff6OPZPmRf3Z
	pa/EUpyRaKjFXFScCABfoYNGawIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jAd2LrGFBBvfWSFhMffiEzeL6l+es
	FvOPnGO1ONv0ht3i25UOJovLu+awWVxc8YXJgd1j56y77B6bVnWyefRtWcXo8XmTXABLVAOj
	TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QCUoKZYk5
	pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjJ7tzxgLdnBWzOq/zdLA2M7RxcjJ
	ISFgIjF/21I2CFtM4sK99WC2kMAiRokTG0u7GLmA7EYmiaWNHUwgCTYBLYn9L24AFXFwiAg4
	SExeoAtSwyzQzyix+fIWFpAaYYFEibc9zYwgNouAqsTCzmlgcV4BV4nnE2+xQyyTk/iw5xH7
	BEbuBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY+GZ9A7GVQ0WhxgFOBiVeHgrykKD
	hFgTy4orcw8xSnAwK4nwTj8JFOJNSaysSi3Kjy8qzUktPsSYDLR9IrOUaHI+ME7zSuINjU3M
	jCyNzA0tjIzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoExdUbHuXB5nXO5PRZ3I7W1
	VXSvT//cZ+F5/JbgUeeP0jPsZcpCvp6QVlbRcDobPKnih9QMAZ35O5wXHdw0fYd30lsV80Oz
	a7I2OKaHPPZ/vFJ3v5p/krz/1KW2PCsyamIyZySfOWjw1E8mlNv18X5PVRaXa/M+GMQ98phb
	r3TZxpD9zN4ZQqVKLMUZiYZazEXFiQDQ0nP5yQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch parse 'buck[2-4]_ramp_enable and buck_ramp_delay' platform data
from dts file.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/regulator/s5m8767.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index c24448b..cb6cdb3 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -640,6 +640,22 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
+	if (of_get_property(pmic_np, "s5m8767,pmic-buck2-ramp-enable", NULL))
+		pdata->buck2_ramp_enable = true;
+
+	if (of_get_property(pmic_np, "s5m8767,pmic-buck3-ramp-enable", NULL))
+		pdata->buck3_ramp_enable = true;
+
+	if (of_get_property(pmic_np, "s5m8767,pmic-buck4-ramp-enable", NULL))
+		pdata->buck4_ramp_enable = true;
+
+	if (pdata->buck2_ramp_enable || pdata->buck3_ramp_enable
+			|| pdata->buck4_ramp_enable) {
+		if (of_property_read_u32(pmic_np, "s5m8767,pmic-buck-ramp-delay",
+				&pdata->buck_ramp_delay))
+			pdata->buck_ramp_delay = 0;
+	}
+
 	return 0;
 }
 #else
-- 
1.8.0

