Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaI3SBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:01:32 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:55223 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbaI3SB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:01:28 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-c6x-dev@linux-c6x.org, linux-ia64@vger.kernel.org,
        linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
        linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org,
        xen-devel@lists.xenproject.org, Guenter Roeck <linux@roeck-us.net>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Subject: [RFC PATCH 08/16] ia64: support poweroff through poweroff handler call chain
Date: Tue, 30 Sep 2014 11:00:48 -0700
Message-Id: <1412100056-15517-9-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412100056-15517-1-git-send-email-linux@roeck-us.net>
References: <1412100056-15517-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel core now supports a poweroff handler call chain
to remove power from the system. Call it if pm_power_off
is set to NULL.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/ia64/kernel/process.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index deed6fa..489b0d8 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -677,6 +677,8 @@ machine_power_off (void)
 {
 	if (pm_power_off)
 		pm_power_off();
+	else
+		do_kernel_poweroff();
 	machine_halt();
 }
 
-- 
1.9.1

