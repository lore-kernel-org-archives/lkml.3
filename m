Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbbAOQSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 11:18:22 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:34912 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbbAOQSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 11:18:21 -0500
From: Javi Merino <javi.merino@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Javi Merino <javi.merino@arm.com>,
        =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] sysfs: fix warning when creating a sysfs group without attributes
Date: Thu, 15 Jan 2015 16:17:45 +0000
Message-Id: <1421338665-22975-1-git-send-email-javi.merino@arm.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When attempting to create a gropu without attrs, the warning prints the
name of the group.  However, the check for name being a NULL pointer is
wrong: it uses the pointer to the name when it's NULL.  Fix it to use
the name if present, otherwise just put an empty string.

Cc: Bruno Prémont <bonbons@linux-vserver.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Javi Merino <javi.merino@arm.com>
---
 fs/sysfs/group.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 7d2a860ba788..2554d8835b48 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -99,7 +99,7 @@ static int internal_create_group(struct kobject *kobj, int update,
 		return -EINVAL;
 	if (!grp->attrs && !grp->bin_attrs) {
 		WARN(1, "sysfs: (bin_)attrs not set by subsystem for group: %s/%s\n",
-			kobj->name, grp->name ? "" : grp->name);
+			kobj->name, grp->name ?: "");
 		return -EINVAL;
 	}
 	if (grp->name) {
-- 
1.9.1

