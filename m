Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab3CDIBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 03:01:35 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32269 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab3CDIBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 03:01:34 -0500
X-AuditID: cbfee690-b7f6b6d000004563-35-513454dde296
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
In-reply-to: <013a01ce18ad$e45caa10$ad15fe30$%han@samsung.com>
Subject: [PATCH 10/24] rtc: rtc-imxdi: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 17:01:33 +0900
Message-id: <014301ce18ae$7c80b930$75822b90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YreQ8fe1F97iqQuy+DT8iOTwTtAAAInjg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zQ927ISaBBnuuS1ssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8eVsE2vBX/aKE8/OMjUwfmLrYuTkkBAwkVj+8QgjhC0mceHeeqA4F4eQwDJGida5
	p+GKZt9/AJWYzihx5Ol1KOcXo8Tywy/ZQarYBNQkvnw5DGRzcIgI6Eu0tWiA1DAL9DJKnOnd
	DVYjJGAr8eXhAyYQm1PATuL+uVWsILawgKfEzM/PmUFsFgFViVU//oCdxAtU/6m5nxXCFpT4
	MfkeC4jNLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgYSVz6dIMVokREYt+Ld4wg90gI
	3GOXmHNqLhPELgGJb5MPsUD0ykpsOsAM8bCkxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJGllWM
	oqkFyQXFSelFJnrFibnFpXnpesn5uZsYIbE6YQfjvQPWhxiTgdZPZJYSTc4HxnpeSbyhsbGJ
	mYmpibmlqbkpacJK4rzyl2QChQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAu+L309OzXmXle
	Pnsuzd2wLVDgwgc98w6Zutc8ZokO5SZffjn9zPHZOWPv8mt8SzYE/fnxRv09e2E0V6j9GbVu
	i63zYzS8pm9bKBdaNqtmuZ1q2D+VhL/+WqsbTtmU/e/N/rVJePH30wV9CwPl5OvvOHPoLLp8
	YKasYe3h/eUrEoSL39xZuoJFiaU4I9FQi7moOBEAB3StKOsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd27ISaBBvuWiFssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPHlbBNrwV/2ihPPzjI1MH5i62Lk5JAQMJGY
	ff8BlC0mceHeeiCbi0NIYDqjxJGn16GcX4wSyw+/ZAepYhNQk/jy5TCQzcEhIqAv0daiAVLD
	LNDLKHGmdzdYjZCArcSXhw+YQGxOATuJ++dWsYLYwgKeEjM/P2cGsVkEVCVW/fjDCGLzAtV/
	au5nhbAFJX5MvscCYjMLaEms33mcCcKWl9i85i0zyF4JAXWJR391QcIiAkYSlz7dYIUoEZHY
	9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcCJ5J
	72Bc1WBxiFGAg1GJh1fgk3GgEGtiWXFl7iFGCQ5mJRHeMgmTQCHelMTKqtSi/Pii0pzU4kOM
	yUCPTmSWEk3OByapvJJ4Q2MTMyNLIzMLIxNzc9KElcR5GU89CRASSE8sSc1OTS1ILYLZwsTB
	KdXA6Lf77KqDxYctU54yHk279pWj47FQn0yq7AT3ex+b7Mv3bdjR+PKf9bR1GaWrInWnhXw7
	9SbBgav9ybne2XEljvn5n1tLzbd064ZvbDIw+vjwybmnkw/u6JrRPXelyx917Yg+BvMTjc7i
	j9TLo7zkddt9mm7Znjjx+PL89s0Xdlm+fdDw7MvHTiWW4oxEQy3mouJEANPnhptIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-imxdi.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index 73cf81c..a5a143e 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -513,18 +513,7 @@ static struct platform_driver dryice_rtc_driver = {
 	.remove = __exit_p(dryice_rtc_remove),
 };
 
-static int __init dryice_rtc_init(void)
-{
-	return platform_driver_probe(&dryice_rtc_driver, dryice_rtc_probe);
-}
-
-static void __exit dryice_rtc_exit(void)
-{
-	platform_driver_unregister(&dryice_rtc_driver);
-}
-
-module_init(dryice_rtc_init);
-module_exit(dryice_rtc_exit);
+module_platform_driver_probe(dryice_rtc_driver, dryice_rtc_probe);
 
 MODULE_AUTHOR("Freescale Semiconductor, Inc.");
 MODULE_AUTHOR("Baruch Siach <baruch@tkos.co.il>");
-- 
1.7.2.5


