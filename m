Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab3J2SIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:08:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59377 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab3J2SIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:08:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tony Prisk <linux@prisktech.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 75/81] serial: vt8500: Fix range-checking on vt8500_uart_ports
Date: Tue, 29 Oct 2013 11:04:36 -0700
Message-Id: <1383069882-11437-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Prisk <linux@prisktech.co.nz>

commit 27dd2e04923341cff96aae164117c44da1072c32 upstream.

Fix two instances where the index to vt8500_uart_ports is tested
against > VT8500_MAX_PORTS. Correct usage should be >= VT8500_MAX_PORTS.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/vt8500_serial.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index d5ed9f6..90b837f 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -569,7 +569,7 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 
 	if (np)
 		port = of_alias_get_id(np, "serial");
-		if (port > VT8500_MAX_PORTS)
+		if (port >= VT8500_MAX_PORTS)
 			port = -1;
 	else
 		port = -1;
@@ -580,7 +580,7 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 					sizeof(vt8500_ports_in_use));
 	}
 
-	if (port > VT8500_MAX_PORTS)
+	if (port >= VT8500_MAX_PORTS)
 		return -ENODEV;
 
 	/* reserve the port id */
-- 
1.8.1.2

