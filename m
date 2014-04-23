Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaDWM36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:29:58 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52263 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbaDWM3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:29:30 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-cb-5357b229f1e7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND 2/2] rtc: 88pm860x: Add missing of_node_put
Date: Wed, 23 Apr 2014 14:29:28 +0200
Message-id: <1398256168-493-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1398256168-493-1-git-send-email-k.kozlowski@samsung.com>
References: <1398256168-493-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xK7qam8KDDdafkbBYcvEqu8Wc9WvY
	LC6fO8xocXnhJVaL1y8MLS7vmsNmsb+zg9Hi5J9eRgcOjz0TT7J53Lm2h83jxIzfLB59W1Yx
	ekyf95PJ4/MmuQC2KC6blNSczLLUIn27BK6MaYt7WQvesVR8+bCHtYGxm6WLkYNDQsBE4ksf
	RxcjJ5ApJnHh3nq2LkYuDiGBpYwSH95PgnL6mCSOLFjEAlLFJmAssXn5EjYQW0QgXWLRtCtM
	IEXMAjcYJfpedjGCJIQFnCQmHvrCDLKBRUBV4sL/EJAwr4CrxIdb95kgtslJnDw2mRXE5hRw
	k9jfNg/sICGgmhlzCycw8i5gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERJkX3YwLj5m
	dYhRgINRiYdXYnlYsBBrYllxZe4hRgkOZiUR3iWLwoOFeFMSK6tSi/Lji0pzUosPMTJxcEo1
	MLpzcJpM/Pv5OGfDhlzmVfMve7J++v1qudbqF6pLj5j3N8iXd7BXtbRYSC31/j03wGPhvw9z
	n0TrBE46b1fwZG6uE+cD/dMtV87tPLp+ebwNm+E5n8aDG3aYLTz+/aD5HfMLS/nXCDXXZvFq
	PtaetdSk6WTCVM+VZbuVWmWP71VPP+ZtLfdVolWJpTgj0VCLuag4EQAsuF44EAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing of_node_put to decrement the reference count.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/rtc/rtc-88pm860x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index fb9e3c63b4ac..0c6add1a38dc 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -301,6 +301,7 @@ static int pm860x_rtc_dt_init(struct platform_device *pdev,
 	ret = of_property_read_u32(np, "marvell,88pm860x-vrtc", &info->vrtc);
 	if (ret)
 		info->vrtc = 0;
+	of_node_put(np);
 	return 0;
 }
 #else
-- 
1.9.1

