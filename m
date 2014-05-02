Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaEBO5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 10:57:30 -0400
Received: from fallback1.mail.ru ([94.100.176.18]:59272 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaEBO53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 10:57:29 -0400
From: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        linux-kernel@vger.kernel.org,
        Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
Subject: [PATCH] staging/comedi: fix sparse warning: shift too big
Date: Fri,  2 May 2014 18:57:04 +0400
Message-Id: <1399042624-9441-1-git-send-email-brilliantov@inbox.ru>
X-Mailer: git-send-email 1.9.1
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brilliantov Kirill Vladimirovich <brilliantov@inbox.ru>
---
 drivers/staging/comedi/drivers/ni_stc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
index f0630b78..197b568 100644
--- a/drivers/staging/comedi/drivers/ni_stc.h
+++ b/drivers/staging/comedi/drivers/ni_stc.h
@@ -717,7 +717,7 @@ enum AI_AO_Select_Bits {
 static inline unsigned ni_stc_dma_channel_select_bitfield(unsigned channel)
 {
 	if (channel < 4)
-		return 1 << channel;
+		return 1 << (channel & 0x3);
 	if (channel == 4)
 		return 0x3;
 	if (channel == 5)
-- 
1.9.1

