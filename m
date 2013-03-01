Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab3CATLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 14:11:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:57284 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3CATLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:11:12 -0500
Message-ID: <5130FD73.9030601@infradead.org>
Date: Fri, 01 Mar 2013 11:11:47 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Nishanth Menon <nm@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        Carlos Chinea <carlos.chinea@nokia.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-omap@vger.kernel.org
Subject: [PATCH resend] hsi: fix kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc warnings in hsi files:

Warning(include/linux/hsi/hsi.h:136): Excess struct/union/enum/typedef member 'e_handler' description in 'hsi_client'
Warning(include/linux/hsi/hsi.h:136): Excess struct/union/enum/typedef member 'pclaimed' description in 'hsi_client'
Warning(include/linux/hsi/hsi.h:136): Excess struct/union/enum/typedef member 'nb' description in 'hsi_client'
Warning(drivers/hsi/hsi.c:434): No description found for parameter 'handler'
Warning(drivers/hsi/hsi.c:434): Excess function parameter 'cb' description in 'hsi_register_port_event'

Don't document "private:" fields with kernel-doc notation.
If you want to leave them fully documented, that's OK, but
then don't mark them as "private:".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Carlos Chinea <carlos.chinea@nokia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Acked-by: Nishanth Menon <nm@ti.com>
---
 drivers/hsi/hsi.c       |    2 +-
 include/linux/hsi/hsi.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- lnx-38.orig/drivers/hsi/hsi.c
+++ lnx-38/drivers/hsi/hsi.c
@@ -420,7 +420,7 @@ static int hsi_event_notifier_call(struc
 /**
  * hsi_register_port_event - Register a client to receive port events
  * @cl: HSI client that wants to receive port events
- * @cb: Event handler callback
+ * @handler: Event handler callback
  *
  * Clients should register a callback to be able to receive
  * events from the ports. Registration should happen after
--- lnx-38.orig/include/linux/hsi/hsi.h
+++ lnx-38/include/linux/hsi/hsi.h
@@ -121,9 +121,9 @@ static inline int hsi_register_board_inf
  * @device: Driver model representation of the device
  * @tx_cfg: HSI TX configuration
  * @rx_cfg: HSI RX configuration
- * @e_handler: Callback for handling port events (RX Wake High/Low)
- * @pclaimed: Keeps tracks if the clients claimed its associated HSI port
- * @nb: Notifier block for port events
+ * e_handler: Callback for handling port events (RX Wake High/Low)
+ * pclaimed: Keeps tracks if the clients claimed its associated HSI port
+ * nb: Notifier block for port events
  */
 struct hsi_client {
 	struct device		device;
