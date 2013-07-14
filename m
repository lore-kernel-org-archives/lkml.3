Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3GNXGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 19:06:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40498 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab3GNXGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 19:06:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: abbotti@mev.co.uk, oliver@schinagl.nl, linux@roeck-us.net,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 06/10] sysfs: prevent warning when only using binary attributes
Date: Sun, 14 Jul 2013 16:05:56 -0700
Message-Id: <1373843160-3990-7-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
References: <1373843160-3990-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Schinagl <oliver@schinagl.nl>

When only using bin_attrs instead of attrs the kernel prints a warning
and refuses to create the sysfs entry. This fixes that.

Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/sysfs/group.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index e5719c60..09a1a25c 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -93,8 +93,8 @@ static int internal_create_group(struct kobject *kobj, int update,
 	/* Updates may happen before the object has been instantiated */
 	if (unlikely(update && !kobj->sd))
 		return -EINVAL;
-	if (!grp->attrs) {
-		WARN(1, "sysfs: attrs not set by subsystem for group: %s/%s\n",
+	if (!grp->attrs && !grp->bin_attrs) {
+		WARN(1, "sysfs: (bin_)attrs not set by subsystem for group: %s/%s\n",
 			kobj->name, grp->name ? "" : grp->name);
 		return -EINVAL;
 	}
-- 
1.8.3.rc0.20.gb99dd2e

