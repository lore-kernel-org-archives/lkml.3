Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab3DWQeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:34:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59772 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295Ab3DWQcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:32:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 17/21] tty/serial/sirf: fix MODULE_DEVICE_TABLE
Date: Tue, 23 Apr 2013 18:30:49 +0200
Message-Id: <1366734653-488286-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:M8hRsRRGG/coJcFVmhy79EoTOpY7FIiYUGW1Qzj+Asc
 NPNglQGEew0NYCEWI82njHk8zOVeyskhp3HEaxdt4qUq60w1F7
 0ynIXPvpP7FqiJNxN8h3ep6RiJ15ePe/8mtjOE369XqnjDGDBy
 FEFwZCbNTzp8SOcj6TKUz4CCLf6W97F/98+FVErrqBf09ojPn9
 wfwE0RfHC7nLqQq34v5O6/XIIAr8m7fHNlHCBrmQc1xjVplQDF
 8eUnWuKv3najm8QNMPMdHStsONGKaAy+1UY2uOgSP9qeNNGYHo
 i4HeOF8Vxd7BWfCqeIfQzHmK4nCth6Emw63qSe9Y6ZVY1F4VX9
 qzDlJ/5yl3PLpQvX5lrxmpJf1JnnD+fRNEG4qoGii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes building the sirfsorc-uart driver as a loadable module,
which uses an incorrect MODULE_DEVICE_TABLE, by changing the reference to the
correct symbol.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/serial/sirfsoc_uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sirfsoc_uart.c b/drivers/tty/serial/sirfsoc_uart.c
index 6bbfe99..03465b6 100644
--- a/drivers/tty/serial/sirfsoc_uart.c
+++ b/drivers/tty/serial/sirfsoc_uart.c
@@ -758,7 +758,7 @@ static struct of_device_id sirfsoc_uart_ids[] = {
 	{ .compatible = "sirf,marco-uart", },
 	{}
 };
-MODULE_DEVICE_TABLE(of, sirfsoc_serial_of_match);
+MODULE_DEVICE_TABLE(of, sirfsoc_uart_ids);
 
 static struct platform_driver sirfsoc_uart_driver = {
 	.probe		= sirfsoc_uart_probe,
-- 
1.8.1.2

