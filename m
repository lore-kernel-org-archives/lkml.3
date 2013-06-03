Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3FCJHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:07:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9309 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3FCJHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:07:36 -0400
X-AuditID: cbfee68f-b7f436d000000f81-08-51ac5cd7dcc9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: [PATCH V2] rtc: rtc-pcf2123: replace strict_strtoul() with kstrtoul()
Date: Mon, 03 Jun 2013 18:07:34 +0900
Message-id: <001501ce6039$c967d2b0$5c377810$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5gObucgJ9xrMeySw+7UAGuGdIkZQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zY93rMWsCDZrO81osuXiV3WLO+jVs
	Fi8nHGa0uLzwEqvF5V1z2Cz2d3YwOrB57Jx1l91jz8STbB4nZvxm8ejbsorRY/q8n0wenzfJ
	BbBFcdmkpOZklqUW6dslcGVc+NnFVrCaq+L7krNMDYw7OLoYOTkkBEwktj9fyghhi0lcuLee
	rYuRi0NIYBmjxPeTe5lgiu5MPcoOkZjOKLF0yUkmCOcXo0TTjWtsIFVsAmoSX74cBqri4BAR
	0Jdoa9EAqWEW2Mcoce7Ud7AVwgJ+Eue3NLKA1LAIqEqsn5wHEuYVsJTYevokK4QtKPFj8j0W
	EJtZQEti/c7jTBC2vMTmNW+ZIQ5SkNhx9jXYSBEBPYnf8xYxQ9SISOx78Y4RZK+EwDV2ia2/
	l4MNZREQkPg2+RDYXgkBWYlNB6DmSEocXHGDZQKj2Cwkq2chWT0LyepZSFYsYGRZxSiaWpBc
	UJyUXmSsV5yYW1yal66XnJ+7iRESj/07GO8esD7EmAy0fiKzlGhyPjCe80riDY3NjCxMTUyN
	jcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAKF1Ve1rh9fSFibXHys8V
	fJh56GvWgqAD/40adB8/EeJpObSqtab+RO9bjqgHfEccdgRn3pjCHctj9sPRLTLyL9fvqZIf
	Mg/ZN5vEdy7JSKkOyPtrLBhod5DhhxXT1XnpSzT4c1Z1JMx/698vOvXjcknPfVONjUNnnpPw
	6F7ydMmG6Sd1n81sUmIpzkg01GIuKk4EABa4XzbdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd3rMWsCDW5u5bRYcvEqu8Wc9WvY
	LF5OOMxocXnhJVaLy7vmsFns7+xgdGDz2DnrLrvHnokn2TxOzPjN4tG3ZRWjx/R5P5k8Pm+S
	C2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYceFnF1vBaq6K70vOMjUw
	7uDoYuTkkBAwkbgz9Sg7hC0mceHeerYuRi4OIYHpjBJLl5xkgnB+MUo03bjGBlLFJqAm8eXL
	YaAODg4RAX2JthYNkBpmgX2MEudOfWcEqREW8JM4v6WRBaSGRUBVYv3kPJAwr4ClxNbTJ1kh
	bEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywxxkILEjrOvwUaKCOhJ/J63iBmiRkRi34t3jBMY
	BWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwtD+T2sG4ssHi
	EKMAB6MSD2+Ax5pAIdbEsuLK3EOMEhzMSiK8VwKBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwl
	mpwPTER5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cBY08cs
	uvuZ3Nd/LJdf93gHbXh23j377Me5Gyoezdb66FKo+Pij4sK+mQrvORNjGTkXNHlcZ/+w5sIJ
	S2HWiwd5X23Z4rTqTVrgh9s9osZvZzyfuvHFSfGdziynLMvSXKP7UiWqO7vmfPw8saF341Tv
	4wKZLj8+iNf3pVW67nhs7fUrL+Wfioi5EktxRqKhFnNRcSIAa6BM6DoDAAA=
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
Changes since v1:
- Used return code from kstrtoul().

 drivers/rtc/rtc-pcf2123.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-pcf2123.c b/drivers/rtc/rtc-pcf2123.c
index b2a78a0..a887d95 100644
--- a/drivers/rtc/rtc-pcf2123.c
+++ b/drivers/rtc/rtc-pcf2123.c
@@ -94,8 +94,9 @@ static ssize_t pcf2123_show(struct device *dev, struct device_attribute *attr,
 
 	r = container_of(attr, struct pcf2123_sysfs_reg, attr);
 
-	if (strict_strtoul(r->name, 16, &reg))
-		return -EINVAL;
+	ret = kstrtoul(r->name, 16, &reg);
+	if (ret)
+		return ret;
 
 	txbuf[0] = PCF2123_READ | reg;
 	ret = spi_write_then_read(spi, txbuf, 1, rxbuf, 1);
@@ -117,9 +118,9 @@ static ssize_t pcf2123_store(struct device *dev, struct device_attribute *attr,
 
 	r = container_of(attr, struct pcf2123_sysfs_reg, attr);
 
-	if (strict_strtoul(r->name, 16, &reg)
-		|| strict_strtoul(buffer, 10, &val))
-		return -EINVAL;
+	ret = kstrtoul(r->name, 16, &reg) || kstrtoul(buffer, 10, &val);
+	if (ret)
+		return ret;
 
 	txbuf[0] = PCF2123_WRITE | reg;
 	txbuf[1] = val;
-- 
1.7.10.4


