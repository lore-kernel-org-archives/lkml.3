Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaDVEAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 00:00:07 -0400
Received: from ozlabs.org ([103.22.144.67]:54913 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbaDVD7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:59:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Greg Kroah-Hartman <greg@kroah.com>
Subject: [PATCH 8/9] samples/kobject/: avoid world-writable sysfs files.
Date: Tue, 22 Apr 2014 13:03:31 +0930
Message-Id: <1398137612-9714-9-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In line with practice for module parameters, we're adding a build-time
check that sysfs files aren't world-writable.

Cc: Greg Kroah-Hartman <greg@kroah.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 samples/kobject/kobject-example.c | 7 ++++---
 samples/kobject/kset-example.c    | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/samples/kobject/kobject-example.c b/samples/kobject/kobject-example.c
index 86ea0c3ad975..01562e0d4992 100644
--- a/samples/kobject/kobject-example.c
+++ b/samples/kobject/kobject-example.c
@@ -40,8 +40,9 @@ static ssize_t foo_store(struct kobject *kobj, struct kobj_attribute *attr,
 	return count;
 }
 
+/* Sysfs attributes cannot be world-writable. */
 static struct kobj_attribute foo_attribute =
-	__ATTR(foo, 0666, foo_show, foo_store);
+	__ATTR(foo, 0664, foo_show, foo_store);
 
 /*
  * More complex function where we determine which variable is being accessed by
@@ -73,9 +74,9 @@ static ssize_t b_store(struct kobject *kobj, struct kobj_attribute *attr,
 }
 
 static struct kobj_attribute baz_attribute =
-	__ATTR(baz, 0666, b_show, b_store);
+	__ATTR(baz, 0664, b_show, b_store);
 static struct kobj_attribute bar_attribute =
-	__ATTR(bar, 0666, b_show, b_store);
+	__ATTR(bar, 0664, b_show, b_store);
 
 
 /*
diff --git a/samples/kobject/kset-example.c b/samples/kobject/kset-example.c
index 5dce351f131f..ab5e447ec238 100644
--- a/samples/kobject/kset-example.c
+++ b/samples/kobject/kset-example.c
@@ -124,8 +124,9 @@ static ssize_t foo_store(struct foo_obj *foo_obj, struct foo_attribute *attr,
 	return count;
 }
 
+/* Sysfs attributes cannot be world-writable. */
 static struct foo_attribute foo_attribute =
-	__ATTR(foo, 0666, foo_show, foo_store);
+	__ATTR(foo, 0664, foo_show, foo_store);
 
 /*
  * More complex function where we determine which variable is being accessed by
@@ -157,9 +158,9 @@ static ssize_t b_store(struct foo_obj *foo_obj, struct foo_attribute *attr,
 }
 
 static struct foo_attribute baz_attribute =
-	__ATTR(baz, 0666, b_show, b_store);
+	__ATTR(baz, 0664, b_show, b_store);
 static struct foo_attribute bar_attribute =
-	__ATTR(bar, 0666, b_show, b_store);
+	__ATTR(bar, 0664, b_show, b_store);
 
 /*
  * Create a group of attributes so that we can create and destroy them all
-- 
1.8.3.2

