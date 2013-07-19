Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935416Ab3GSICw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 04:02:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54371 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965481Ab3GSIBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 04:01:06 -0400
X-IronPort-AV: E=Sophos;i="4.89,699,1367942400"; 
   d="scan'208";a="7947432"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH 09/21] x86: Make get_ramdisk_{image|size}() global.
Date: Fri, 19 Jul 2013 15:59:22 +0800
Message-Id: <1374220774-29974-10-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/19 15:58:44,
	Serialize complete at 2013/07/19 15:58:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following patches, we need to call get_ramdisk_{image|size}()
to get initrd file's address and size. So make these two functions
global.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/include/asm/setup.h |    3 +++
 arch/x86/kernel/setup.c      |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index b7bf350..69de7a1 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -106,6 +106,9 @@ void *extend_brk(size_t size, size_t align);
 	RESERVE_BRK(name, sizeof(type) * entries)
 
 extern void probe_roms(void);
+u64 get_ramdisk_image(void);
+u64 get_ramdisk_size(void);
+
 #ifdef __i386__
 
 void __init i386_start_kernel(void);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 38a5952..28d2e60 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -297,7 +297,7 @@ static void __init reserve_brk(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-static u64 __init get_ramdisk_image(void)
+u64 __init get_ramdisk_image(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 
@@ -305,7 +305,7 @@ static u64 __init get_ramdisk_image(void)
 
 	return ramdisk_image;
 }
-static u64 __init get_ramdisk_size(void)
+u64 __init get_ramdisk_size(void)
 {
 	u64 ramdisk_size = boot_params.hdr.ramdisk_size;
 
-- 
1.7.1

