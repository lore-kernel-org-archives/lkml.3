Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3AOK5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:57:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:32090 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756392Ab3AOKzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:55:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,473,1355068800"; 
   d="scan'208";a="6591342"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rientjes@google.com, len.brown@intel.com,
        benh@kernel.crashing.org, paulus@samba.org, cl@linux.com,
        minchan.kim@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, glommer@parallels.com, jiang.liu@huawei.com
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-ia64@vger.kernel.org, cmetcalf@tilera.com,
        sparclinux@vger.kernel.org
Subject: [BUG Fix Patch 5/6] Bug fix: Fix the wrong comments of map_entries.
Date: Tue, 15 Jan 2013 18:54:26 +0800
Message-Id: <1358247267-18089-6-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1358247267-18089-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1358247267-18089-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 18:54:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/15 18:54:30,
	Serialize complete at 2013/01/15 18:54:30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have a map_entries_lock to protect map_entries list.
So we need to update the comments.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/firmware/memmap.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/memmap.c b/drivers/firmware/memmap.c
index 940c4e9..ae823b4 100644
--- a/drivers/firmware/memmap.c
+++ b/drivers/firmware/memmap.c
@@ -108,11 +108,7 @@ static struct kobj_type memmap_ktype = {
  * Registration functions ------------------------------------------------------
  */
 
-/*
- * Firmware memory map entries. No locking is needed because the
- * firmware_map_add() and firmware_map_add_early() functions are called
- * in firmware initialisation code in one single thread of execution.
- */
+/* Firmware memory map entries. */
 static LIST_HEAD(map_entries);
 static DEFINE_SPINLOCK(map_entries_lock);
 
-- 
1.7.1

