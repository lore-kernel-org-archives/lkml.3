Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab3EWKlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:41:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54059 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999Ab3EWKlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:41:52 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-c1-519df26ff6c8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] rtc: rtc-coh901331: use platform_{get,set}_drvdata()
Date: Thu, 23 May 2013 19:41:50 +0900
Message-id: <003101ce57a2$2226a700$6673f500$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Xohdf4bBJxqQqRei5HhYwEOX0Qw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zfd38T3MDDabu5bRYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEr40ffAuaCU5wVj86KNTBO5Ohi5OSQEDCR6Pt8ghnCFpO4cG89WxcjF4eQwDJGiU39
	T1hgiv6//MIKkZjOKPHyezMThPOLUeLPk12MIFVsAmoSX74cZu9i5OAQEdCXaGvRAKlhFuhl
	lDjTu5sdpEZYwFPi4sUjYDaLgKrEvx3H2UBsXgFLibnXbjJC2IISPybfA9vMLKAlsX7ncSYI
	W15i85q3UKcqSOw4+xqsXkRAT2JJw1tWiBoRiX0v3jGCLJYQOMYu0XptKdQyAYlvkw+xgBwn
	ISArsekA1BxJiYMrbrBMYBSbhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KLDPWKE3OLS/PS
	9ZLzczcxQmKvdwfj7QPWhxiTgdZPZJYSTc4Hxm5eSbyhsZmRhamJqbGRuaUZacJK4rxqLdaB
	QgLpiSWp2ampBalF8UWlOanFhxiZODilGhjV3T6/kT+xarr/me99m1Qj1I5o/gz0Xv46Jl5y
	+dO9uzi+TXrW0LmW8fX8eS7T3cOdkzUu7BA1KvD58j9NJzqjb5FLkPnfzqNnlMMr8tO//6lX
	tX3opbh5vbqs0dw0O66rDArXpzStz+sLepi64+zsdRm7krV3BD5fe+XcklPp7E5T9FhkzViV
	WIozEg21mIuKEwH/4HlY0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQd38T3MDDWbfZbVYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMeNH3wLmglOcFY/OijUwTuToYuTkkBAwkfj/
	8gsrhC0mceHeerYuRi4OIYHpjBIvvzczQTi/GCX+PNnFCFLFJqAm8eXLYfYuRg4OEQF9ibYW
	DZAaZoFeRokzvbvZQWqEBTwlLl48AmazCKhK/NtxnA3E5hWwlJh77SYjhC0o8WPyPRYQm1lA
	S2L9zuNMELa8xOY1b5khLlKQ2HH2NVi9iICexJKGt6wQNSIS+168Y5zAKDALyahZSEbNQjJq
	FpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI/uZ1A7GlQ0WhxgFOBiVeHglbs8J
	FGJNLCuuzD3EKMHBrCTCu7lnbqAQb0piZVVqUX58UWlOavEhxmSgTycyS4km5wOTTl5JvKGx
	iZmRpZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MC5at6j0wpxkC73SwpyY
	a/tjvy3um30jeFarufs9q1P5gXmbSmWnV62v4xE73MzwKHvjzSzLtQUKHWd2nNq3IVHgkNWe
	f5HSW9rFXiQtttideVzlYuiSD7ESFZFHQmvTJI9eN7+0Z7mhRalEyUSp0rKNN/TDZLqUNqS3
	mv/MMc/XUr/9ycD6uBJLcUaioRZzUXEiAMlesywwAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-coh901331.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 9ad5891..e1ae0df 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -152,7 +152,7 @@ static struct rtc_class_ops coh901331_ops = {
 
 static int __exit coh901331_remove(struct platform_device *pdev)
 {
-	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
+	struct coh901331_port *rtap = platform_get_drvdata(pdev);
 
 	if (rtap)
 		clk_unprepare(rtap->clk);
@@ -264,7 +264,7 @@ static SIMPLE_DEV_PM_OPS(coh901331_pm_ops, coh901331_suspend, coh901331_resume);
 
 static void coh901331_shutdown(struct platform_device *pdev)
 {
-	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
+	struct coh901331_port *rtap = platform_get_drvdata(pdev);
 
 	clk_enable(rtap->clk);
 	writel(0, rtap->virtbase + COH901331_IRQ_MASK);
-- 
1.7.10.4


