Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3AVLon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:44:43 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56245 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab3AVLoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:44:02 -0500
X-IronPort-AV: E=Sophos;i="4.84,514,1355068800"; 
   d="scan'208";a="6628474"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, jiang.liu@huawei.com, julian.calaby@gmail.com,
        sfr@canb.auug.org.au
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org
Subject: [PATCH Bug fix 4/5] Bug fix: Fix section mismatch problem of release_firmware_map_entry().
Date: Tue, 22 Jan 2013 19:43:03 +0800
Message-Id: <1358854984-6073-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1358854984-6073-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1358854984-6073-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/22 19:42:58,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/22 19:43:02,
	Serialize complete at 2013/01/22 19:43:02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function release_firmware_map_entry() references the function
__meminit firmware_map_find_entry_in_list(). So it should also have
__meminit.

And since the firmware_map_entry->kobj is initialized with memmap_ktype,
the memmap_ktype should also be prefixed by __refdata.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/firmware/memmap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 0710179..658fdd4 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -103,7 +103,7 @@ to_memmap_entry(struct kobject *kobj)
 	return container_of(kobj, struct firmware_map_entry, kobj);
 }
 
-static void release_firmware_map_entry(struct kobject *kobj)
+static void __meminit release_firmware_map_entry(struct kobject *kobj)
 {
 	struct firmware_map_entry *entry = to_memmap_entry(kobj);
 
@@ -127,7 +127,7 @@ static void release_firmware_map_entry(struct kobject *kobj)
 	kfree(entry);
 }
 
-static struct kobj_type memmap_ktype = {
+static struct kobj_type __refdata memmap_ktype = {
 	.release	= release_firmware_map_entry,
 	.sysfs_ops	= &memmap_attr_ops,
 	.default_attrs	= def_attrs,
-- 
1.7.1

