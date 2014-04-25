Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaDYJL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 05:11:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48805 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaDYJIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 05:08:21 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-7b-535a2602080f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, cw00.choi@samsung.com,
        jkosina@suse.cz, labbe.montjoie@gmail.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] devfreq: Add
 devm_devfreq_{register,unregister}_opp_notfier function
Date: Fri, 25 Apr 2014 18:08:12 +0900
Message-id: <1398416894-6782-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1398416894-6782-1-git-send-email-cw00.choi@samsung.com>
References: <1398416894-6782-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42JZI2JSrMukFhVscHSPqMX1L89ZLXbPWcxi
	cbbpDbvF+gUL2Swu75rDZvG59wijxe3GFWwWb36cZbJ4vOItuwOnx85Zd9k9Fu95yeTRt2UV
	o8eZBUfYPY7f2M7k8XmTXABbFJdNSmpOZllqkb5dAlfGnM332QtWSVVMenaTvYGxW6yLkZND
	QsBE4vnr00wQtpjEhXvr2boYuTiEBJYySuybfosZpqhvxxKoxCJGiV8T2tkhnCYmiXlb9rGD
	VLEJaEnsf3GDDcQWETCX2LX0J5jNLLCcUWLr3DAQW1ggWuLf0ceMIDaLgKrEz3WzWUFsXgEX
	iabHP9khtslJfNjzCMzmFHCVaP/5FqxGCKim8fErsMUSAuvYJfYv+sIEMUhA4tvkQyxdjBxA
	CVmJTQegrpaUOLjiBssERuEFjAyrGEVTC5ILipPSi4z0ihNzi0vz0vWS83M3MQLj4PS/Z307
	GG8esD7EmAw0biKzlGhyPjCO8kriDY3NjCxMTUyNjcwtzUgTVhLnXfQwKUhIID2xJDU7NbUg
	tSi+qDQntfgQIxMHp1QD4zLHluAn305+Omu30fTe/szA/KA7oaGvTd1i93METNlhdmTaxsmx
	LZOTLdgLlOrclTZ5rAv7ffBom8qpJ8WXaq+zbZ53+MX5M6UmAjwNyRt69AMW190vKDzbKfyI
	LeLp8X2JlX1bjur5ZPxZvsb76HLvxR0VT7Lv8dSuMbFSnVtuvUPR20p/rhJLcUaioRZzUXEi
	AIjjO2+ZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMIsWRmVeSWpSXmKPExsVy+t9jAV0mtahggy9reC2uf3nOarF7zmIW
	i7NNb9gt1i9YyGZxedccNovPvUcYLW43rmCzePPjLJPF4xVv2R04PXbOusvusXjPSyaPvi2r
	GD3OLDjC7nH8xnYmj8+b5ALYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyV
	FPISc1NtlVx8AnTdMnOAzlJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYw
	ZszZfJ+9YJVUxaRnN9kbGLvFuhg5OSQETCT6dixhg7DFJC7cWw9kc3EICSxilPg1oZ0dwmli
	kpi3ZR87SBWbgJbE/hc3wDpEBMwldi39CWYzCyxnlNg6NwzEFhaIlvh39DEjiM0ioCrxc91s
	VhCbV8BFounxT3aIbXISH/Y8ArM5BVwl2n++BasRAqppfPyKfQIj7wJGhlWMoqkFyQXFSem5
	RnrFibnFpXnpesn5uZsYwVH2THoH46oGi0OMAhyMSjy8E2Qjg4VYE8uKK3MPMUpwMCuJ8M6Q
	iAoW4k1JrKxKLcqPLyrNSS0+xJgMdNVEZinR5HxgAsgriTc0NjEzsjQyN7QwMjYnTVhJnPdg
	q3WgkEB6YklqdmpqQWoRzBYmDk6pBsb8FUYRmalPDBn0e7OUnGZofm7QyZzO7H7+2uX1LuH/
	Nxubr0le8YL90bP/8gWCUlOOBwk/P/NFvfyfCPeKw1pK3740KbVZe1RFM/Gbie2O/77LTsvJ
	4Uvr3sPn/rPnrhUUSTQVDry/t2TmK9aNk+KV69cun80QI5/iJac+b4lmp8QmqV/mqUosxRmJ
	hlrMRcWJAPRLjAv2AgAA
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
index 0b80b60..3439406 100644
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
index 45c29db..90f95a3 100644
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

