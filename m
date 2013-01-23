Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab3AWF6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:58:44 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:41455 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3AWF6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:58:42 -0500
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH] driver-core: remove the duplicate assignment of kobj->parent in device_add
Date: Wed, 23 Jan 2013 13:58:30 +0800
Message-Id: <1358920710-23147-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012305-9264-0000-0000-0000030C76CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobject_add() will setup the kobject parent correctly.

This patch removes the redundant code.

Tested on Lenovo T420.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Reviewed-by: Ram Pai <linuxram@us.ibm.com>
Reviewed-by: Gavin Shan <shangw@linux.vnet.ibm.com>
---
 drivers/base/core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 5e6e00b..37d0ea8 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -992,8 +992,6 @@ int device_add(struct device *dev)
 
 	parent = get_device(dev->parent);
 	kobj = get_device_parent(dev, parent);
-	if (kobj)
-		dev->kobj.parent = kobj;
 
 	/* use parent numa_node */
 	if (parent)
@@ -1001,7 +999,7 @@ int device_add(struct device *dev)
 
 	/* first, register with generic layer. */
 	/* we require the name to be set before, and pass NULL */
-	error = kobject_add(&dev->kobj, dev->kobj.parent, NULL);
+	error = kobject_add(&dev->kobj, kobj, NULL);
 	if (error)
 		goto Error;
 
-- 
1.7.5.4

