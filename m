Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751602AbaKIBXW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 20:23:22 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46741 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbaKIBWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 20:22:30 -0500
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: cascardo@linux.vnet.ibm.com
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 2/5] serial: jsm: Remove unnecessary if statement
Date: Sun,  9 Nov 2014 02:22:17 +0100
Message-Id: <1415496140-14997-3-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415496140-14997-2-git-send-email-bergo.torino@gmail.com>
References: <1415496140-14997-1-git-send-email-bergo.torino@gmail.com>
 <1415496140-14997-2-git-send-email-bergo.torino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The flow of {neo,cls}_param() shows that at this stage the baud rate
has a non-zero value. This fact makes the if clausule obsolete and
acknowledges it's removal.

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 drivers/tty/serial/jsm/jsm_cls.c | 3 ---
 drivers/tty/serial/jsm/jsm_neo.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/tty/serial/jsm/jsm_cls.c b/drivers/tty/serial/jsm/jsm_cls.c
index 3df9112..bfb0681 100644
--- a/drivers/tty/serial/jsm/jsm_cls.c
+++ b/drivers/tty/serial/jsm/jsm_cls.c
@@ -767,9 +767,6 @@ static void cls_param(struct jsm_channel *ch)
 	ier = readb(&ch->ch_cls_uart->ier);
 	uart_lcr = readb(&ch->ch_cls_uart->lcr);
 
-	if (baud == 0)
-		baud = 9600;
-
 	quot = ch->ch_bd->bd_dividend / baud;
 
 	if (quot != 0) {
diff --git a/drivers/tty/serial/jsm/jsm_neo.c b/drivers/tty/serial/jsm/jsm_neo.c
index b9faee7..4b8196d 100644
--- a/drivers/tty/serial/jsm/jsm_neo.c
+++ b/drivers/tty/serial/jsm/jsm_neo.c
@@ -1037,9 +1037,6 @@ static void neo_param(struct jsm_channel *ch)
 	ier = readb(&ch->ch_neo_uart->ier);
 	uart_lcr = readb(&ch->ch_neo_uart->lcr);
 
-	if (baud == 0)
-		baud = 9600;
-
 	quot = ch->ch_bd->bd_dividend / baud;
 
 	if (quot != 0) {
-- 
1.9.1

