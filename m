Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbaESKz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:55:28 -0400
Received: from mx02.posteo.de ([89.146.194.165]:35081 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754001AbaESKzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:55:25 -0400
From: Martin Kepplinger <martink@posteo.de>
To: gregkh@linuxfoundation.org
Cc: pavel@ucw.cz, dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH][RESEND] staging: winbond: use dev_err() instead of printk()
Date: Mon, 19 May 2014 12:55:11 +0200
Message-Id: <1400496911-11658-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140509082131.GA21616@Nokia-N900>
References: <20140509082131.GA21616@Nokia-N900>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For obvious error messages, use dev_err() in order to provide userspace
with more useful information and use the common kernel coding style.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
i just waited a week or so. this applies to next-20140516.

greetings from Linuxdays Vienna, Austria

 drivers/staging/winbond/wb35tx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 708c5b0..870cff3 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -49,7 +49,7 @@ static void Wb35Tx_complete(struct urb *pUrb)
 
 	/* The URB is completed, check the result */
 	if (pWb35Tx->EP4VM_status != 0) {
-		printk("URB submission failed\n");
+		dev_err(&pUrb->dev->dev, "URB submission failed\n");
 		pWb35Tx->EP4vm_state = VM_STOP;
 		goto error;
 	}
@@ -96,7 +96,7 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 	pWb35Tx->EP4vm_state = VM_RUNNING;
 	retv = usb_submit_urb(pUrb, GFP_ATOMIC);
 	if (retv < 0) {
-		printk("EP4 Tx Irp sending error\n");
+		dev_err(&pUrb->dev->dev, "EP4 Tx Irp sending error\n");
 		goto cleanup;
 	}
 
@@ -218,7 +218,7 @@ static void Wb35Tx_EP2VM_complete(struct urb *pUrb)
 
 	/* The Urb is completed, check the result */
 	if (pWb35Tx->EP2VM_status != 0) {
-		printk("EP2 IoCompleteRoutine return error\n");
+		dev_err(&pUrb->dev->dev, "EP2 IoCompleteRoutine return error\n");
 		pWb35Tx->EP2vm_state = VM_STOP;
 		goto error;
 	}
-- 
1.7.10.4

