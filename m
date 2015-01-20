Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbbATMey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:34:54 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:42338 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbbATMaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:30:18 -0500
From: Olivier Sobrie <olivier@sobrie.be>
To: Jan Dumon <j.dumon@option.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Olivier Sobrie <olivier@sobrie.be>
Subject: [PATCH 03/11] hso: fix memory leak when device disconnects
Date: Tue, 20 Jan 2015 13:29:30 +0100
Message-Id: <1421756978-4093-4-git-send-email-olivier@sobrie.be>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1421756978-4093-3-git-send-email-olivier@sobrie.be>
References: <1421756978-4093-1-git-send-email-olivier@sobrie.be>
 <1421756978-4093-2-git-send-email-olivier@sobrie.be>
 <1421756978-4093-3-git-send-email-olivier@sobrie.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the disconnect path, tx_buffer should freed like tx_data to avoid
a memory leak when the device disconnects.

Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
---
 drivers/net/usb/hso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 3a6c630..470ef9e 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2253,6 +2253,7 @@ static void hso_serial_common_free(struct hso_serial *serial)
 
 	/* unlink and free TX URB */
 	usb_free_urb(serial->tx_urb);
+	kfree(serial->tx_buffer);
 	kfree(serial->tx_data);
 	tty_port_destroy(&serial->port);
 }
-- 
2.2.0

