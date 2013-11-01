Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3KAWNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:13:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515Ab3KAWIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roel Kluin <roel.kluin@gmail.com>, Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 3.11 63/66] serial: vt8500: add missing braces
Date: Fri,  1 Nov 2013 15:07:39 -0700
Message-Id: <20131101220652.149065786@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/tty/serial/vt8500_serial.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -559,12 +559,13 @@ static int vt8500_serial_probe(struct pl
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


