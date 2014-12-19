Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaLSCse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:48:34 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14641 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaLSCrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:47:42 -0500
X-AuditID: cbfee68e-f79b46d000002b74-4e-549391c9a890
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, sre@kernel.org, dbaryshkov@gmail.com,
        dwmw2@infradead.org, anton@enomsg.org, pavel@ucw.cz,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH RESEND v2 08/10] power: charger-manager: Not to start charging
 directly in cable nofitication.
Date: Fri, 19 Dec 2014 11:47:28 +0900
Message-id: <1418957250-6542-9-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1418957250-6542-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsWyRsSkRPfkxMkhBv+eS1kc3Kppcf3Lc1aL
	SU/eM1tMXDmZ2aLz7BNmi8u75rBZfO49wmhxu3EFm8XdU0fZLE7vLnHg8pjQ/4nRY+esu+we
	m1doeWxa1cnm0bdlFaPHitXf2T0+b5ILYI/isklJzcksSy3St0vgynj0KbJgD3fF5WMHGBsY
	D3N2MXJySAiYSPS83skMYYtJXLi3nq2LkYtDSGApo8TRzTPZuxg5wIpO9SWC1AgJLGKU6DzD
	AVHTxiSx4/JXNpAEm4COxP99N9lBbBEBBYnNvc9YQYqYBa4wStxcvJ4JJCEsUCDR8uE9mM0i
	oCrxr/0gmM0r4C6xYmEPK8QyBYk5k2xAwpwCHhJPLzWxQSx2lzjx7S0LyEwJgW3sEkvb1zBD
	zBGQ+Db5EAtEr6zEpgNQz0hKHFxxg2UCo/ACRoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmb
	GIHxcPrfs74djDcPWB9iFOBgVOLh7SicHCLEmlhWXJl7iNEUaMNEZinR5Hxg1OWVxBsamxlZ
	mJqYGhuZW5opifMmSP0MFhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cA4a2nDn+VFEqEGNoXp
	376zTeGYcNP/0dz5PX1Gp/N3G7fNZN34dsoRs/M+z52ZxLs/Hz7U9u/FbP8TP+3lb1lGFKzj
	sWxg+cQXb+DSve+/JBerWFqu1ZeOA7xFe9bJ33Zk2v/WN25Wv9JkoTtRKWuDX2/qOBh8KcUq
	cM2q2VlWaR41wuUB2p+VWIozEg21mIuKEwGmob8/ggIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd2TEyeHGHQuFbY4uFXT4vqX56wW
	k568Z7aYuHIys0Xn2SfMFpd3zWGz+Nx7hNHiduMKNou7p46yWZzeXeLA5TGh/xOjx85Zd9k9
	Nq/Q8ti0qpPNo2/LKkaPFau/s3t83iQXwB7VwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pm
	YKhraGlhrqSQl5ibaqvk4hOg65aZA3SdkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4
	HiMDNJCwhjHj0afIgj3cFZePHWBsYDzM2cXIwSEhYCJxqi+xi5ETyBSTuHBvPRuILSSwiFGi
	8wxHFyMXkN3GJLHj8lewBJuAjsT/fTfZQWwRAQWJzb3PWEGKmAWuMErcXLyeCSQhLFAg0fLh
	PZjNIqAq8a/9IJjNK+AusWJhDyvEYgWJOZNsQMKcAh4STy81QS12lzjx7S3LBEbeBYwMqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo+2Z9A7GVQ0WhxgFOBiVeHg7CieHCLEmlhVX5h5i
	lOBgVhLhNc8ECvGmJFZWpRblxxeV5qQWH2I0BTpqIrOUaHI+MBHklcQbGpuYGVkamRtaGBmb
	K4nzKtm3hQgJpCeWpGanphakFsH0MXFwSjUwxvfl/bBxr2E6tni5lHfs2SfBt1+XbWHtvvkj
	c9urQvaJFr2aJ32q3f7cWPSBa2HzNudQhdu7n8n43KljNpu567vX8h9/vS8lbJvHXGkYffDO
	p9CN25cG33cWnve/yifDeabKd8mK0wZzvEJ9MsVa+7wUP97iYzrwVl+gjGFOo946vTB5+1hm
	JZbijERDLeai4kQAStmzOswCAAA=
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

