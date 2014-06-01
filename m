Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbaFANrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:47:21 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42049 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaFANrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:47:19 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: musb: musb_host.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:48:12 +0200
Message-Id: <1401630492-20161-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/usb/musb/musb_host.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index eb06291..3b11f98 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1957,7 +1957,7 @@ static int musb_schedule(
 	struct musb_qh		*qh,
 	int			is_in)
 {
-	int			idle;
+	int			idle = 0;
 	int			best_diff;
 	int			best_end, epnum;
 	struct musb_hw_ep	*hw_ep = NULL;
-- 
1.7.10.4

