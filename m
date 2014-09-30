Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaI3SEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 14:04:37 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:41451 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbaI3SB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 14:01:26 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-c6x-dev@linux-c6x.org, linux-ia64@vger.kernel.org,
        linux-metag@vger.kernel.org, linux-mips@linux-mips.org,
        linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org,
        xen-devel@lists.xenproject.org, Guenter Roeck <linux@roeck-us.net>,
        Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>
Subject: [RFC PATCH 07/16] c6x: support poweroff through poweroff handler call chain
Date: Tue, 30 Sep 2014 11:00:47 -0700
Message-Id: <1412100056-15517-8-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412100056-15517-1-git-send-email-linux@roeck-us.net>
References: <1412100056-15517-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel core now supports a poweroff handler call chain
to remove power from the system. Call it if pm_power_off
is set to NULL.

Cc: Mark Salter <msalter@redhat.com>
Cc: Aurelien Jacquiot <a-jacquiot@ti.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 arch/c6x/kernel/process.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/c6x/kernel/process.c b/arch/c6x/kernel/process.c
index 57d2ea8..ddf088e 100644
--- a/arch/c6x/kernel/process.c
+++ b/arch/c6x/kernel/process.c
@@ -75,6 +75,8 @@ void machine_power_off(void)
 {
 	if (pm_power_off)
 		pm_power_off();
+	else
+		do_kernel_poweroff();
 	halt_loop();
 }
 
-- 
1.9.1

