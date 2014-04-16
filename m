Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbaDPKG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:06:28 -0400
Received: from packetmixer.de ([79.140.42.25]:58910 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbaDPKG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:06:27 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2014 06:06:27 EDT
From: Simon Wunderlich <sw@simonwunderlich.de>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH] sysfs.h: don't return a void-valued expression in sysfs_remove_file
Date: Wed, 16 Apr 2014 11:56:45 +0200
Message-Id: <1397642205-7284-1-git-send-email-sw@simonwunderlich.de>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse was complaining about that:
include/linux/sysfs.h:432:9: warning: returning void-valued expression

Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 include/linux/sysfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 084354b..d451ec5 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -446,7 +446,7 @@ static inline int __must_check sysfs_create_file(struct kobject *kobj,
 static inline void sysfs_remove_file(struct kobject *kobj,
 				     const struct attribute *attr)
 {
-	return sysfs_remove_file_ns(kobj, attr, NULL);
+	sysfs_remove_file_ns(kobj, attr, NULL);
 }
 
 static inline int sysfs_rename_link(struct kobject *kobj, struct kobject *target,
-- 
1.9.1

