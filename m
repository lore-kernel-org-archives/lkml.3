Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaI2Etl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:49:41 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55551 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaI2Etg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:49:36 -0400
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [RFC RESEND 03/10] fusbh200: Remove superfluous macro definitions
Date: Sun, 28 Sep 2014 23:48:51 -0500
Message-Id: <1411966138-3053-4-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411966138-3053-1-git-send-email-chris@rorvick.com>
References: <1411966138-3053-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fusbh200_dbg_port struct is a copy of the ehci_dbg_port definition
in the <linux/usb/ehci_def.h> header.  Embedded in this definition are
a number of macros which came along for the ride.  These macros are not
used in the fusbh200 driver and will conflict those in the new
<linux/usb/ehci-dbgp.h> header.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/usb/host/fusbh200.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/usb/host/fusbh200.h b/drivers/usb/host/fusbh200.h
index 6e7b8c1..da7152b 100644
--- a/drivers/usb/host/fusbh200.h
+++ b/drivers/usb/host/fusbh200.h
@@ -290,24 +290,10 @@ struct fusbh200_regs {
  */
 struct fusbh200_dbg_port {
 	u32	control;
-#define DBGP_OWNER	(1<<30)
-#define DBGP_ENABLED	(1<<28)
-#define DBGP_DONE	(1<<16)
-#define DBGP_INUSE	(1<<10)
-#define DBGP_ERRCODE(x)	(((x)>>7)&0x07)
-#	define DBGP_ERR_BAD	1
-#	define DBGP_ERR_SIGNAL	2
-#define DBGP_ERROR	(1<<6)
-#define DBGP_GO		(1<<5)
-#define DBGP_OUT	(1<<4)
-#define DBGP_LEN(x)	(((x)>>0)&0x0f)
 	u32	pids;
-#define DBGP_PID_GET(x)		(((x)>>16)&0xff)
-#define DBGP_PID_SET(data, tok)	(((data)<<8)|(tok))
 	u32	data03;
 	u32	data47;
 	u32	address;
-#define DBGP_EPADDR(dev, ep)	(((dev)<<8)|(ep))
 };
 
 #ifdef CONFIG_EARLY_PRINTK_DBGP
-- 
1.9.3

