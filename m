Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbbA2B2P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:28:15 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:54274 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbbA2B2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:28:11 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincenzo Scotti <vinc94@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Roberta Dobrescu <roberta.dobrescu@gmail.com>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>,
        Magnus Damm <damm+renesas@opensource.se>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: emxx_udc: emxx_udc: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:42:40 +0100
Message-Id: <1422484960-10266-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/emxx_udc/emxx_udc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
index eb178fc..b916fab 100644
--- a/drivers/staging/emxx_udc/emxx_udc.c
+++ b/drivers/staging/emxx_udc/emxx_udc.c
@@ -2974,10 +2974,10 @@ static int nbu2ss_ep_fifo_status(struct usb_ep *_ep)
 	spin_lock_irqsave(&udc->lock, flags);
 
 	if (ep->epnum == 0) {
-		data = _nbu2ss_readl(&preg->EP0_LENGTH) & EP0_LDATA;
+		_nbu2ss_readl(&preg->EP0_LENGTH) & EP0_LDATA;
 
 	} else {
-		data = _nbu2ss_readl(&preg->EP_REGS[ep->epnum-1].EP_LEN_DCNT)
+		_nbu2ss_readl(&preg->EP_REGS[ep->epnum-1].EP_LEN_DCNT)
 			& EPn_LDATA;
 	}
 
@@ -3264,12 +3264,11 @@ static void __init nbu2ss_drv_set_ep_info(
 	if (isdigit(name[2])) {
 
 		long	num;
-		int	res;
 		char	tempbuf[2];
 
 		tempbuf[0] = name[2];
 		tempbuf[1] = '\0';
-		res = kstrtol(tempbuf, 16, &num);
+		kstrtol(tempbuf, 16, &num);
 
 		if (num == 0)
 			ep->ep.maxpacket = EP0_PACKETSIZE;
-- 
1.7.10.4

