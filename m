Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3CFGzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:55:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45898 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3CFGzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:55:22 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-29-5136e8524851
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Tejun Heo'" <tj@kernel.org>,
        "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] rtc: use struct device as the first argument for
 devm_rtc_device_register()
Date: Wed, 06 Mar 2013 15:55:14 +0900
Message-id: <006801ce1a37$8dc53c40$a94fb4c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aN42hprLPcPknRSODTaRjTo9ZBA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t8zQ92gF2aBBpu3altc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MFXN/sxZ08FccOXWVsYFxKk8XIyeHhICJxJmrT5kgbDGJC/fW
	s3UxcnEICSxjlGg50sMMU3R11RVWiMQiRonmmSdZIJzZTBITZz5mA6liE1CT+PLlMHsXIweH
	iIC+RFuLBkgNs8AaRokVjSdYQGqEBeIkPnx8wAJSwyKgKnGoyRwkzCtgK/Fp5ltGCFtQ4sfk
	e2DlzAJaEut3HmeCsOUlNq95ywzSKiGgLvHory5IWERAT2LB8wPsECUiEvtevGMEWSsh0M8u
	sfL/ebBeFgEBiW+TD7FA9MpKbDoA9ZekxMEVN1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWMoqkF
	yQXFSelFxnrFibnFpXnpesn5uZsYIZHSv4Px7gHrQ4zJQOsnMkuJJucDIy2vJN7Q2NjEzMTU
	xNzS1NyUNGElcV75SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhd1TxFXsWf1L9R46l2
	W2Xqy+LzX+VmFv3csOGEfEd6vfD+XZYJogqMC5WlUjYZHfcvn1bz2/f7wQmRzytep/+t1amu
	2MDndePlulOnhOq8NHrte5vffDc988914e34vbsP/+rzt5y/qau/JKL017eOgP58x2POosXL
	zB6uTv3B/cdZgid/v4MSS3FGoqEWc1FxIgCOtceoqgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd2gF2aBBhP+KVtc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjBVzf7MWdPBXHDl1lbGB
	cSpPFyMnh4SAicTVVVdYIWwxiQv31rN1MXJxCAksYpRonnmSBcKZzSQxceZjNpAqNgE1iS9f
	DrN3MXJwiAjoS7S1aIDUMAusYZRY0XiCBaRGWCBO4sPHBywgNSwCqhKHmsxBwrwCthKfZr5l
	hLAFJX5MvgdWziygJbF+53EmCFteYvOat8wgrRIC6hKP/uqChEUE9CQWPD/ADlEiIrHvxTvG
	CYwCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgOn0ntYFzZ
	YHGIUYCDUYmH10LJLFCINbGsuDL3EKMEB7OSCC/XGaAQb0piZVVqUX58UWlOavEhxmSgPycy
	S4km5wNTRF5JvKGxiZmRpZGZhZGJuTlpwkrivIynngQICaQnlqRmp6YWpBbBbGHi4JRqYJRN
	XZpiIuTzxd31iFb/SSOJaHOxF79quMRX1auvml/UEDhfuaj+xmrJnycvz/l+sdG7+sG8pVv/
	Xll2KMngW97v5zMPSZwoP/VgosHh8gBXSc+JTkW6/z6t9nixfHJF1OfPn+aH3t64+/i+zb2+
	S68nb3X0WL7pS/eEgx8cOtYHcM3QbHst8f+tEktxRqKhFnNRcSIAaKxR5QcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other devm_* APIs use 'struct evice *dev' as the first argument.
Thus, in order to sync with other devm_* functions, struct device
is used as the first argument for devm_rtc_device_register().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/class.c |    6 +++---
 include/linux/rtc.h |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index b72b40b..6638540 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -275,8 +275,8 @@ static int devm_rtc_device_match(struct device *dev, void *res, void *data)
 
 /**
  * devm_rtc_device_register - resource managed rtc_device_register()
- * @name: the name of the device
  * @dev: the device to register
+ * @name: the name of the device
  * @ops: the rtc operations structure
  * @owner: the module owner
  *
@@ -287,8 +287,8 @@ static int devm_rtc_device_match(struct device *dev, void *res, void *data)
  * for more information.
  */
 
-struct rtc_device *devm_rtc_device_register(const char *name,
-					struct device *dev,
+struct rtc_device *devm_rtc_device_register(struct device *dev,
+					const char *name,
 					const struct rtc_class_ops *ops,
 					struct module *owner)
 {
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index d955768..c2c2897 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -133,8 +133,8 @@ extern struct rtc_device *rtc_device_register(const char *name,
 					struct device *dev,
 					const struct rtc_class_ops *ops,
 					struct module *owner);
-extern struct rtc_device *devm_rtc_device_register(const char *name,
-					struct device *dev,
+extern struct rtc_device *devm_rtc_device_register(struct device *dev,
+					const char *name,
 					const struct rtc_class_ops *ops,
 					struct module *owner);
 extern void rtc_device_unregister(struct rtc_device *rtc);
-- 
1.7.2.5


