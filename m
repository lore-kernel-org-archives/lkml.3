Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489AbaLPIvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:51:48 -0500
Received: from sender1.zohomail.com ([72.5.230.103]:39761 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaLPIvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:51:47 -0500
X-Greylist: delayed 1099 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Dec 2014 03:51:47 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=from:to:cc:subject:date:message-id; 
  b=NIniHNGjYixqvD6EakWWniQ/0CGl1OXT8NSsdQbvvh/n5q/Ne6qePJsQEt9JtdAR7K3KnCoQO0qu
    F4ng5cLqd6UQpA4BAhRb4Mx7LEYD31LE5bu3Ct5UD2KMTuHTb3LI  
From: Rastislav Barlik <barlik@zoho.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Rastislav Barlik <barlik@zoho.com>
Subject: [PATCH] samples/kobject: Use kstrtoint instead of sscanf
Date: Tue, 16 Dec 2014 09:31:08 +0100
Message-Id: <1418718668-3646-1-git-send-email-barlik@zoho.com>
X-Mailer: git-send-email 2.1.3
X-ZohoMail: Ss  SS_10 UW UB UW UB  ZSF-HLOLL_2 SF_TD_EXT  SGR3_1_09124_39
X-ZohoMail-Owner: <1418718668-3646-1-git-send-email-barlik@zoho.com>+zmo_0_<barlik@zoho.com>
X-ZohoMail-Sender: 85.163.199.236
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


