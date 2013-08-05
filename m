Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3HERlb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:41:31 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:31966 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3HERk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:40:27 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 3/4] staging: ozwpan: Reset port configuration number.
Date: Mon, 5 Aug 2013 18:40:14 +0100
Message-ID: <1375724415-10801-4-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that we reset port configuration no. when PD departs.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index a739986..b060e43 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -721,6 +721,7 @@ void oz_hcd_pd_departed(void *hport)
 	hpd = port->hpd;
 	port->hpd = NULL;
 	port->bus_addr = 0xff;
+	port->config_num = 0;
 	port->flags &= ~(OZ_PORT_F_PRESENT | OZ_PORT_F_DYING);
 	port->flags |= OZ_PORT_F_CHANGED;
 	port->status &= ~USB_PORT_STAT_CONNECTION;
-- 
1.7.9.5

