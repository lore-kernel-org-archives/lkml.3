Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbaDVD7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:59:39 -0400
Received: from ozlabs.org ([103.22.144.67]:47716 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbaDVD7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:59:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Simon Wood <simon@mungewell.org>
Subject: [PATCH 3/9] drivers/hid/hid-lg4ff.c: avoid world-writable sysfs files.
Date: Tue, 22 Apr 2014 13:03:26 +0930
Message-Id: <1398137612-9714-4-git-send-email-rusty@rustcorp.com.au>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
References: <1398137612-9714-1-git-send-email-rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In line with practice for module parameters, we're adding a build-time
check that sysfs files aren't world-writable.

Cc: Simon Wood <simon@mungewell.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/hid/hid-lg4ff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-lg4ff.c b/drivers/hid/hid-lg4ff.c
index 24883b4d1a49..cc2bd2022198 100644
--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -52,7 +52,7 @@ static void hid_lg4ff_set_range_g25(struct hid_device *hid, u16 range);
 static ssize_t lg4ff_range_show(struct device *dev, struct device_attribute *attr, char *buf);
 static ssize_t lg4ff_range_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t count);
 
-static DEVICE_ATTR(range, S_IRWXU | S_IRWXG | S_IRWXO, lg4ff_range_show, lg4ff_range_store);
+static DEVICE_ATTR(range, S_IRWXU | S_IRWXG | S_IROTH, lg4ff_range_show, lg4ff_range_store);
 
 struct lg4ff_device_entry {
 	__u32 product_id;
-- 
1.8.3.2

