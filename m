Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3JHCQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 22:16:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35977 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab3JHCQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 22:16:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Dubov <oakad@yahoo.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/8] tifm: convert bus code to use dev_groups
Date: Mon,  7 Oct 2013 18:27:40 -0700
Message-Id: <1381195662-28009-7-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
References: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the tifm bus code to use the
correct field.

Cc: Alex Dubov <oakad@yahoo.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Alex, I can take this through my driver-core tree if you don't want to
take it through yours, just let me know what works best for you.

 drivers/misc/tifm_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/tifm_core.c b/drivers/misc/tifm_core.c
index 0ab7c92..a511b2a 100644
--- a/drivers/misc/tifm_core.c
+++ b/drivers/misc/tifm_core.c
@@ -145,15 +145,17 @@ static ssize_t type_show(struct device *dev, struct device_attribute *attr,
 	struct tifm_dev *sock = container_of(dev, struct tifm_dev, dev);
 	return sprintf(buf, "%x", sock->type);
 }
+static DEVICE_ATTR_RO(type);
 
-static struct device_attribute tifm_dev_attrs[] = {
-	__ATTR(type, S_IRUGO, type_show, NULL),
-	__ATTR_NULL
+static struct attribute *tifm_dev_attrs[] = {
+	&dev_attr_type.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(tifm_dev);
 
 static struct bus_type tifm_bus_type = {
 	.name      = "tifm",
-	.dev_attrs = tifm_dev_attrs,
+	.dev_groups = tifm_dev_groups,
 	.match     = tifm_bus_match,
 	.uevent    = tifm_uevent,
 	.probe     = tifm_device_probe,
-- 
1.8.4.6.g82e253f.dirty

