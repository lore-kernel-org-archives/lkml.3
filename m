Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbaHGWSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 18:18:13 -0400
Received: from mailrelay.sea-ab.se ([91.223.232.53]:40268 "EHLO
	mailrelay.sea-ab.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaHGWSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 18:18:12 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2014 18:18:12 EDT
Date: Thu, 7 Aug 2014 23:08:34 +0100
From: Martin Berglund <martin@rogsta.net>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guido =?iso-8859-1?Q?Mart=EDnez?= <guido@vanguardiasur.com.ar>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: wpactl.c: Fix sparse warnings
Message-ID: <20140807220834.GA21645@licorice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing __user macro casting in the function wpa_set_keys.
This is okay since the function handles the possibility of
param->u.wpa_key.key and param->u.wpa_key.seq pointing to
kernelspace using a flag, fcpfkernel.

Signed-off-by: Martin Berglund <martin@rogsta.net>
---
This was submitted as part of Eudyptula challenge task 16

 drivers/staging/vt6655/wpactl.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
index 5f454ca..d75dd79 100644
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -224,7 +224,9 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
 	} else {
 		spin_unlock_irq(&pDevice->lock);
 		if (param->u.wpa_key.key &&
-		    copy_from_user(&abyKey[0], param->u.wpa_key.key, param->u.wpa_key.key_len)) {
+		    copy_from_user(&abyKey[0],
+				   (void __user *)param->u.wpa_key.key,
+				   param->u.wpa_key.key_len)) {
 			spin_lock_irq(&pDevice->lock);
 			return -EINVAL;
 		}
@@ -262,7 +264,9 @@ int wpa_set_keys(PSDevice pDevice, void *ctx,
 	} else {
 		spin_unlock_irq(&pDevice->lock);
 		if (param->u.wpa_key.seq &&
-		    copy_from_user(&abySeq[0], param->u.wpa_key.seq, param->u.wpa_key.seq_len)) {
+		    copy_from_user(&abySeq[0],
+				   (void __user *)param->u.wpa_key.seq,
+				   param->u.wpa_key.seq_len)) {
 			spin_lock_irq(&pDevice->lock);
 			return -EINVAL;
 		}
-- 
1.7.10.4

