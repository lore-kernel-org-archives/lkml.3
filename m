Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbbA2BZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:25:14 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49165 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbA2BZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:09 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: dyna_pci10xx: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:35:07 +0100
Message-Id: <1422484507-8925-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 1b6324c..8882423 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -115,10 +115,9 @@ static int dyna_pci10xx_insn_write_ao(struct comedi_device *dev,
 {
 	struct dyna_pci10xx_private *devpriv = dev->private;
 	int n;
-	unsigned int chan, range;
 
-	chan = CR_CHAN(insn->chanspec);
-	range = range_codes_pci1050_ai[CR_RANGE((insn->chanspec))];
+	CR_CHAN(insn->chanspec);
+	range_codes_pci1050_ai[CR_RANGE((insn->chanspec))];
 
 	mutex_lock(&devpriv->mutex);
 	for (n = 0; n < insn->n; n++) {
-- 
1.7.10.4

