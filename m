Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3GIDi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 23:38:58 -0400
Received: from intranet.asianux.com ([58.214.24.6]:30017 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3GIDiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 23:38:55 -0400
X-Spam-Score: -100.8
Message-ID: <51DB8597.4090101@asianux.com>
Date: Tue, 09 Jul 2013 11:37:59 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, khali@linux-fr.org,
        David.Woodhouse@intel.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel/params.c: print failure information instead of 'KOBJ_ADD'
 to user space, when sysfs_create_file() fails.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sysfs_create_file() fails, recommend to print the related failure
information. And it is useless to still 'KOBJ_ADD' to user space.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/params.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 440e65d..f5299c1 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -845,7 +845,13 @@ static void __init version_sysfs_builtin(void)
 		mk = locate_module_kobject(vattr->module_name);
 		if (mk) {
 			err = sysfs_create_file(&mk->kobj, &vattr->mattr.attr);
-			kobject_uevent(&mk->kobj, KOBJ_ADD);
+			if (err)
+				printk(KERN_WARNING
+				       "%s (%d): sysfs_create_file fail for %s, err: %d\n",
+				       __FILE__, __LINE__,
+				       vattr->module_name, err);
+			else
+				kobject_uevent(&mk->kobj, KOBJ_ADD);
 			kobject_put(&mk->kobj);
 		}
 	}
-- 
1.7.7.6
