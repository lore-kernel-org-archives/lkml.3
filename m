Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbaJ3Moi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:44:38 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23881 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759800AbaJ3Mnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:31 -0400
X-AuditID: cbfee68d-f79296d000004278-17-5452326a8ea4
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 08/10] power: charger-manager: Not to start charging directly
 in cable nofitication.
Date: Thu, 30 Oct 2014 21:43:14 +0900
Message-id: <1414672996-28355-9-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1414672996-28355-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkUDfLKCjE4Ox6IYuDWzUtrn95zmox
	6cl7ZouJKyczW3SefcJscXnXHDaLz71HGC1uN65gs7h76iibxendJQ5cHhP6PzF67Jx1l91j
	8wotj02rOtk8+rasYvRYsfo7u8fnTXIB7FFcNimpOZllqUX6dglcGY8+RRbs4a64fOwAYwPj
	Yc4uRk4OCQETid5HvYwQtpjEhXvr2boYuTiEBJYyShyb2soCU7Rxy0JWiMQiRon/7+YyQjht
	TBJ3mlawg1SxCehI/N93E8wWEVCQ2Nz7DKyDWeAKo8TNxeuZQBLCAmkSh1s+gRWxCKhKzL98
	HmgSBwevgIfE4ccKIKYEUO+cSTYgFZwCnhKbrswEO0IIqOLBri52kJESAvvYJQ7vu80EMUZA
	4tvkQywQvbISmw4wQxwtKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmIE
	RsTpf896dzDePmB9iFGAg1GJh1fjRGCIEGtiWXFl7iFGU6ANE5mlRJPzgXGXVxJvaGxmZGFq
	YmpsZG5ppiTOqyj1M1hIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDoz7XLv+8VRdeM+7OWPvu
	7H2uw5P59tXunhlxP+fpnnX9/87ovdR97PdQ4hb3+Q8SufYqH78oHjQT3CFo46js9f28y3q9
	Lt/TXXu6UgJ6UvfNDf6VKvXLoTDre53gmdWy3HZfjyUpvM8wcJ//xiSliOHh123VmpFiKxdN
	v2bKseDdmvenP39t9lRiKc5INNRiLipOBADcfOYrgwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd0so6AQg/l3uSwObtW0uP7lOavF
	pCfvmS0mrpzMbNF59gmzxeVdc9gsPvceYbS43biCzeLuqaNsFqd3lzhweUzo/8TosXPWXXaP
	zSu0PDat6mTz6NuyitFjxerv7B6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
	GOoaWlqYKynkJeam2iq5+AToumXmAF2npFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiu
	x8gADSSsYcx49CmyYA93xeVjBxgbGA9zdjFyckgImEhs3LKQFcIWk7hwbz1bFyMXh5DAIkaJ
	/+/mMkI4bUwSd5pWsINUsQnoSPzfdxPMFhFQkNjc+4wVpIhZ4AqjxM3F65lAEsICaRKHWz6B
	FbEIqErMv3weaBIHB6+Ah8ThxwogpgRQ75xJNiAVnAKeEpuuzGQBsYWAKh7s6mKfwMi7gJFh
	FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwvD2T3sG4qsHiEKMAB6MSD6/GicAQIdbEsuLK
	3EOMEhzMSiK8R3WCQoR4UxIrq1KL8uOLSnNSiw8xmgLdNJFZSjQ5H5gK8kriDY1NzIwsjcwN
	LYyMzZXEeQ+2WgcKCaQnlqRmp6YWpBbB9DFxcEo1MM4uiGjZnHO+5kLtlLUu8kKuM+6tNC7e
	mJaVb+DtE3T6/gvDlCefLjZYl9tEzVH2/uJ6+FqUffpVUbmtu79P0bKZ++rVtJUnHFfy8q/Z
	90BwusnDD7UGorNaXxXf2eocYVejtz/PfNGeG3b/3//Y83XnkpRnwfztBfdn7ppTeODZSV3u
	sC0PJbKUWIozEg21mIuKEwGpMjfzzQIAAA==
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
index 065b92a..1ccb9be 100644
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

