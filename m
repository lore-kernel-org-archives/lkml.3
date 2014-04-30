Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbaD3G2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 02:28:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11930 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbaD3G2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 02:28:36 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-be-53609813f4e3
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: open list <linux-kernel@vger.kernel.org>
Cc: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Len Brown'" <len.brown@intel.com>,
        "'Amit Daniel Kachhap'" <amit.daniel@samsung.com>
Subject: [PATCH 1/3] PM / OPP: Add support for descending order for cpufreq
 table
Date: Wed, 30 Apr 2014 15:28:34 +0900
Message-id: <000001cf643d$69e5e350$3db1a9f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9kPT/fF0Xm6P/VQyeHmTHdauapOg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zQ13hGQnBBr8XSlg0XA2xmDVlL5PF
	5V1z2CzOnL7E6sDisXjPSyaPLVfbWTz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr49yfTWwF
	56UqVl17y9rAeE60i5GTQ0LARGLSzH5mCFtM4sK99WxdjFwcQgLLGCXOPOtmgik6fusBVGI6
	UOLtOUYI5x+jxOuHy1lBqtgEdCWOrd8CZosI6EhM39fADmIzC7QySvx8VwpiCwsES2yb2ws2
	lUVAVWL13EVANRwcvAKWEp0zwVp5BQQlfky+xwLRqiWxfudxJghbXmLzmrdQlypI7Dj7mhGk
	VURAT+J5jwVEiYjEvhfvwE6TENjELvH6zWtWiFUCEt8mH2IBqZcQkJXYdABqjKTEwRU3WCYw
	is1CsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxghMda7g/H2AetD
	jMlA6ycyS4km5wNjNK8k3tDYzMjC1MTU2Mjc0ow0YSVx3qSHSUFCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGG3DP/29YbhZ/8E3pUdBd/OsDnYzl907GbpedrHJF5/KJ3VN332OLBD1ztK4
	kFU4x2p7YZbVlmke+ysW+M7Lvqy0l/39QiMB+eWG52W+Os9N5e3U8du7fpOgs0QSf33ZkTqf
	zSkL9jEV6oUWZNRrK93WkAw2uBpz+83+n4b5+ycvvLiv2E9xvRJLcUaioRZzUXEiAGLzNoHH	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQV3hGQnBBtP/Cls0XA2xmDVlL5PF
	5V1z2CzOnL7E6sDisXjPSyaPLVfbWTz6tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePcn01sBeelKlZde8vawHhOtIuRk0NCwETi+K0HbBC2mMSFe+uB
	bC4OIYHpjBJn3p5jhHD+MUq8fricFaSKTUBX4tj6LWC2iICOxPR9DewgNrNAK6PEz3elILaw
	QLDEtrm9TCA2i4CqxOq5i4BqODh4BSwlOmeCtfIKCEr8mHyPBaJVS2L9zuNMELa8xOY1b5kh
	DlKQ2HH2NSNIq4iAnsTzHguIEhGJfS/eMU5gFJiFZNIsJJNmIZk0C0nLAkaWVYyiqQXJBcVJ
	6bmGesWJucWleel6yfm5mxjBEfxMagfjygaLQ4wCHIxKPLwCW+ODhVgTy4orcw8xSnAwK4nw
	ZnQkBAvxpiRWVqUW5ccXleakFh9iTAb6cyKzlGhyPjC55JXEGxqbmBlZGplZGJmYm5MmrCTO
	e6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY2oBW3+4estO40m+it8SL5wIMmzbY1r3c4u5yq0d
	1dtkbPfWGacfiG/WjbIUtSzzOfauVupfQ0Goy9qob5cTPk9ZF9/eK7Ld8/VeXXu293Od3rWu
	TmefObv7srYw+6Ls2z5ZLNMNU0KfmkXKP9M6/1y6OiDlwarZ9/gCU2If8Yh+fLlH9P0MJZbi
	jERDLeai4kQAa5QofiQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the frequency table dts file, the frequencies are arranged in
descending order which maps 1 to 1 with other frequency parameter to
be calculated and programmed in some registers.
But the OPP library works by generating the frequencies in ascending
order which breaks the above logic.
So added OPP_TABLE_ORDER_DESCEND flag to consider descending order.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/base/power/opp.c |   17 ++++++++++++++++-
 include/linux/pm_opp.h   |    7 +++++--
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 2553867..ec7d553 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -18,6 +18,7 @@
 #include <linux/cpufreq.h>
 #include <linux/device.h>
 #include <linux/list.h>
+#include <linux/list_sort.h>
 #include <linux/rculist.h>
 #include <linux/rcupdate.h>
 #include <linux/pm_opp.h>
@@ -597,10 +598,21 @@ int dev_pm_opp_disable(struct device *dev, unsigned
long freq)
 EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
 
 #ifdef CONFIG_CPU_FREQ
+
+static int opp_descend_cmp(void *priv, struct list_head *a,
+                                        struct list_head *b)
+{
+        struct dev_pm_opp *ra = list_entry(a, struct dev_pm_opp, node);
+        struct dev_pm_opp *rb = list_entry(b, struct dev_pm_opp, node);
+
+        return rb->rate - ra->rate;
+}
+
 /**
  * dev_pm_opp_init_cpufreq_table() - create a cpufreq table for a device
  * @dev:	device for which we do this operation
  * @table:	Cpufreq table returned back to caller
+ * @flags:	OPP_TABLE_ORDER_DESCEND or zero
  *
  * Generate a cpufreq table for a provided device- this assumes that the
  * opp list is already initialized and ready for usage.
@@ -622,7 +634,7 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
  * or in contexts where mutex locking cannot be used.
  */
 int dev_pm_opp_init_cpufreq_table(struct device *dev,
-			    struct cpufreq_frequency_table **table)
+		struct cpufreq_frequency_table **table, unsigned char flags)
 {
 	struct device_opp *dev_opp;
 	struct dev_pm_opp *opp;
@@ -649,6 +661,9 @@ int dev_pm_opp_init_cpufreq_table(struct device *dev,
 		return -ENOMEM;
 	}
 
+	if (flags & OPP_TABLE_ORDER_DESCEND)
+		list_sort(NULL, &dev_opp->opp_list, opp_descend_cmp);
+
 	list_for_each_entry(opp, &dev_opp->opp_list, node) {
 		if (opp->available) {
 			freq_table[i].driver_data = i;
diff --git a/include/linux/pm_opp.h b/include/linux/pm_opp.h
index 5151b00..cf42770 100644
--- a/include/linux/pm_opp.h
+++ b/include/linux/pm_opp.h
@@ -118,13 +118,16 @@ static inline int of_init_opp_table(struct device
*dev)
 #endif
 
 #if defined(CONFIG_CPU_FREQ) && defined(CONFIG_PM_OPP)
+
+#define OPP_TABLE_ORDER_DESCEND                (1 << 1)
+
 int dev_pm_opp_init_cpufreq_table(struct device *dev,
-			    struct cpufreq_frequency_table **table);
+		struct cpufreq_frequency_table **table, unsigned char
flags);
 void dev_pm_opp_free_cpufreq_table(struct device *dev,
 				struct cpufreq_frequency_table **table);
 #else
 static inline int dev_pm_opp_init_cpufreq_table(struct device *dev,
-			    struct cpufreq_frequency_table **table)
+		struct cpufreq_frequency_table **table, unsigned char flags)
 {
 	return -EINVAL;
 }
-- 
1.7.10.4

