Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3DWC4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 22:56:30 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47997 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab3DWC41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 22:56:27 -0400
X-AuditID: cbfee68f-b7feb6d000003f6c-42-5175f8594a44
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Andrzej Hajda'" <a.hajda@samsung.com>,
        "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: 
In-reply-to: 
Subject: [PATCH 3.8-stable] regulator: fixed regulator_bulk_enable unwinding
 code
Date: Tue, 23 Apr 2013 11:56:25 +0900
Message-id: <006f01ce3fce$25072080$6f156180$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zfd3IH6WBBgs/WFncWneO1eLf7FNs
	FkuauS0u75rDZtG0fQK7xYKNjxgd2DxeTvzN5tG3ZRWjx/Eb25k8Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mo4++YUe8EUror3V5ewNDDu4ehi5OSQEDCROPakgR3CFpO4cG89WxcjF4eQwDJGiW3d
	newwRQu3HGCHSCxilOjpn8wK4fxllNixq5UVpIpNQFfi2PotYLaIgLfEqSm/mEGKmAWmM0pM
	eNkAlOAA6uCWWN0cBFLDKcAjse5PJzOILSwQLPFj51Q2EJtFQFWi73IbC4jNK2AncfxaLzOE
	LSjxY/I9sDizgJbE+p3HmSBseYnNa94yg4yXEFCXePRXF+IEJ4mfix+xQpSISOx78Y4R5BwJ
	gXvsEpv7D7NA7BKQ+Db5EAtEr6zEpgPMEA9LShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnF
	KJpakFxQnJReZKxXnJhbXJqXrpecn7uJERKp/TsY7x6wPsSYDLR+IrOUaHI+MNLzSuINjc2M
	LExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cCYPl2m6Vx60roP
	tx/n7Xz0Zm9dhoTb2Z1y5TUum27JXpdYUSnGvOuR8txPe7ac957y51tXY8isXfU/F946mnuO
	m2XrdjnnhmIPiRyvqJcef1hTgxJ8+RSZrkQlFmeuzfsaG6XVxrxaXb62bL7ipwkTtv+9/+On
	CUv+FP4DQgeyvJ766fq9tc9SYinOSDTUYi4qTgQA1eGJCeoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd3IH6WBBgv3m1ncWneO1eLf7FNs
	FkuauS0u75rDZtG0fQK7xYKNjxgd2DxeTvzN5tG3ZRWjx/Eb25k8Pm+SC2CJamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMOPvmFHvBFK6K91eXsDQw7uHoYuTkkBAwkVi4
	5QA7hC0mceHeerYuRi4OIYFFjBI9/ZNZIZy/jBI7drWyglSxCehKHFu/BcwWEfCWODXlFzNI
	EbPAdEaJCS8bgBIcQB3cEqubg0BqOAV4JNb96WQGsYUFgiV+7JzKBmKzCKhK9F1uYwGxeQXs
	JI5f62WGsAUlfky+BxZnFtCSWL/zOBOELS+xec1bZpDxEgLqEo/+6kKc4CTxc/EjVogSEYl9
	L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFp4Jn0
	DsZVDRaHGAU4GJV4eAXcSwOFWBPLiitzDzFKcDArifCK5gOFeFMSK6tSi/Lji0pzUosPMSYD
	PTqRWUo0OR+YovJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1Oq
	gZFrJuOL3/aLnOqaZ1g9WDmvN33/yUyjCqGYJ3osicuepHhUtnrfOBZotPWVY9CmU992HPTL
	6Phz5sLqzv708z1uwRPD/dp6fq85rHvvUHP/zSSn+fu4s45+tJPNf3vr6sRQGZ2PDU+vCJ4u
	+3ZF/aFQx3OZJ31cc6Jz2O+5aXBs3C5ZXR1dr63EUpyRaKjFXFScCADgoti0RwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Andrzej Hajda <a.hajda@samsung.com>"

commit fbe31057fafebdc2811a7101b8b4a0460f5417d1 upstream.

Unwinding code disables all successfully enabled regulators.
Error is logged for every failed regulator.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/regulator/core.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5a0f54a..e56185b 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3032,9 +3032,13 @@ int regulator_bulk_enable(int num_consumers,
 	return 0;
 
 err:
-	pr_err("Failed to enable %s: %d\n", consumers[i].supply, ret);
-	while (--i >= 0)
-		regulator_disable(consumers[i].consumer);
+	for (i = 0; i < num_consumers; i++) {
+		if (consumers[i].ret < 0)
+			pr_err("Failed to enable %s: %d\n",
consumers[i].supply,
+			       consumers[i].ret);
+		else
+			regulator_disable(consumers[i].consumer);
+	}
 
 	return ret;
 }
-- 
1.7.9.5

