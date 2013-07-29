Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab3G2Q62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 12:58:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:41374 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab3G2Q60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 12:58:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,771,1367996400"; 
   d="scan'208";a="378400470"
From: Darren Hart <dvhart@linux.intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH] pch_uart: Remove __initdata annotation from dmi_table
Date: Mon, 29 Jul 2013 09:58:14 -0700
Message-Id: <df1bf589c86f764ef8649fdfaf017936addef6d3.1375117094.git.dvhart@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dmi_table is best accessed from the probe function, which is not
an __init function. Drop the __initdata annotation from the dmi_table
to avoid the section mismatch compiler warnings:

WARNING: drivers/tty/serial/pch_uart.o(.text+0x4871): Section mismatch
in reference from the function pch_uart_init_port() to the variable
.init.data:pch_uart_dmi_table

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
---
 drivers/tty/serial/pch_uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 271cc73..bc0aa08 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -373,7 +373,7 @@ static const struct file_operations port_regs_ops = {
 };
 #endif	/* CONFIG_DEBUG_FS */
 
-static struct dmi_system_id __initdata pch_uart_dmi_table[] = {
+static struct dmi_system_id pch_uart_dmi_table[] = {
 	{
 		.ident = "CM-iTC",
 		{
-- 
1.8.3.1

