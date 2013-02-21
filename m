Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab3BUIeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:34:50 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:13791 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3BUIet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:34:49 -0500
X-AuditID: cbfee68e-b7fc26d000001938-37-5125dc2876f3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
In-reply-to: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
Subject: [PATCH 05/12] rtc: rtc-lp8788: use devm_request_threaded_irq()
Date: Thu, 21 Feb 2013 17:34:47 +0900
Message-id: <00d001ce100e$4ed96660$ec8c3320$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDe9M0/OnFjrjTvSUwIYm7R1WAgAAFB0A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zY12NO6qBBgdnillc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MRY/XMhc84axoe/mRpYFxIUcXIyeHhICJxKbG5awQtpjEhXvr
	2boYuTiEBJYxSrRea2OBKbo25xU7RGI6o8SlfS+gqmYzSXQ9WA/WziagJvHly2GgKg4OEQF9
	ibYWDZAaZoFeRokzvbvZQWqEBGwl5ny4xgxicwrYSVze9gWsV1jAXeLKmh9gNouAqkT7icls
	IDYvUP2CH99YIGxBiR+T74HZzAJaEut3HmeCsOUlNq95ywyyV0JAXeLRX12QsIiAkUTHkwPM
	ECUiEvtevGMEuUdCYBm7xM7tE5khdglIfJt8iAWiV1ZiE0S9hICkxMEVN1gmMErMQrJ5FpLN
	s5BsnoVkxQJGllWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIbHVt4Px5gHrQ4zJQOsnMkuJ
	JucDYzOvJN7Q2NjEzMTUxNzS1NyUNGElcV75SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODil
	Ghil+Qw1wj1/8Kgf17nbu+DvVnnHFL7uV09KO5594r9SPnXuD3fPT55qLWvq4+3rop/zvDum
	fNOS1f/L2nwlD5GLN18YKB67pH695P7qh3Uxe26brGy/mrXPo5SxJfzPV+cZ2XPu3wx+6r7/
	YWtkxA3xaN8rUhd5rlzhf51sfJdFd6G4QafskR1KLMUZiYZazEXFiQA3+84IwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoK7GHdVAg3U3hSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqLHa5kLnnBWtL38yNLA
	uJCji5GTQ0LAROLanFfsELaYxIV769m6GLk4hASmM0pc2vcCypnNJNH1YD0rSBWbgJrEly+H
	gTo4OEQE9CXaWjRAapgFehklzvTuBpskJGArMefDNWYQm1PATuLyti9gvcIC7hJX1vwAs1kE
	VCXaT0xmA7F5geoX/PjGAmELSvyYfA/MZhbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUE
	jCQ6nhxghigRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJERy5z6R2MK5ssDjEKMDBqMTDu+ClSqAQa2JZcWXuIUYJDmYlEV7TI6qBQrwpiZVV
	qUX58UWlOanFhxiTgR6dyCwlmpwPTCp5JfGGxiZmRpZGZhZGJubmpAkrifMynnoSICSQnliS
	mp2aWpBaBLOFiYNTqoGxWLHk9cczp55snn5HOLDphvpyu46rLKE/taf6Byz9KBD+ffnpeY3P
	TPwsLgdfOPVEjNf74g+bTQ0GAswhRyRkvpiLxOcnXfU9sro1PuMIw8Jzm5fxb39se/xdV7n3
	ZQmxD4bx7/UWXJ3raCPE2ab7VZt9fyWzy5WHs5wDLT0NlaZta+O1MmFSYinOSDTUYi4qTgQA
	2dm39yADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-lp8788.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-lp8788.c b/drivers/rtc/rtc-lp8788.c
index 4a4e78e..9a46312 100644
--- a/drivers/rtc/rtc-lp8788.c
+++ b/drivers/rtc/rtc-lp8788.c
@@ -278,16 +278,11 @@ static int lp8788_alarm_irq_register(struct platform_device *pdev,
 
 	rtc->irq = irq_create_mapping(irqdm, irq);
 
-	return request_threaded_irq(rtc->irq, NULL, lp8788_alarm_irq_handler,
+	return devm_request_threaded_irq(&pdev->dev, rtc->irq, NULL,
+				lp8788_alarm_irq_handler,
 				0, LP8788_ALM_IRQ, rtc);
 }
 
-static void lp8788_alarm_irq_unregister(struct lp8788_rtc *rtc)
-{
-	if (rtc->irq)
-		free_irq(rtc->irq, rtc);
-}
-
 static int lp8788_rtc_probe(struct platform_device *pdev)
 {
 	struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
@@ -321,7 +316,6 @@ static int lp8788_rtc_remove(struct platform_device *pdev)
 {
 	struct lp8788_rtc *rtc = platform_get_drvdata(pdev);
 
-	lp8788_alarm_irq_unregister(rtc);
 	rtc_device_unregister(rtc->rdev);
 	platform_set_drvdata(pdev, NULL);
 
-- 
1.7.2.5


