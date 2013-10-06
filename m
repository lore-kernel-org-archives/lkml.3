Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3JFTNj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 15:13:39 -0400
Received: from mout.gmx.net ([212.227.17.21]:51842 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab3JFTNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 15:13:38 -0400
From: Hans-Frieder Vogt <hfvogt@gmx.net>
To: zbr@ioremap.net, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] w1 - fix fops in w1_bus_notify
Date: Sun, 06 Oct 2013 21:13:35 +0200
Message-ID: <49341335.BT4urmCfm2@maximilian>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc2-a64; KDE/4.11.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:SODU08V4puXOSWmVQmDkm6mUXRvg8eNzowd+hmyr5IJBjZJGePw
 c5sP36Klz3wni4Nh63BLl2I0OcLanChsA+1CHpXlopuAGH5ITrOtkeuiv5H+UFWulNqiy0N
 Nl0pxiWFj2cDFzrM3DQXALYkse1n1dVJnqllkvoogcb00Zw1PYgJoJtF8LD0BS9ljjQRHjA
 lFWMS9bL9fQgZF0JygvKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a check to make sure that fops are only called if they have been
defined by the slave module.
Without this check modules like w1_smem cause a NULL pointer
dereference bug.

Signed-off by: Hans-Frieder Vogt <hfvogt@gmx.net>
---
 drivers/w1/w1.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/w1/w1.c	2013-09-24 21:24:20.803261482 +0200
+++ b/drivers/w1/w1.c	2013-10-06 14:58:45.246528318 +0200
@@ -613,6 +613,9 @@ static int w1_bus_notify(struct notifier
 	sl = dev_to_w1_slave(dev);
 	fops = sl->family->fops;
 
+	if (!fops)
+		return 0;
+
 	switch (action) {
 	case BUS_NOTIFY_ADD_DEVICE:
 		/* if the family driver needs to initialize something... */

Hans-Frieder Vogt                       e-mail: hfvogt <at> gmx .dot. net

