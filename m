Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab3HRQXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 12:23:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab3HRQXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 12:23:19 -0400
Message-ID: <1376842970.11104.11.camel@t520.redhat.com>
Subject: [PATCH] arm64: add screen_info for console support
From: Mark Salter <msalter@redhat.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: catalin.marinas@arm.com, will.deacon@arm.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Sun, 18 Aug 2013 12:22:50 -0400
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The arm64 port doesn't provide a screen_info struct for console support
which leads to a build failure with some configurations:

  drivers/video/console/vgacon.c:820: undefined reference to `screen_info'

This patch adds an empty declaration of screen_info to fix the build
problem. Some additional runtime code is needed to actually make it
useful.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/arm64/kernel/setup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index add6ea6..eb9f93a 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -64,6 +64,10 @@ static const char *cpu_name;
 static const char *machine_name;
 phys_addr_t __fdt_pointer __initdata;
 
+#if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)                                               
+struct screen_info screen_info;                                                                                
+#endif                                                                                                         
+
 /*
  * Standard memory resources
  */
-- 
1.8.1.4



