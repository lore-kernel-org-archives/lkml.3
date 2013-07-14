Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab3GNXGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 19:06:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab3GNXGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 19:06:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: abbotti@mev.co.uk, oliver@schinagl.nl, linux@roeck-us.net,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 01/10] sysfs.h: add __ATTR_RW() macro
Date: Sun, 14 Jul 2013 16:05:51 -0700
Message-Id: <1373843160-3990-2-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
References: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of parts of the kernel created their own version of this, might
as well have the sysfs core provide it instead.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sysfs.h | 2 ++
 kernel/events/core.c  | 2 --
 mm/backing-dev.c      | 2 --
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index e2cee22f..9cd20c84 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -79,6 +79,8 @@ struct attribute_group {
 	.show	= _name##_show,					\
 }
 
+#define __ATTR_RW(_name) __ATTR(_name, 0644, _name##_show, _name##_store)
+
 #define __ATTR_NULL { .attr = { .name = NULL } }
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
diff --git a/kernel/events/core.c b/kernel/events/core.c
index eba8fb58..dd987802 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6234,8 +6234,6 @@ perf_event_mux_interval_ms_store(struct device *dev,
 	return count;
 }
 
-#define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
-
 static struct device_attribute pmu_dev_attrs[] = {
 	__ATTR_RO(type),
 	__ATTR_RW(perf_event_mux_interval_ms),
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d014ee5f..e04454cd 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -232,8 +232,6 @@ static ssize_t stable_pages_required_show(struct device *dev,
 			bdi_cap_stable_pages_required(bdi) ? 1 : 0);
 }
 
-#define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
-
 static struct device_attribute bdi_dev_attrs[] = {
 	__ATTR_RW(read_ahead_kb),
 	__ATTR_RW(min_ratio),
-- 
1.8.3.rc0.20.gb99dd2e

