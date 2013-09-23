Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab3IWJwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:52:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18088 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab3IWJwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:52:31 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-cb-52400f5ef210
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
In-reply-to: <001801ceb840$9a81ab10$cf850130$%han@samsung.com>
Subject: [PATCH 14/15] rtc: rtc-sh: use dev_get_platdata()
Date: Mon, 23 Sep 2013 18:52:30 +0900
Message-id: <002a01ceb842$9e288110$da798330$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64QJVrtN1IW24fTFCn/tCGU7Py3AAAcmsg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ904focgg1VP2C2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK2PdiKnPBWvaKo89fMzUw9rB1MXJwSAiYSHzdKtrFyAlkiklcuLceKMzFISSwjFGi
	Y+dDJoiEiUT7449MEInpjBJ3V/QyQji/GCX2TnvJCFLFJqAm8eXLYXaQqSIC+hJtLRogNcwC
	vYwSZ3p3s4PUCAnYSkyc9hVsKqeAncSaz8vAbGEBK4kd708xgfSyCKhKvLmpCxLmBSrv/HSD
	EcIWlPgx+R4LiM0soCWxeVsTK4QtL7F5zVtmiGfUJR79BWsVETCSePz4ATNEiYjEvhfvwE6W
	EHjELnHq0W2wOSwCAhLfJh9igeiVldh0gBniX0mJgytusExglJiFZPMsJJtnIdk8C8mKBYws
	qxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzFC4rR/B+PdA9aHGJOB1k9klhJNzgfGeV5JvKGx
	mZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGE329jRKCjhL
	XGKeLem4gOnUuSjdr9/0+FOSjlZ27bdqjotZZxRz+P9NYfW05Wt/92XzGwnOu/j2Y4LK3frC
	PqencUnht2VmNj39v2L2h22Hlj2rm6s60XPB//PdTb9/lAmu5z//ewPLTG6b787KZSem8838
	4X+K79TZ6FP9xgcsra7ozwhcya7EUpyRaKjFXFScCACQPaZv6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd04focggwuzWSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNj3YipzwVr2iqPPXzM1MPawdTFyckgImEi0
	P/7IBGGLSVy4tx4ozsUhJDCdUeLuil5GCOcXo8TeaS8ZQarYBNQkvnw5zN7FyMEhIqAv0dai
	AVLDLNDLKHGmdzc7SI2QgK3ExGlfwaZyCthJrPm8DMwWFrCS2PH+FBNIL4uAqsSbm7ogYV6g
	8s5PNxghbEGJH5PvsYDYzAJaEpu3NbFC2PISm9e8ZQZplRBQl3j0F6xVRMBI4vHjB8wQJSIS
	+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC08Az
	qR2MKxssDjEKcDAq8fBGJNoHCbEmlhVX5h5ilOBgVhLh9WN1CBLiTUmsrEotyo8vKs1JLT7E
	mAz050RmKdHkfGCKyiuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYO
	TqkGRmszybMTp3yK/3vp0tyujbPztxUmTgkwu/M7yihnxa/pK6M/7Kj1spxu99X71V0p7c4v
	LY8uyv9X27TMpH/u0VVzqqexLq09fu6brBH376mRFbFrEpUUTtRo/HXQVTzX/lZx9qyNkrWx
	OV4pVuftfzxn1XaR71TXDBSwvv1Ze5fRg/s7khXZnyuxFGckGmoxFxUnAgCccfD8RwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-sh.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index 6d87e26..d0d2b04 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -649,8 +649,9 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 	clk_enable(rtc->clk);
 
 	rtc->capabilities = RTC_DEF_CAPABILITIES;
-	if (pdev->dev.platform_data) {
-		struct sh_rtc_platform_info *pinfo = pdev->dev.platform_data;
+	if (dev_get_platdata(&pdev->dev)) {
+		struct sh_rtc_platform_info *pinfo =
+			dev_get_platdata(&pdev->dev);
 
 		/*
 		 * Some CPUs have special capabilities in addition to the
-- 
1.7.10.4


