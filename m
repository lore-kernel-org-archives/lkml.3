Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935574Ab3BOHbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:31:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40810 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935388Ab3BOHbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:31:24 -0500
X-AuditID: cbfee68f-b7f656d000000d78-a9-511de44accde
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
In-reply-to: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
Subject: [PATCH V3 10/11] rtc: rtc-pcf8583: use dev_warn() instead of printk()
Date: Fri, 15 Feb 2013 16:31:22 +0900
Message-id: <003401ce0b4e$74137570$5c3a6050$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LTYY6VzXwCUtKTcq8t8M0FTt2HQAANZ7g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zI12vJ7KBBhuPKltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mlxf+Mxc8Za/o2bGDvYFxCVsXIyeHhICJxPfGQ4wQtpjEhXvr
	geJcHEICyxgldq87ygpTNPnKfqjEdEaJg7OXMEE4s5kkJv3azQJSxSagJvHly2H2LkYODhEB
	fYm2Fg2QGmaBXkaJM7272UFqhARsJab+/gY2lVPATmL1pA6wuLCAn8TVs8/B4iwCqhJLpm4F
	s3mB6jfNn8AGYQtK/Jh8D2wXs4CWxOZtTawQtrzE5jVvmUH2SgioSzz6qwsSFhEwkvj39T0b
	RImIxL4X7xhB7pEQWMYusX19FxPELgGJb5MPsUD0ykpsOsAM8bCkxMEVN1gmMErMQrJ5FpLN
	s5BsnoVkxQJGllWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYIbHVv4Px7gHrQ4zJQOsnMkuJ
	JucDYzOvJN7Q2NjEzMTUxNzS1NyUNGElcV75SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODil
	Ghg9zkhd9M1eseSKx9x7oVtOOXiUvalXLXk71yn/bNLpi1s2Pzmoqak6wV36cKF+10XOStap
	EedObr0xddcE7QZZzddb829MLS99/mmp9pRigaMrNd3r8iZn3tfWmTbli8aZxA8ZX+IvMBxa
	bf58wp7QJV/rRNdv+/1oR5Tn01uPjk5vWFZnzryiTImlOCPRUIu5qDgRAGC2h9LDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoK7XE9lAg5dLFSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxssL/5kLnrJX9OzYwd7A
	uISti5GTQ0LARGLylf1QtpjEhXvrgWwuDiGB6YwSB2cvYYJwZjNJTPq1mwWkik1ATeLLl8Ps
	XYwcHCIC+hJtLRogNcwCvYwSZ3p3s4PUCAnYSkz9/Y0VxOYUsJNYPakDLC4s4Cdx9exzsDiL
	gKrEkqlbwWxeoPpN8yewQdiCEj8m3wPbxSygJbF5WxMrhC0vsXnNW2aQvRIC6hKP/uqChEUE
	jCT+fX3PBlEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQv
	XS85P3cTIzhyn0nvYFzVYHGIUYCDUYmHV0BCNlCINbGsuDL3EKMEB7OSCK/cLaAQb0piZVVq
	UX58UWlOavEhxmSgRycyS4km5wOTSl5JvKGxiZmRpZGZhZGJuTlpwkrivIynngQICaQnlqRm
	p6YWpBbBbGHi4JRqYKwp7U32399gmSlkW6h9QOA0ux2f5m0zscW2jk+W/rk7cV7kisgp8zeH
	JS+wffBXeM2bqs7kU0eWaSZ8a52XdGD6X3cvkan5NhPV/+dcyim7+bkm/abnDebWs+9c5Nd/
	DWHdEq+kydeeuZzl5ab7TuseH3y3YbNZstm51gULM07EGE29UHLH84wSS3FGoqEWc1FxIgDq
	KXbLIAMAAA==
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

Changes since v2:
- Remove redundant prefix

 drivers/rtc/rtc-pcf8583.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8583.c b/drivers/rtc/rtc-pcf8583.c
index 3415b8f..5f97c61 100644
--- a/drivers/rtc/rtc-pcf8583.c
+++ b/drivers/rtc/rtc-pcf8583.c
@@ -185,8 +185,8 @@ static int pcf8583_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	if (ctrl & (CTRL_STOP | CTRL_HOLD)) {
 		unsigned char new_ctrl = ctrl & ~(CTRL_STOP | CTRL_HOLD);
 
-		printk(KERN_WARNING "RTC: resetting control %02x -> %02x\n",
-		       ctrl, new_ctrl);
+		dev_warn(dev, "resetting control %02x -> %02x\n",
+			ctrl, new_ctrl);
 
 		if ((err = pcf8583_set_ctrl(client, &new_ctrl)) < 0)
 			return err;
-- 
1.7.2.5


