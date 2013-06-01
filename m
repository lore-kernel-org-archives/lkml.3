Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab3FAHb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 03:31:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61272 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3FAHbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 03:31:53 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-79-51a9a367c241
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] rtc: rtc-pcf2123: replace strict_strtoul() with kstrtoul()
Date: Sat, 01 Jun 2013 16:31:51 +0900
Message-id: <001501ce5e9a$15731080$40593180$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5emgnPTMAf8udqS2aQjcADsTLdsA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zA930xSsDDRbutbZYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY2PvQeaCpxwVKz+cYm1gXMDexcjBISFgInHnkmkXIyeQKSZx4d56ti5GLg4hgWWM
	Ei8/3WOGSJhIPH52hxUiMZ1R4tG5XcwQzi9GiW/b/7KAVLEJqEl8+XIYbKqIgL5EW4sGSA2z
	QC+jxJne3ewgNcIC3hK9W+4ygtgsAqoSHzcfAqvnFbCUmHrAGiTMKyAo8WPyPbCRzAJaEut3
	HmeCsOUlNq95C3WQgsSOs6/BxogI6EkcXnoKqkZEYt+Ld4wgeyUETrFLXLvZyQSxS0Di2+RD
	LBAfy0psOgA1R1Li4IobLBMYxWYhWT0LyepZSFbPQrJiASPLKkbR1ILkguKk9CITveLE3OLS
	vHS95PzcTYyQyJuwg/HeAetDjMlA6ycyS4km5wMjN68k3tDYzMjC1MTU2Mjc0ow0YSVxXvUW
	60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjKKzYiS3Cj5ukRGV/3GiZ8fGCKO7D4SjHqYW
	HV/MxfqhR//91PZWngf797i9DLn5Yd0k/RNTfm3oX2hXem19eMfhjJLXLZzur+KOWi32+7tt
	cYHf113/pH7uFDDKXMjPbvk9hil0VjCz2TGFuSvTS6y+X2dabuFsLrGBdeaezbYeTq8/xi0R
	2K/EUpyRaKjFXFScCACaEiTq0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQd30xSsDDbbfNLdYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWNj70HmgqccFSs/nGJtYFzA3sXIySEhYCLx
	+NkdVghbTOLCvfVsXYxcHEIC0xklHp3bxQzh/GKU+Lb9LwtIFZuAmsSXL4eBujk4RAT0Jdpa
	NEBqmAV6GSXO9O4Gmyos4C3Ru+UuI4jNIqAq8XHzIbB6XgFLiakHrEHCvAKCEj8m3wMbySyg
	JbF+53EmCFteYvOat8wQBylI7Dj7GmyMiICexOGlp6BqRCT2vXjHOIFRYBaSUbOQjJqFZNQs
	JC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRH9jOpHYwrGywOMQpwMCrx8BqsWBEo
	xJpYVlyZe4hRgoNZSYR35YKVgUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0w6eSXxhsYm
	ZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAWOczufnv7OO/Pu9ctJY5
	RmLepkcqB6xN3XyWv7ZjWXrhoIOeIaOca+aZk/Wi08QPP1ZS/zH1nRLXnZOR0hO+5wUsdSlI
	eRGYsungYkPLi2ci5i7x2LPwv8WvOxnW7mv+TW7n6L5pcDNFd+I5sRabE9ttvPctn1lk9Puk
	hdNty2v5Hf2VvEfkzyqxFGckGmoxFxUnAgCmK/2XMAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pcf2123.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index b2a78a0..4130e6b 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -94,7 +94,7 @@ static ssize_t pcf2123_show(struct device *dev, struct device_attribute *attr,
 
 	r = container_of(attr, struct pcf2123_sysfs_reg, attr);
 
-	if (strict_strtoul(r->name, 16, &reg))
+	if (kstrtoul(r->name, 16, &reg))
 		return -EINVAL;
 
 	txbuf[0] = PCF2123_READ | reg;
@@ -117,8 +117,7 @@ static ssize_t pcf2123_store(struct device *dev, struct device_attribute *attr,
 
 	r = container_of(attr, struct pcf2123_sysfs_reg, attr);
 
-	if (strict_strtoul(r->name, 16, &reg)
-		|| strict_strtoul(buffer, 10, &val))
+	if (kstrtoul(r->name, 16, &reg) || kstrtoul(buffer, 10, &val))
 		return -EINVAL;
 
 	txbuf[0] = PCF2123_WRITE | reg;
-- 
1.7.10.4


