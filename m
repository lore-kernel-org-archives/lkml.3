Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab3H0PyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 11:54:04 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:46608 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3H0PyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 11:54:02 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 2/4] staging: ozwpan: Reset PORT_ENABLE bit.
Date: Tue, 27 Aug 2013 16:53:41 +0100
Message-ID: <1377618823-12246-2-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377618823-12246-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377618823-12246-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reset PORT_ENABLE bit of port status on loosing PD.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozhcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ozwpan/ozhcd.c b/drivers/staging/ozwpan/ozhcd.c
index b0398c5..39f5066 100644
--- a/drivers/staging/ozwpan/ozhcd.c
+++ b/drivers/staging/ozwpan/ozhcd.c
@@ -756,7 +756,7 @@ void oz_hcd_pd_departed(struct oz_port *port)
 	port->config_num = 0;
 	port->flags &= ~(OZ_PORT_F_PRESENT | OZ_PORT_F_DYING);
 	port->flags |= OZ_PORT_F_CHANGED;
-	port->status &= ~USB_PORT_STAT_CONNECTION;
+	port->status &= ~(USB_PORT_STAT_CONNECTION | USB_PORT_STAT_ENABLE);
 	port->status |= (USB_PORT_STAT_C_CONNECTION << 16);
 	/* If there is an endpont 0 then clear the pointer while we hold
 	 * the spinlock be we deallocate it after releasing the lock.
-- 
1.7.9.5

