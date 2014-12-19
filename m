Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaLSI7c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:59:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:54612 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaLSIze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:55:34 -0500
X-AuditID: cbfee68e-f79b46d000002b74-94-5493e803cc1c
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH V3 09/11] power: charger-manager: Not to start charging
 directly in cable nofitication.
Date: Fri, 19 Dec 2014 17:55:21 +0900
Message-id: <1418979323-7188-10-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkWJflxeQQg1WXmS0ObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEdx2aSk5mSWpRbp2yVwZWz4uZK9YA93xatn2xkb
	GA9zdjFyckgImEj8XTWPCcIWk7hwbz1bFyMXh5DAUkaJvw9mATkcYEWHH1dAxKczSrS+gilq
	Y5L4/OATO0g3m4COxP99N8FsEQEFic29z1hBipgFrjBK3Fy8HmyFsECmxKmrTewgU1kEVCUW
	PecDCfMKeEgcmjSBEWKZgsScSTYgYU6g8J+TW8A6hQTcJRq3fGeHOHQXu8Ta62IgNouAgMS3
	yYdYIFplJTYdYIYokZQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxAuPh
	9L9nfTsYbx6wPsQowMGoxMPbUTg5RIg1say4MvcQoynQhonMUqLJ+cCoyyuJNzQ2M7IwNTE1
	NjK3NFMS502Q+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXHDizNckc9vqOpM2pfYbdzC
	Yva88/qZZlN7naApLzh99nXezs0tqN90cl0YB9tNbd3GwP2/9v55VWmbpMQp3be/vu0iR8+l
	3+lpZ2+ohXr5KBprHf1eYTBhy1z78NA6l7b0uJk8vseWT0zctXBD0NN/ejtZUjcGb9j69ZC1
	+NZDyw7N3KHGc02JpTgj0VCLuag4EQCRi2kHggIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jQV3mF5NDDP5strA4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNou7p46yWZzeXeLA5TGh/xOjx85Zd9k9
	Nq/Q8ti0qpPNo2/LKkaPFau/s3t83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjFjw8+V7AV7uCtePdvO2MB4mLOLkYNDQsBE4vDjii5GTiBTTOLCvfVsXYxcHEIC
	0xklWl/BOG1MEp8ffGIHqWIT0JH4v+8mmC0ioCCxufcZK0gRs8AVRombi9czgSSEBTIlTl1t
	YgfZwCKgKrHoOR9ImFfAQ+LQpAmMEIsVJOZMsgEJcwKF/5zcAtYpJOAu0bjlO/sERt4FjAyr
	GEVTC5ILipPSc430ihNzi0vz0vWS83M3MYLj7Zn0DsZVDRaHGAU4GJV4eDsKJ4cIsSaWFVfm
	HmKU4GBWEuF1PA4U4k1JrKxKLcqPLyrNSS0+xGgKdNNEZinR5HxgKsgriTc0NjEzsjQyN7Qw
	MjZXEudVsm8LERJITyxJzU5NLUgtgulj4uCUamBcPDn3ot5q35cznba37HO/Xfv78KaLrp+F
	e0/PYoj0eatk1W1TH7py2faznbl2Gu1Luu18zT3Ylv9Ku+9ZtUN7//yZbjNeOJ/0uhpZHi/4
	KlxO/uXPk2137i1c3vJxw5vsc6VhfyYlCosv/HegVOKjF/u/A/WPc7o8+gMF5980jMp/+MfP
	rnCzEktxRqKhFnNRcSIAA0b1W80CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prevents direct charging control in cable notification.
It sets only input current limit according to cable type and yields charging
control to be done by cm_monitor() where charging management proceeds.
It may loose few ms to enable charging compared to before, even though it's
more important that charging is enabled always in safe context.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/power/charger-manager.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 44cc19a..4f8b0e6 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -849,7 +849,8 @@ static void charger_extcon_work(struct work_struct *work)
 			cable->min_uA, cable->max_uA);
 	}
 
-	try_charger_enable(cable->cm, cable->attached);
+	cancel_delayed_work(&cm_monitor_work);
+	queue_delayed_work(cm_wq, &cm_monitor_work, 0);
 }
 
 /**
@@ -873,15 +874,6 @@ static int charger_extcon_notifier(struct notifier_block *self,
 	cable->attached = event;
 
 	/*
-	 * Setup monitoring to check battery state
-	 * when charger cable is attached.
-	 */
-	if (cable->attached && is_polling_required(cable->cm)) {
-		cancel_work_sync(&setup_polling);
-		schedule_work(&setup_polling);
-	}
-
-	/*
 	 * Setup work for controlling charger(regulator)
 	 * according to charger cable.
 	 */
-- 
1.7.9.5

