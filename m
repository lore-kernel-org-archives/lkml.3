Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935368Ab3BOGDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:03:34 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:43997 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3BOGDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:03:33 -0500
X-AuditID: cbfee68e-b7fc26d000001938-4f-511dcfb44a90
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
In-reply-to: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
Subject: [PATCH 10/11] rtc: rtc-pcf8583: use dev_warn() instead of printk()
Date: Fri, 15 Feb 2013 15:03:31 +0900
Message-id: <001b01ce0b42$2ea49c50$8bedd4f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LQUiQnZ5yIGDDRaO8BQe4Zm4AfgAAM0sg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zY90t52UDDd6dl7e4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZi9fdYyz4yVYx4eAWtgbGq6xdjJwcEgImEvuvNTND2GISF+6t
	Z+ti5OIQEljGKLG35S07TNHEC82MEIlFjBLn1/+GqprNJPHmwksWkCo2ATWJL18OA3VwcIgI
	6Eu0tWiA1DAL9DJKnOndDTZJSMBWYsKndWDrOAXsJL7/ecgGYgsLeEu8mnIfzGYRUJU4t+4c
	mM0LVL/64zYWCFtQ4sfke2A2s4CWxOZtTawQtrzE5jVvmUH2SgioSzz6qwsSFhEwkvi4oIUJ
	okREYt+Ld2APSAgsY5e4MfsAI8QuAYlvkw+xQPTKSmw6AA0JSYmDK26wTGCUmIVk8ywkm2ch
	2TwLyYoFjCyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MUJiq28H480D1ocYk4HWT2SWEk3O
	B8ZmXkm8obGxiZmJqYm5pam5KWnCSuK88pdkAoUE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw
	dslUc60WODn98k+Nb4refpolqsnGBx7YZ9j0iOafM1LYWvbEaPPh5bventx7fF+C4t+pl1Y2
	LmzZ/9PM849zMCvnyumVx39f66+ZtUSmPrC/bKf1LWMxy2lqnwVMn8y/8/sO76yDV6VEi2bt
	vdKpeW3xgziZtbJl+x1jb3KueBVXw3qJz+hJlxJLcUaioRZzUXEiADjfHxvDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO6W87KBBjPvMFtc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjMXr7jEW/GSrmHBwC1sD
	41XWLkZODgkBE4mJF5oZIWwxiQv31rN1MXJxCAksYpQ4v/43lDObSeLNhZcsIFVsAmoSX74c
	Zu9i5OAQEdCXaGvRAKlhFuhllDjTu5sdpEZIwFZiwqd1zCA2p4CdxPc/D9lAbGEBb4lXU+6D
	2SwCqhLn1p0Ds3mB6ld/3MYCYQtK/Jh8D8xmFtCS2LytiRXClpfYvOYtM8heCQF1iUd/dUHC
	IgJGEh8XtDBBlIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0u
	zUvXS87P3cQIjtxn0jsYVzVYHGIU4GBU4uEVkJANFGJNLCuuzD3EKMHBrCTCuyYEKMSbklhZ
	lVqUH19UmpNafIgxGejRicxSosn5wKSSVxJvaGxiZmRpZGZhZGJuTpqwkjgv46knAUIC6Ykl
	qdmpqQWpRTBbmDg4pRoYVY15dHo0nBn+bLVJWnzdgZWLYZLykZi/JdofOEvK5X6ESsQJc1T4
	TZ2xrWDb/J4HC/xfWv1a8fP4rPnmqTvzpA3abjuGSe7mfPiPVVlb30qVUWup7z8BxUOnVG/v
	WZbccup48tkXF1oMcnvu7Oe7VlSqJ/rol/5KvR3yH3zV2GZtVmGdK7VDiaU4I9FQi7moOBEA
	AjIMvyADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pcf8583.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8583.c b/drivers/rtc/rtc-pcf8583.c
index 3415b8f..aa9bf2b 100644
--- a/drivers/rtc/rtc-pcf8583.c
+++ b/drivers/rtc/rtc-pcf8583.c
@@ -185,7 +185,7 @@ static int pcf8583_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	if (ctrl & (CTRL_STOP | CTRL_HOLD)) {
 		unsigned char new_ctrl = ctrl & ~(CTRL_STOP | CTRL_HOLD);
 
-		printk(KERN_WARNING "RTC: resetting control %02x -> %02x\n",
+		dev_warn(dev, "RTC: resetting control %02x -> %02x\n",
 		       ctrl, new_ctrl);
 
 		if ((err = pcf8583_set_ctrl(client, &new_ctrl)) < 0)
-- 
1.7.2.5


