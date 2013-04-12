Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3DLJoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 05:44:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:35471 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657Ab3DLJoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 05:44:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,462,1363158000"; 
   d="scan'208";a="321340930"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 1/1] serial: 8250_dw: Fix the stub for dw8250_probe_acpi()
Date: Fri, 12 Apr 2013 12:44:27 +0300
Message-Id: <1365759867-29657-2-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365759867-29657-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1365759867-29657-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the stub for dw8250_probe_acpi() that is used
when compiling without ACPI enabled. The argument type was
wrong.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index 39b7ae4..beaa283 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -190,7 +190,7 @@ static int dw8250_probe_acpi(struct uart_8250_port *up)
 	return 0;
 }
 #else
-static inline int dw8250_probe_acpi(struct uart_port *p)
+static inline int dw8250_probe_acpi(struct uart_8250_port *up)
 {
 	return -ENODEV;
 }
-- 
1.7.10.4

