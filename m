Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab3KIGv7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:51:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab3KIGvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.11 28/94] can: at91-can: fix device to driver data mapping for platform devices
Date: Fri,  8 Nov 2013 22:51:34 -0800
Message-Id: <20131109065206.205408542@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 5abbeea553c8260ed4e2ac4aae962aff800b6c6d upstream.

In commit:

    3078cde7 can: at91_can: add dt support

device tree support was added to the at91_can driver. In this commit the
mapping of device to driver data was mixed up. This results in the sam9x5
parameters being used for the sam9263 and the workaround for the broken mailbox
0 on the sam9263 not being activated.

This patch fixes the broken platform_device_id table.

Cc: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/at91_can.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1405,10 +1405,10 @@ static int at91_can_remove(struct platfo
 
 static const struct platform_device_id at91_can_id_table[] = {
 	{
-		.name = "at91_can",
+		.name = "at91sam9x5_can",
 		.driver_data = (kernel_ulong_t)&at91_at91sam9x5_data,
 	}, {
-		.name = "at91sam9x5_can",
+		.name = "at91_can",
 		.driver_data = (kernel_ulong_t)&at91_at91sam9263_data,
 	}, {
 		/* sentinel */


