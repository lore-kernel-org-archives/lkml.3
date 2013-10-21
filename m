Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab3JUVWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 17:22:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab3JUVWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 17:22:49 -0400
Message-ID: <52659B24.4030809@suse.com>
Date: Mon, 21 Oct 2013 17:22:44 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linux.com>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] kobject: export kobj_sysfs_ops
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct kobj_attribute implements the baseline attribute functionality
that can be used all over the place. We should export the ops associated
with it. I have a series of patches on the linux-btrfs list that depend
on using kobj_sysfs_ops rather than re-implement them.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 lib/kobject.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/kobject.c	2013-10-21 16:09:51.868220920 -0400
+++ b/lib/kobject.c	2013-10-21 16:10:00.216037635 -0400
@@ -726,6 +726,7 @@ const struct sysfs_ops kobj_sysfs_ops =
 	.show	= kobj_attr_show,
 	.store	= kobj_attr_store,
 };
+EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
 
 /**
  * kset_register - initialize and add a kset.



-- 
Jeff Mahoney
SUSE Labs
