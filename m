Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab3GWBgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:36:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:38047 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab3GWBgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:36:18 -0400
X-IronPort-AV: E=Sophos;i="4.89,723,1367942400"; 
   d="scan'208";a="7984956"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] x86, acpi: Fix wrong checking condition in acpi_register_lapic().
Date: Tue, 23 Jul 2013 09:39:01 +0800
Message-Id: <1374543541-4451-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/23 09:34:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/23 09:34:17,
	Serialize complete at 2013/07/23 09:34:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We wanted to check if the acpi id is out of range. It should be:
	if (id >= (MAX_LOCAL_APIC)).

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/kernel/acpi/boot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d81a972..2a15ae7 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -199,7 +199,7 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 {
 	unsigned int ver = 0;
 
-	if (id >= (MAX_LOCAL_APIC-1)) {
+	if (id >= (MAX_LOCAL_APIC)) {
 		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
 		return;
 	}
-- 
1.7.10.1

