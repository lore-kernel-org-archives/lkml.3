Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbaDINUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:20:39 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25720 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121AbaDINU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:20:27 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-9e-53454919b14a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 4/4] extcon: max8997: Use power efficient workqueue for delayed
 cable detection
Date: Wed, 09 Apr 2014 15:20:15 +0200
Message-id: <1397049615-13130-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397049615-13130-1-git-send-email-k.kozlowski@samsung.com>
References: <1397049615-13130-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGJMWRmVeSWpSXmKPExsVy+t/xy7qSnq7BBvuvcFpc//Kc1eL1C0OL
	y7vmsFncblzB5sDi0bdlFaPH501yAUxRXDYpqTmZZalF+nYJXBmX3zcwF2xjr5h8o5+tgXE1
	WxcjJ4eEgInE6mVnmCFsMYkL99YDxbk4hASWMkrM2D0HLCEk0Mckcas/HsRmEzCW2Lx8CViz
	iEChxJMNV8FsZgFDiZ/v/rCD2MICiRLLvk5kBbFZBFQlet/dB4vzCrhLPPj7FGqZgsSyL2vB
	bE4BD4nJ/1ayQ+xyl2he0Mw0gZF3ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQsPiy
	g3HxMatDjAIcjEo8vAqWLsFCrIllxZW5hxglOJiVRHjbDFyDhXhTEiurUovy44tKc1KLDzEy
	cXBKNTAGC9T272U7teBW5jSmBWHi+u+vdRjzc0c5V92b+WpBsItESKb+KpFZRi7x87a8O3xn
	ntIKB2cF952nxXvvie9Zu7Xc8OB8O+nAj92HvPf77vy7Lk1w35kg3hUnE0v33J7p3rL91rra
	gtiSepm8NJ5dTxMv1UZ2VW/eqfXmg2zpp68OWUbJnQlKLMUZiYZazEXFiQD7uX156QEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Schedule delayed cable detection work on power efficient workqueue
so the scheduler won't wake up idle core for that work.
This extends the idle time for CPU cores and conserves power.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max8997.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 5e1b88cecb76..223e6b068c98 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -770,7 +770,8 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	 * driver should notify cable state to upper layer.
 	 */
 	INIT_DELAYED_WORK(&info->wq_detcable, max8997_muic_detect_cable_wq);
-	schedule_delayed_work(&info->wq_detcable, delay_jiffies);
+	queue_delayed_work(system_power_efficient_wq, &info->wq_detcable,
+			delay_jiffies);
 
 	return 0;
 
-- 
1.8.3.2

