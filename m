Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3J2SXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:23:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59359 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3J2SIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:08:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roel Kluin <roel.kluin@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 76/81] serial: vt8500: add missing braces
Date: Tue, 29 Oct 2013 11:04:37 -0700
Message-Id: <1383069882-11437-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roel Kluin <roel.kluin@gmail.com>

commit d969de8d83401683420638c8107dcfedb2146f37 upstream.

Due to missing braces on an if statement, in presence of a device_node a
port was always assigned -1, regardless of any alias entries in the
device tree. Conversely, if device_node was NULL, an unitialized port
ended up being used.

This patch adds the missing braces, fixing the issues.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Tony Prisk <linux@prisktech.co.nz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/tty/serial/vt8500_serial.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 90b837f..7e713cf 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -567,12 +567,13 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 	if (!mmres || !irqres)
 		return -ENODEV;
 
-	if (np)
+	if (np) {
 		port = of_alias_get_id(np, "serial");
 		if (port >= VT8500_MAX_PORTS)
 			port = -1;
-	else
+	} else {
 		port = -1;
+	}
 
 	if (port < 0) {
 		/* calculate the port id */
-- 
1.8.1.2

