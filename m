Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab3HUKSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 06:18:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:5135 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab3HUKSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 06:18:46 -0400
X-IronPort-AV: E=Sophos;i="4.89,927,1367942400"; 
   d="scan'208";a="8261328"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: konrad.wilk@oracle.com, robert.moore@intel.com, lv.zheng@intel.com,
        rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [PATCH 2/8] x86, microcode: Use get_ramdisk_{image|size}() in microcode handling.
Date: Wed, 21 Aug 2013 18:15:37 +0800
Message-Id: <1377080143-28455-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377080143-28455-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1377080143-28455-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/21 18:15:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/21 18:15:17,
	Serialize complete at 2013/08/21 18:15:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

Since we made get_ramdisk_{image|size}() global, use them when we want
to access ramdisk.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Tested-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kernel/microcode_intel_early.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index 1575deb..4c58a1b 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -743,8 +743,8 @@ load_ucode_intel_bsp(void)
 	struct boot_params *boot_params_p;
 
 	boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
-	ramdisk_image = boot_params_p->hdr.ramdisk_image;
-	ramdisk_size  = boot_params_p->hdr.ramdisk_size;
+	ramdisk_image = get_ramdisk_image(boot_params_p);
+	ramdisk_size  = get_ramdisk_size(boot_params_p);
 	initrd_start_early = ramdisk_image;
 	initrd_end_early = initrd_start_early + ramdisk_size;
 
@@ -753,8 +753,8 @@ load_ucode_intel_bsp(void)
 		(unsigned long *)__pa_nodebug(&mc_saved_in_initrd),
 		initrd_start_early, initrd_end_early, &uci);
 #else
-	ramdisk_image = boot_params.hdr.ramdisk_image;
-	ramdisk_size  = boot_params.hdr.ramdisk_size;
+	ramdisk_image = get_ramdisk_image(&boot_params);
+	ramdisk_size  = get_ramdisk_size(&boot_params);
 	initrd_start_early = ramdisk_image + PAGE_OFFSET;
 	initrd_end_early = initrd_start_early + ramdisk_size;
 
-- 
1.7.1

