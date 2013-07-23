Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab3GWH5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:57:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:11623 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab3GWH5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:57:36 -0400
X-IronPort-AV: E=Sophos;i="4.89,725,1367942400"; 
   d="scan'208";a="7989428"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1 v2] x86, acpi: Fix wrong checking condition in acpi_register_lapic().
Date: Tue, 23 Jul 2013 16:00:19 +0800
Message-Id: <1374566419-21120-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/23 15:55:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/23 15:55:35,
	Serialize complete at 2013/07/23 15:55:35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We wanted to check if the acpi id is out of range. It should be:
	if (id >= MAX_LOCAL_APIC).

v1 -> v2:
Remove the superfluous parentheses around MAX_LOCAL_APIC.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Len Brown <len.brown@intel.com>
---
 arch/x86/kernel/acpi/boot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d81a972..256479d 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -199,7 +199,7 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 {
 	unsigned int ver = 0;
 
-	if (id >= (MAX_LOCAL_APIC-1)) {
+	if (id >= MAX_LOCAL_APIC) {
 		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
 		return;
 	}
-- 
1.7.10.1

