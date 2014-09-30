Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981AbaI3SDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:03:40 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44127 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbaI3SBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:01:36 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-c6x-dev@linux-c6x.org, linux-ia64@vger.kernel.org,
        linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
        linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org,
        xen-devel@lists.xenproject.org, Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 11/16] sh: support poweroff through poweroff handler call chain
Date: Tue, 30 Sep 2014 11:00:51 -0700
Message-Id: <1412100056-15517-12-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412100056-15517-1-git-send-email-linux@roeck-us.net>
References: <1412100056-15517-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel core now supports a poweroff handler call chain
to remove power from the system. Call it if pm_power_off
is set to NULL.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/sh/kernel/reboot.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sh/kernel/reboot.c b/arch/sh/kernel/reboot.c
index 04afe5b..8e68926 100644
--- a/arch/sh/kernel/reboot.c
+++ b/arch/sh/kernel/reboot.c
@@ -53,6 +53,8 @@ static void native_machine_power_off(void)
 {
 	if (pm_power_off)
 		pm_power_off();
+	else
+		do_kernel_poweroff();
 }
 
 static void native_machine_halt(void)
-- 
1.9.1

