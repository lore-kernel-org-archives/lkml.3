Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935519Ab3BOH1C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:27:02 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60391 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935388Ab3BOH1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:27:00 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-b7-511de34344c6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
In-reply-to: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
Subject: [PATCH V3 04/11] rtc: rtc-ds2404: use dev_err() instead of printk()
Date: Fri, 15 Feb 2013 16:26:59 +0900
Message-id: <002e01ce0b4d$d77e0270$867a0750$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LTYY6VzXwCUtKTcq8t8M0FTt2HQAADQ6w
Content-language: ko
x-cr-hashedpuzzle: Gk0F Mcku NfuK R3bV Suy6 VSgV WjmD ZECt ZM3k ayd1 nR94 pYxj
 sBeE x906 zLws
 zZfP;5;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcgB0AGMALQBsAGkAbgB1AHgAQABnAG8AbwBnAGwAZQBnAHIAbwB1AHAAcwAuAGMAbwBtAA==;Sosha1_v1;7;{CC394ABA-A623-416F-817F-222F1C6EA019};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Fri,
 15 Feb 2013 07:26:51
 GMT;WwBQAEEAVABDAEgAIABWADMAIAAwADQALwAxADEAXQAgAHIAdABjADoAIAByAHQAYwAtAGQAcwAyADQAMAA0ADoAIAB1AHMAZQAgAGQAZQB2AF8AZQByAHIAKAApACAAaQBuAHMAdABlAGEAZAAgAG8AZgAgAHAAcgBpAG4AdABrACgAKQA=
x-cr-puzzleid: {CC394ABA-A623-416F-817F-222F1C6EA019}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zQ13nx7KBBlNvmFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MtZumshes4qxYPvc8cwPjXvYuRk4OCQETiVkTzrNB2GISF+6t
	B7K5OIQEljFKLP75mLmLkQOsaGa3PUR8EaPEoldPWEEahARmM0k0nvIBsdkE1CS+fDnMDlIv
	IqAv0daiAVLPLNDLKHGmdzc7RL2txNTf38B6OQXsJFZP6gCLCwv4SJz6NokRxGYRUJWYPGEu
	mM0LVL9oey8bhC0o8WPyPRYQm1lAS2LztiZWCFteYvOat1B3qks8+qsLEhYRMJJY/G87E0SJ
	iMS+F+8YQe6REPjAKvH5wGGo500lvk0/yAqR2Mcu8aHtJxPEEQIS3yYfYoEYKiux6QAzRL2k
	xMEVN1gmMErNQnLSLCQnzUJy0iwkuxcwsqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECInE
	3h2Mtw9YH2JMBlo/kVlKNDkfGMl5JfGGxsYmZiamJuaWpuampAkrifPKXZIJFBJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cAo71P5r8r/UVNK+pr6vbpqk99sEdiYPkX+2e7nm6T9/7w0ZDev
	y/zQ8+6LesvpaLuo5e/EZ1Wxz+SWYO+1rNMIsJzGoO5+Yyp7R3rDmiPsT67FxfJcqNUXndn7
	3vNfauDN76K203sjdDLWHhM+LqGb+tr7EmP7ZLk3+2ffDUo5eEjwc898+y1KLMUZiYZazEXF
	iQCUXPWY2gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAV3nx7KBBg8mGllc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjLWbprIXrOKsWD73PHMD
	4172LkYODgkBE4mZ3fZdjJxAppjEhXvr2boYuTiEBBYxSix69YQVJCEkMJtJovGUD4jNJqAm
	8eXLYbBeEQF9ibYWDZB6ZoFeRokzvbvZIeptJab+/gbWyylgJ7F6UgdYXFjAR+LUt0mMIDaL
	gKrE5AlzwWxeoPpF23vZIGxBiR+T77GA2MwCWhKbtzWxQtjyEpvXvGWGuFld4tFfXZCwiICR
	xOJ/25kgSkQk9r14xwhyj4TAB1aJzwcOs0M8ZirxbfpB1gmMIrOQrJiFZMUsJCtmIZm1gJFl
	FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwnD+T2sG4ssHiEKMAB6MSD6+AhGygEGtiWXFl
	7iFGCQ5mJRFeuVtAId6UxMqq1KL8+KLSnNTiQ4zJwBCYyCwlmpwPTEF5JfGGxiZmRpZGZhZG
	JubmpAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoExICQ9YrL2pKovHyOLjssquWwO6Kpy
	qbwZWJ4y4VDYwxTRZVsKr3z3WreI12TrhK9ev+xu7Y6KP6xwsq5PbZM8R/jUkmc5Qdf8+b2L
	5DOe7mcx3Mx29LL9lOKTn+N+n2RpO+9Soj+DW2d26wOtPpOfj37rRR56sPxF00ZDRT+mqpyu
	wkg2+XtKLMUZiYZazEXFiQDpeyjHNwMAAA==
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
No changes since v1:

No changes since v2:

 drivers/rtc/rtc-ds2404.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds2404.c b/drivers/rtc/rtc-ds2404.c
index 4539e37..b04fc42 100644
--- a/drivers/rtc/rtc-ds2404.c
+++ b/drivers/rtc/rtc-ds2404.c
@@ -70,7 +70,7 @@ static int ds2404_gpio_map(struct ds2404 *chip, struct platform_device *pdev,
 	for (i = 0; i < ARRAY_SIZE(ds2404_gpio); i++) {
 		err = gpio_request(ds2404_gpio[i].gpio, ds2404_gpio[i].name);
 		if (err) {
-			printk(KERN_ERR "error mapping gpio %s: %d\n",
+			dev_err(&pdev->dev, "error mapping gpio %s: %d\n",
 				ds2404_gpio[i].name, err);
 			goto err_request;
 		}
@@ -177,7 +177,7 @@ static void ds2404_write_memory(struct device *dev, u16 offset,
 
 	for (i = 0; i < length; i++) {
 		if (out[i] != ds2404_read_byte(dev)) {
-			printk(KERN_ERR "read invalid data\n");
+			dev_err(dev, "read invalid data\n");
 			return;
 		}
 	}
-- 
1.7.2.5

