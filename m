Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaLQUPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 15:15:05 -0500
Received: from sender1.zohomail.com ([74.201.84.156]:37353 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaLQUPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 15:15:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=from:to:cc:subject:date:message-id; 
  b=o5AL2Gc2c0y5CkqBrEmhXgK3HjnIiBs/QphUIJosdDNDJV/Yd0o6YQTyhLa4gygEGgzlrJH5+MDa
    eljqLfnbSsrbvK4pflK6rE0KqMmcAQUpsDXBpHlZIG03xrXTWSLP  
From: Rastislav Barlik <barlik@zoho.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Rastislav Barlik <barlik@zoho.com>
Subject: [PATCH] samples/kobject: Use kstrtoint instead of sscanf
Date: Wed, 17 Dec 2014 21:14:48 +0100
Message-Id: <1418847288-25578-1-git-send-email-barlik@zoho.com>
X-Mailer: git-send-email 2.1.3
X-ZohoMail: Ss  SS_10 UW UB UW UB  ZSF-HLOLL_2 SF_TD_EXT  SGR3_1_09124_40
X-ZohoMail-Owner: <1418847288-25578-1-git-send-email-barlik@zoho.com>+zmo_0_<barlik@zoho.com>
X-ZohoMail-Sender: 85.163.170.178
X-Zoho-Virus-Status: 2
X-ZohoMailClient: External
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kstrtoint function instead of sscanf and check for return values.

Signed-off-by: Rastislav Barlik <barlik@zoho.com>
---
 samples/kobject/kobject-example.c | 14 +++++++++++---
 samples/kobject/kset-example.c    | 14 +++++++++++---
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/samples/kobject/kobject-example.c b/samples/kobject/kobject-example.c
index 01562e0..063aaec 100644
--- a/samples/kobject/kobject-example.c
+++ b/samples/kobject/kobject-example.c
@@ -36,7 +36,12 @@ static ssize_t foo_show(struct kobject *kobj, struct kobj_attribute *attr,
 static ssize_t foo_store(struct kobject *kobj, struct kobj_attribute *attr,
 			 const char *buf, size_t count)
 {
-	sscanf(buf, "%du", &foo);
+	int ret;
+
+	ret = kstrtoint(buf, 10, &foo);
+	if (ret < 0)
+		return ret;
+
 	return count;
 }
 
@@ -63,9 +68,12 @@ static ssize_t b_show(struct kobject *kobj, struct kobj_attribute *attr,
 static ssize_t b_store(struct kobject *kobj, struct kobj_attribute *attr,
 		       const char *buf, size_t count)
 {
-	int var;
+	int var, ret;
+
+	ret = kstrtoint(buf, 10, &var);
+	if (ret < 0)
+		return ret;
 
-	sscanf(buf, "%du", &var);
 	if (strcmp(attr->attr.name, "baz") == 0)
 		baz = var;
 	else
diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
index ab5e447..e80ced3 100644
--- a/samples/kobject/kset-example.c
+++ b/samples/kobject/kset-example.c
@@ -120,7 +120,12 @@ static ssize_t foo_show(struct foo_obj *foo_obj, struct foo_attribute *attr,
 static ssize_t foo_store(struct foo_obj *foo_obj, struct foo_attribute *attr,
 			 const char *buf, size_t count)
 {
-	sscanf(buf, "%du", &foo_obj->foo);
+	int ret;
+
+	ret = kstrtoint(buf, 10, &foo_obj->foo);
+	if (ret < 0)
+		return ret;
+
 	return count;
 }
 
@@ -147,9 +152,12 @@ static ssize_t b_show(struct foo_obj *foo_obj, struct foo_attribute *attr,
 static ssize_t b_store(struct foo_obj *foo_obj, struct foo_attribute *attr,
 		       const char *buf, size_t count)
 {
-	int var;
+	int var, ret;
+
+	ret = kstrtoint(buf, 10, &var);
+	if (ret < 0)
+		return ret;
 
-	sscanf(buf, "%du", &var);
 	if (strcmp(attr->attr.name, "baz") == 0)
 		foo_obj->baz = var;
 	else
-- 
2.1.3


