Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161252Ab3BOGsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:48:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:53177 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935345Ab3BOGsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:48:22 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-e1-511dda353c75
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
In-reply-to: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
Subject: [PATCH V2 10/11] rtc: rtc-pcf8583: use dev_warn() instead of printk()
Date: Fri, 15 Feb 2013 15:48:20 +0900
Message-id: <002801ce0b48$714d1130$53e73390$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LR47AXgjtu6e1Qmq7gnKtv11nagAANFrQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zQ13TW7KBBhNuKlpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6My6sbWQsmslf8Xz6NpYHxGWsXIyeHhICJxMHDU5khbDGJC/fW
	s3UxcnEICSxjlFjfdxuuqGf3e3YQW0hgOqPEzXUmEPZsJol9B+tBbDYBNYkvXw4D1XBwiAjo
	S7S1aIDMYRboZZQ407sbLC4kYCsx9bYziMkpYCfxfropSKewgJ/Eyi/djCA2i4CqRM8HkBM4
	OXiBqjv3TWCHsAUlfky+xwJiMwtoSWze1sQKYctLbF7zlhlkpISAusSjv7ogYREBI4lZE9+x
	QZSISOx78Y4R5BoJgUXsEi9nz2eC2CUg8W3yIRaIXlmJTQegoSApcXDFDZYJjBKzkGyehWTz
	LCSbZyFZsYCRZRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGSEz17mC8fcD6EGMy0PqJzFKi
	yfnAmMwriTc0NjYxMzE1Mbc0NTclTVhJnFfukkygkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	Bsb5Lv5f+dWTsmZbNt/bf2VjC8Ntw5VTPmprC+vKrz07Y3HMvrS2PAXTfK2i8qri/6aBB3Q/
	914XYey39Tp97sa7pY/PxC35deTFeosvYolnZjxcMC/0hVTLU7GNkybukshcc1lfPWvVQfWC
	SW6qq78cDlTT63MoNd6vayCzc5svK+sLg2NG4TuUWIozEg21mIuKEwF3B0R8vwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoK7JLdlAg8lPLSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxuXVjawFE9kr/i+fxtLA
	+Iy1i5GTQ0LARKJn93t2CFtM4sK99WwgtpDAdEaJm+tMIOzZTBL7DtaD2GwCahJfvhwGqufg
	EBHQl2hr0ehi5OJgFuhllDjTuxssLiRgKzH1tjOIySlgJ/F+uilIp7CAn8TKL92MIDaLgKpE
	zweITbxA1Z37JrBD2IISPybfYwGxmQW0JDZva2KFsOUlNq95ywwyUkJAXeLRX12QsIiAkcSs
	ie/YIEpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn
	525iBEfsM+kdjKsaLA4xCnAwKvHwCkjIBgqxJpYVV+YeYpTgYFYS4V0TAhTiTUmsrEotyo8v
	Ks1JLT7EmAz06ERmKdHkfGAyySuJNzQ2MTOyNDKzMDIxNydNWEmcl/HUkwAhgfTEktTs1NSC
	1CKYLUwcnFINjCucOwOFd/Lo33KxffHu+uddP7rTLia93pLY1PZvp/C27S/ufdNqaNwozL32
	ywJdniyhVw7PN/Ga3E6u9wzZvH+G/KKX567dNxW9fm73i98N7uXfZwrsO7/uxD7bzV+VIk7N
	6loVGyW9O7EwU91aKUQy+m5B3WMxw+j272cN2I9K1jc7rS4NOKzEUpyRaKjFXFScCACwQHjB
	HAMAAA==
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


