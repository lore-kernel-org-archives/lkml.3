Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630Ab3GXDzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 23:55:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38338 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3GXDzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 23:55:31 -0400
Date: Tue, 23 Jul 2013 20:54:56 -0700
From: tip-bot for Tang Chen <tipbot@zytor.com>
Message-ID: <tip-82982d729319e975115d88cae4927dffb02bfea7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tangchen@cn.fujitsu.com, tglx@linutronix.de, len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tangchen@cn.fujitsu.com, tglx@linutronix.de, len.brown@intel.com
In-Reply-To: <1374566419-21120-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1374566419-21120-1-git-send-email-tangchen@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/acpi:
  Fix incorrect sanity check in acpi_register_lapic()
Git-Commit-ID: 82982d729319e975115d88cae4927dffb02bfea7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 23 Jul 2013 20:55:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82982d729319e975115d88cae4927dffb02bfea7
Gitweb:     http://git.kernel.org/tip/82982d729319e975115d88cae4927dffb02bfea7
Author:     Tang Chen <tangchen@cn.fujitsu.com>
AuthorDate: Tue, 23 Jul 2013 16:00:19 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Jul 2013 10:08:16 +0200

x86/acpi: Fix incorrect sanity check in acpi_register_lapic()

We wanted to check if the APIC ID is out of range. It should be:

	if (id >= MAX_LOCAL_APIC)

There's no known bad effect of this bug.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: pavel@ucw.cz
Cc: rjw@sisk.pl
Link: http://lkml.kernel.org/r/1374566419-21120-1-git-send-email-tangchen@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/acpi/boot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 2627a81..872a2d2 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -199,7 +199,7 @@ static void acpi_register_lapic(int id, u8 enabled)
 {
 	unsigned int ver = 0;
 
-	if (id >= (MAX_LOCAL_APIC-1)) {
+	if (id >= MAX_LOCAL_APIC) {
 		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
 		return;
 	}
