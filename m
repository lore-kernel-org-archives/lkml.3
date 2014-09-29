Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaI2Euv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 00:50:51 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:63409 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaI2Etk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 00:49:40 -0400
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [RFC RESEND 07/10] fotg210: Remove superfluous macro definitions
Date: Sun, 28 Sep 2014 23:48:55 -0500
Message-Id: <1411966138-3053-8-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411966138-3053-1-git-send-email-chris@rorvick.com>
References: <1411966138-3053-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fotg210_dbg_port struct is a copy of the ehci_dbg_port definition
in the <linux/usb/ehci_def.h> header.  Embedded in this definition are
a number of macros which came along for the ride.  These macros are not
used in the fotg210 driver and will conflict those in the new
<linux/usb/ehci-dbgp.h> header.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/usb/host/fotg210.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/usb/host/fotg210.h b/drivers/usb/host/fotg210.h
index 98c9670..c2e5134 100644
--- a/drivers/usb/host/fotg210.h
+++ b/drivers/usb/host/fotg210.h
@@ -298,24 +298,10 @@ struct fotg210_regs {
  */
 struct fotg210_dbg_port {
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

