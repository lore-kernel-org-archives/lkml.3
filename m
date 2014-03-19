Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaCSUAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:00:20 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:59885 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754796AbaCSUAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:00:11 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 2/5] efivars: Check size of user object
Date: Wed, 19 Mar 2014 19:59:57 +0000
Message-Id: <1395259200-27732-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1395259200-27732-1-git-send-email-matt@console-pimps.org>
References: <1395259200-27732-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Unbelieavably there are no checks to see whether the data structure
passed to 'new_var' and 'del_var' is the size that we expect. Let's add
some for better robustness.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 drivers/firmware/efi/efivars.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 06ec6ee1c58a..2c21cccc2572 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -347,6 +347,9 @@ static ssize_t efivar_create(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
+	if (count != sizeof(*new_var))
+		return -EINVAL;
+
 	attributes = new_var->Attributes;
 	size = new_var->DataSize;
 	data = new_var->Data;
@@ -395,6 +398,9 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
+	if (count != sizeof(*del_var))
+		return -EINVAL;
+
 	name = del_var->VariableName;
 	vendor = del_var->VendorGuid;
 
-- 
1.8.5.3

