Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361AbaDINUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:20:36 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:18850 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002AbaDINU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:20:27 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-95-53454918b975
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/4] extcon: max77693: Use power efficient workqueue for
 delayed cable detection
Date: Wed, 09 Apr 2014 15:20:13 +0200
Message-id: <1397049615-13130-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397049615-13130-1-git-send-email-k.kozlowski@samsung.com>
References: <1397049615-13130-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOJMWRmVeSWpSXmKPExsVy+t/xy7oSnq7BBo13xSyuf3nOavH6haHF
	5V1z2CxuN65gc2Dx6NuyitHj8ya5AKYoLpuU1JzMstQifbsErowzm9YwFRxkr/h1+htLA+M2
	ti5GTg4JAROJmVdPs0DYYhIX7q0HinNxCAksZZTYcbGTEcLpY5LYNXUjO0gVm4CxxOblS8C6
	RQQKJZ5suApmMwsYSvx89wesRlggSeLUpausIDaLgKrEubYnYDW8Au4SJw++YYbYpiCx7Mta
	MJtTwENi8r+VYL1CQDXNC5qZJjDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kREhhf
	djAuPmZ1iFGAg1GJh1fB0iVYiDWxrLgy9xCjBAezkghvm4FrsBBvSmJlVWpRfnxRaU5q8SFG
	Jg5OqQZGueuf3SeKJKjw2Rw7wZaWcES7xC9W7dgu1bxCEeYlj0LcfHm1Vn+1idX/udRx08xt
	70RfR/4vjhX3Ft5293aFlHR44OUNTfVTZt2oWqXFdPdi7yzjHIYzDU2mKS4989R4wgvONGQI
	tb44dUGoN8OzJzd29h8P7X3bM7nuzFyoXFdwW/aPU7MSS3FGoqEWc1FxIgDlq73v6gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Schedule delayed cable detection work on power efficient workqueue
so the scheduler won't wake up idle core for that work.
This extends the idle time for CPU cores and conserves power.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max77693.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 4657a91acf56..39cd095d103c 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1283,7 +1283,8 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	 * driver should notify cable state to upper layer.
 	 */
 	INIT_DELAYED_WORK(&info->wq_detcable, max77693_muic_detect_cable_wq);
-	schedule_delayed_work(&info->wq_detcable, delay_jiffies);
+	queue_delayed_work(system_power_efficient_wq, &info->wq_detcable,
+			delay_jiffies);
 
 	return ret;
 
-- 
1.8.3.2

