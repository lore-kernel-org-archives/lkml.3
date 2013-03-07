Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab3CGCXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 21:23:35 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:37311 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256Ab3CGCXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 21:23:31 -0500
From: Wei Yang <weiyang@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, joe@perches.com
Cc: shangw@linux.vnet.ibm.com, linuxram@us.ibm.com,
        Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: [PATCH 2/2] driver-core: remove the duplicate assignment of kobj->parent in device_add
Date: Thu,  7 Mar 2013 10:22:46 +0800
Message-Id: <1362622966-20003-3-git-send-email-weiyang@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1362622966-20003-1-git-send-email-weiyang@linux.vnet.ibm.com>
References: <1362622966-20003-1-git-send-email-weiyang@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030702-5140-0000-0000-000002DAD56E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kobject_add() will setup the kobject parent correctly.

This patch removes the redundant code.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Reviewed-by: Ram Pai <linuxram@us.ibm.com>
Reviewed-by: Gavin Shan <shangw@linux.vnet.ibm.com>
---
 drivers/base/core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 369ae4e..6b0a859 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1024,8 +1024,6 @@ int device_add(struct device *dev)
 
 	parent = get_device(dev->parent);
 	kobj = get_device_parent(dev, parent);
-	if (kobj)
-		dev->kobj.parent = kobj;
 
 	/* use parent numa_node */
 	if (parent)
@@ -1033,7 +1031,7 @@ int device_add(struct device *dev)
 
 	/* first, register with generic layer. */
 	/* we require the name to be set before, and pass NULL */
-	error = kobject_add(&dev->kobj, dev->kobj.parent, NULL);
+	error = kobject_add(&dev->kobj, kobj, NULL);
 	if (error)
 		goto Error;
 
-- 
1.7.5.4

