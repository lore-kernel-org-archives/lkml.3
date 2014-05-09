Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaEIHnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:43:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9838 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaEIHnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:43:18 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-83-536c8714ef05
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, jkosina@suse.cz,
        labbe.montjoie@gmail.com, a.kesavan@samsung.com,
        sreekumar.c@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv2 3/5] devfreq: Add
 devm_devfreq_{register,unregister}_opp_notfier function
Date: Fri, 09 May 2014 16:43:09 +0900
Message-id: <1399621391-27228-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1399621391-27228-1-git-send-email-cw00.choi@samsung.com>
References: <1399621391-27228-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWyRsSkSFekPSfY4MNcdovHaxYzWVz/8pzV
	YvecxSwWZ5vesFusX7CQzeLyrjlsFp97jzBa3G5cwWbx5sdZJovHK96yWxx8uIDZgdtj56y7
	7B6L97xk8ujbsorR48yCI+wex29sZ/L4vEkugC2KyyYlNSezLLVI3y6BK2PK70bGgtVSFS9f
	L2NsYOwR62Lk5JAQMJHYdOM1K4QtJnHh3nq2LkYuDiGBpYwS066fYIYpWt/4ESqxiFFi1edt
	jBBOE5PE6hXfmECq2AS0JPa/uMEGYosImEvsWvoTrINZ4AWjRMfGTWCjhAViJR48W8cOYrMI
	qErce3oAzOYVcJXYcfcE1B1yEh/2PAKLcwq4SaxvmwDWKwRUM3lZF9hQCYFD7BLbDs5ihBgk
	IPFt8iGWLkYOoISsxKYDUGdLShxccYNlAqPwAkaGVYyiqQXJBcVJ6UVGesWJucWleel6yfm5
	mxiB0XH637O+HYw3D1gfYkwGGjeRWUo0OR8YXXkl8YbGZkYWpiamxkbmlmakCSuJ8y56mBQk
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1MKGAdKDPW6d+epr3h7YPVWP65pe59+3XVQ8VpBqbLy
	uhWaB830Jjj9n2QU+Cx6ptLGLdFa075kFalvN62+cvAh479p2VW8X/SbPux+xPrK9INKir6J
	pQX/yw0/107IYN/x6viy3Rq7c07N65Vl8LPtTPBeceFGn9gzZ+anDKd9r+X0hr8Wzl5Y0qjE
	UpyRaKjFXFScCAA+u6zNpAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t9jAV3h9pxgg9ObrC0er1nMZHH9y3NW
	i91zFrNYnG16w26xfsFCNovLu+awWXzuPcJocbtxBZvFmx9nmSwer3jLbnHw4QJmB26PnbPu
	snss3vOSyaNvyypGjzMLjrB7HL+xncnj8ya5ALaoBkabjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKADlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6
	hgTB9RgZoIGENYwZU343Mhaslqp4+XoZYwNjj1gXIyeHhICJxPrGj2wQtpjEhXvrgWwuDiGB
	RYwSqz5vY4RwmpgkVq/4xgRSxSagJbH/xQ2wDhEBc4ldS3+CdTALvGCU6Ni4iRkkISwQK/Hg
	2Tp2EJtFQFXi3tMDYDavgKvEjrsnWCHWyUl82PMILM4p4Caxvm0CWK8QUM3kZV1sExh5FzAy
	rGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjr1n0jsYVzVYHGIU4GBU4uF9MSU7WIg1say4
	MvcQowQHs5IIr1R6TrAQb0piZVVqUX58UWlOavEhxmSgqyYyS4km5wPTQl5JvKGxiZmRpZG5
	oYWRsTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MCpIL5nMsOWoRPHexPXrF/Cx/Jiv
	15LxhW9anfDssrzvN46FNvCm7NlUmWNZ/UDAuGnexCl/3z3nLq2wkLI5evmO3JO7bmk/pX6a
	mi+PtVA9MVtbpuRCis3khtS/IQ9nfrS+9Uy/rWFG3K7GcJ2mbtZTzcwvin6wL9r86Ehidy7v
	5Rl/zrtuO6HEUpyRaKjFXFScCAAXBZ/DAQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add resource-managed function for devfreq opp as following
functions. The devm_devfreq_register_opp_notifier() manages automatically
the registration of devfreq opp using device resource management.
- devm_devfreq_register_opp_notifier
- devm_devfreq_unregister_opp_notifier()

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/devfreq/devfreq.c | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/devfreq.h   | 14 ++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 40fe650..6f5374cf 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1293,6 +1293,54 @@ int devfreq_unregister_opp_notifier(struct device *dev, struct devfreq *devfreq)
 	return ret;
 }
 
+static void devm_devfreq_opp_release(struct device *dev, void *res)
+{
+	devfreq_unregister_opp_notifier(dev, *(struct devfreq **)res);
+}
+
+/**
+ * devm_ devfreq_register_opp_notifier()
+ *		- Resource-managed devfreq_register_opp_notifier()
+ * @dev:	The devfreq user device. (parent of devfreq)
+ * @devfreq:	The devfreq object.
+ */
+int devm_devfreq_register_opp_notifier(struct device *dev,
+				       struct devfreq *devfreq)
+{
+	struct devfreq **ptr;
+	int ret;
+
+	ptr = devres_alloc(devm_devfreq_opp_release, sizeof(*ptr), GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	ret = devfreq_register_opp_notifier(dev, devfreq);
+	if (ret) {
+		devres_free(ptr);
+		return ret;
+	}
+
+	*ptr = devfreq;
+	devres_add(dev, ptr);
+
+	return 0;
+}
+EXPORT_SYMBOL(devm_devfreq_register_opp_notifier);
+
+/**
+ * devm_devfreq_unregister_opp_notifier()
+ *		- Resource-managed devfreq_unregister_opp_notifier()
+ * @dev:	The devfreq user device. (parent of devfreq)
+ * @devfreq:	The devfreq object.
+ */
+void devm_devfreq_unregister_opp_notifier(struct device *dev,
+					 struct devfreq *devfreq)
+{
+	WARN_ON(devres_release(dev, devm_devfreq_opp_release,
+			       devm_devfreq_dev_match, devfreq));
+}
+EXPORT_SYMBOL(devm_devfreq_unregister_opp_notifier);
+
 MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
 MODULE_DESCRIPTION("devfreq class support");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 3a5fbc3..cf808d0 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -241,6 +241,10 @@ extern int devfreq_register_opp_notifier(struct device *dev,
 					 struct devfreq *devfreq);
 extern int devfreq_unregister_opp_notifier(struct device *dev,
 					   struct devfreq *devfreq);
+extern int devm_devfreq_register_opp_notifier(struct device *dev,
+					      struct devfreq *devfreq);
+extern void devm_devfreq_unregister_opp_notifier(struct device *dev,
+						struct devfreq *devfreq);
 
 #if IS_ENABLED(CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND)
 /**
@@ -317,6 +321,16 @@ static inline int devfreq_unregister_opp_notifier(struct device *dev,
 	return -EINVAL;
 }
 
+static inline int devm_devfreq_register_opp_notifier(struct device *dev,
+						     struct devfreq *devfreq)
+{
+	return -EINVAL;
+}
+
+static inline void devm_devfreq_unregister_opp_notifier(struct device *dev,
+							struct devfreq *devfreq)
+{
+}
 #endif /* CONFIG_PM_DEVFREQ */
 
 #endif /* __LINUX_DEVFREQ_H__ */
-- 
1.8.0

