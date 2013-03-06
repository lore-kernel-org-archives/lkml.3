Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575Ab3CFF1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:27:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:28016 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3CFF1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:27:43 -0500
X-AuditID: cbfee68d-b7f636d0000009be-3c-5136d3ce0a3b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 02/30] rtc: rtc-coh90133: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:27:41 +0900
Message-id: <004401ce1a2b$52fe3370$f8fa9a50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAArFA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zfd1zl80CDTqWsFgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsWztOaaCNxwVm58ZNjBuY+9i5OSQEDCRWHh4GZQtJnHh3nq2LkYuDiGBZYwSO89P
	YIYpeni9gQUiMZ1RYuPfbYwQzi9Gifv3zrCCVLEJqEl8+XIYaBQHh4iAvkRbiwZIDbNAL6PE
	md7dYCuEBGwlrnavApvKKWAnsfzxLBYQW1jAQ2LJ9ytsIDaLgKrE48fzwep5gep//L7FBmEL
	SvyYfA+snllAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsLEhYRMJL4tfYiI0SJiMS+F+/AbpYQ
	uMcucW5nKxPELgGJb5MPsUD0ykpsOgD1sKTEwRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyi
	qQXJBcVJ6UWGesWJucWleel6yfm5mxghkdq7g/H2AetDjMlA6ycyS4km5wMjPa8k3tDY2MTM
	xNTE3NLU3JQ0YSVxXrlLMoFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGCuZLi8sunc7Q6zp
	085XHfmam9v/mNnHbPL58OtqGrOu5gMx+X0T+RZFyIizhd3k/lrbolf+9WbSqg+x362lGc90
	Gx9dzur11S9Kwam+5tyTEIWPs6583ihh4exS2NTzpKz03XuLddmsZnw3ZB/zX592JqDvrVfI
	oTduz7Rz/J32169/s9HzhRJLcUaioRZzUXEiAJkB08XqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd2zl80CDVaes7FYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPZ2nNMBW84KjY/M2xg3MbexcjJISFgIvHw
	egMLhC0mceHeerYuRi4OIYHpjBIb/25jhHB+MUrcv3eGFaSKTUBN4suXw0DdHBwiAvoSbS0a
	IDXMAr2MEmd6d4NNFRKwlbjavYoZxOYUsJNY/ngW2AZhAQ+JJd+vsIHYLAKqEo8fzwer5wWq
	//H7FhuELSjxY/I9sHpmAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBI4tfai4wQJSIS
	+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGC08Az
	qR2MKxssDjEKcDAq8fBaKJkFCrEmlhVX5h5ilOBgVhLh5ToDFOJNSaysSi3Kjy8qzUktPsSY
	DPToRGYp0eR8YIrKK4k3NDYxM7I0MrMwMjE3J01YSZyX8dSTACGB9MSS1OzU1ILUIpgtTByc
	Ug2MbrkeTSJqifIH1jhvD3X5aKazR7lEMZPboWCC//n8g+6SPueP6QQeCmz+cfUdj8TRx1vm
	v260WVsq/i79adKq9DWb/dty4qU2ucSuPB6244lOmKnfgvfGD/6oz5jqdsX6cpdS8IRJEo5L
	m+cWR8gsWVZ0RJRLSiduyfWZT/OObfr0y66kVF5AiaU4I9FQi7moOBEAHkP4GEcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-coh901331.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 2d28ec1a..a051f76 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -155,7 +155,6 @@ static int __exit coh901331_remove(struct platform_device *pdev)
 	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
 
 	if (rtap) {
-		rtc_device_unregister(rtap->rtc);
 		clk_unprepare(rtap->clk);
 		platform_set_drvdata(pdev, NULL);
 	}
@@ -211,8 +210,8 @@ static int __init coh901331_probe(struct platform_device *pdev)
 	clk_disable(rtap->clk);
 
 	platform_set_drvdata(pdev, rtap);
-	rtap->rtc = rtc_device_register("coh901331", &pdev->dev, &coh901331_ops,
-					 THIS_MODULE);
+	rtap->rtc = devm_rtc_device_register("coh901331", &pdev->dev,
+					&coh901331_ops, THIS_MODULE);
 	if (IS_ERR(rtap->rtc)) {
 		ret = PTR_ERR(rtap->rtc);
 		goto out_no_rtc;
-- 
1.7.2.5


