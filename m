Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933856AbaHZEmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 00:42:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:42020 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933729AbaHZElo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 00:41:44 -0400
X-AuditID: cbfee690-f79ce6d00000115a-e3-53fc1006c2e3
From: Chanwoo Choi <cw00.choi@samsung.com>
To: sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org
Cc: myungjoo.ham@samsung.com, jonghwa3.lee@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/2] power: charger-manager: Check charging state right after
 completed initialization
Date: Tue, 26 Aug 2014 13:41:39 +0900
Message-id: <1409028099-6081-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409028099-6081-1-git-send-email-cw00.choi@samsung.com>
References: <1409028099-6081-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkUJdN4E+wwbP5IhbXvzxntZj05D2z
	xcSVk5ktOs8+Yba4vGsOm8Xn3iOMFrcbV7BZnN5d4sDhsXPWXXaPzSu0PDat6mTz6NuyitHj
	8ya5ANYoLpuU1JzMstQifbsErowtU66yF8zlqrjYvIu5gfE6RxcjJ4eEgInEjg8/mSFsMYkL
	99azdTFycQgJLGWUuLdmElCCA6xowmFRkBohgUWMEq/7uSBqmpgkbtx6xA6SYBPQktj/4gYb
	iC0iYCvR8/QgM0gRs8AMRok7X3pZQQYJC2RIbLtsCFLDIqAqsezZKbBeXgEXiUn3OlkgjpCT
	+LAHYiangKvE5rdb2EBahYBqFh31AhkpITCPXeL/8g52iDkCEt8mH2KBuFNWYtMBqF8kJQ6u
	uMEygVF4ASPDKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYzAQD/979mEHYz3DlgfYhTgYFTi
	4b0R/ztYiDWxrLgy9xCjKdCGicxSosn5wHjKK4k3NDYzsjA1MTU2Mrc0UxLnfS31M1hIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QD46SAut1xiuHzFeX2fzfacnBd7/yPktwrD+5fsmOjd/nV
	vd98Tp+7fZfF+Wz0nXx9jdqaP3f+J5Wtv5KvYNp7zV+E88K+L653+bqvMjG4nGU6P/3Q09/H
	Tz2TZ9mqLfCyRIn7+2GDkuSzsSorZ81mOrklpszh+ME5oq03jXUEpJfa8P/fOv29rqwSS3FG
	oqEWc1FxIgA+dSVTbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t9jAV02gT/BBgtn81pc//Kc1WLSk/fM
	FhNXTma26Dz7hNni8q45bBafe48wWtxuXMFmcXp3iQOHx85Zd9k9Nq/Q8ti0qpPNo2/LKkaP
	z5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmbJlylb1gLlfFxeZd
	zA2M1zm6GDk4JARMJCYcFu1i5AQyxSQu3FvPBmILCSxilHjdz9XFyAVkNzFJ3Lj1iB0kwSag
	JbH/xQ2wIhEBW4mepweZQYqYBWYwStz50ssKMlRYIENi22VDkBoWAVWJZc9OgfXyCrhITLrX
	yQKxTE7iwx6ImZwCrhKb325hA2kVAqpZdNRrAiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6
	yfm5mxjBcfRMegfjqgaLQ4wCHIxKPLw34n8HC7EmlhVX5h5ilOBgVhLhZXgIFOJNSaysSi3K
	jy8qzUktPsRoCnTURGYp0eR8YIznlcQbGpuYGVkamRtaGBmbK4nzHmy1DhQSSE8sSc1OTS1I
	LYLpY+LglGpg1F7r12/zUqDxM8eJQ7utNYP33F28j7PDSVc7d3l0cXxjwZG98mytf/IPNhb4
	S6y9ksahVHfmTrLNJsXPv05kyUmua9jKlyphr6XqdfxclNmBhUob+OV8r7hacq0Wdjj+Yfk3
	poYXh9ifqz5lfdW3iH9GuvNLlx1el5e9PbHl2WYthQl/DhVuVmIpzkg01GIuKk4EALfUZzC5	AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch check the charging state after completed initialization of charger-
manager and update current charging state. If charger-manager never check and
update current charging state, charger-manager would have the mismatch issue
between real state of cable connection and the charging state of charger-manager
until first polling time of charger-manager.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/charger-manager.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index a10fb57..4e560f7 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1839,6 +1839,13 @@ static int charger_manager_probe(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, true);
 	device_set_wakeup_capable(&pdev->dev, false);
 
+	/*
+	 * Charger-manager have to check the charging state right after
+	 * tialization of charger-manager and then update current charging
+	 * state.
+	 */
+	cm_monitor();
+
 	schedule_work(&setup_polling);
 
 	return 0;
-- 
1.8.0

