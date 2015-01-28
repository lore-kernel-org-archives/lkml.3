Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459AbbA2BWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:22:39 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:54100 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbbA2BWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:22:33 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: dt2815: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:34:29 +0100
Message-Id: <1422484469-8807-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/comedi/drivers/dt2815.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt2815.c b/drivers/staging/comedi/drivers/dt2815.c
index a98fb66..c5c0490 100644
--- a/drivers/staging/comedi/drivers/dt2815.c
+++ b/drivers/staging/comedi/drivers/dt2815.c
@@ -98,12 +98,11 @@ static int dt2815_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct dt2815_private *devpriv = dev->private;
 	int i;
 	int chan = CR_CHAN(insn->chanspec);
-	unsigned int lo, hi;
+	unsigned int lo;
 	int ret;
 
 	for (i = 0; i < insn->n; i++) {
 		lo = ((data[i] & 0x0f) << 4) | (chan << 1) | 0x01;
-		hi = (data[i] & 0xff0) >> 4;
 
 		ret = comedi_timeout(dev, s, insn, dt2815_ao_status, 0x00);
 		if (ret)
-- 
1.7.10.4

