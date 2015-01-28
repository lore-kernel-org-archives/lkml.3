Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbbA2BO0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:14:26 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52136 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbbA2BOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:14:23 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgnc: dgnc_cls: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:40:56 +0100
Message-Id: <1422484856-10031-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/dgnc/dgnc_cls.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_cls.c b/drivers/staging/dgnc/dgnc_cls.c
index bedc522..5fec747 100644
--- a/drivers/staging/dgnc/dgnc_cls.c
+++ b/drivers/staging/dgnc/dgnc_cls.c
@@ -893,10 +893,8 @@ static void cls_copy_data_from_uart_to_queue(struct channel_t *ch)
 		 * Discard character if we are ignoring the error mask.
 		*/
 		if (linestatus & error_mask)  {
-			unsigned char discard;
-
 			linestatus = 0;
-			discard = readb(&ch->ch_cls_uart->txrx);
+			readb(&ch->ch_cls_uart->txrx);
 			continue;
 		}
 
-- 
1.7.10.4

