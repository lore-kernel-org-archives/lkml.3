Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761960AbbA2C3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:29:42 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:55929 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbbA2C3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:29:39 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Heena Sirwani <heenasirwani@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: mite: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:36:24 +0100
Message-Id: <1422484584-9164-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/comedi/drivers/mite.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/mite.c b/drivers/staging/comedi/drivers/mite.c
index ffc9e61..8d2903b 100644
--- a/drivers/staging/comedi/drivers/mite.c
+++ b/drivers/staging/comedi/drivers/mite.c
@@ -494,9 +494,8 @@ EXPORT_SYMBOL_GPL(mite_bytes_read_from_memory_ub);
 unsigned mite_dma_tcr(struct mite_channel *mite_chan)
 {
 	struct mite_struct *mite = mite_chan->mite;
-	int lkar;
 
-	lkar = readl(mite->mite_io_addr + MITE_LKAR(mite_chan->channel));
+	readl(mite->mite_io_addr + MITE_LKAR(mite_chan->channel));
 	return readl(mite->mite_io_addr + MITE_TCR(mite_chan->channel));
 }
 EXPORT_SYMBOL_GPL(mite_dma_tcr);
-- 
1.7.10.4

