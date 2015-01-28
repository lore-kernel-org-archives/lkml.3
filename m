Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbbA2BRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:17:33 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:64202 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbbA2BRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:17:23 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: ni_atmio: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:37:01 +0100
Message-Id: <1422484622-9282-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/comedi/drivers/ni_atmio.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_atmio.c b/drivers/staging/comedi/drivers/ni_atmio.c
index 0c5ff28..301f154 100644
--- a/drivers/staging/comedi/drivers/ni_atmio.c
+++ b/drivers/staging/comedi/drivers/ni_atmio.c
@@ -300,7 +300,6 @@ static int ni_atmio_attach(struct comedi_device *dev,
 			   struct comedi_devconfig *it)
 {
 	const struct ni_board_struct *boardtype;
-	struct ni_private *devpriv;
 	struct pnp_dev *isapnp_dev;
 	int ret;
 	unsigned long iobase;
@@ -310,7 +309,6 @@ static int ni_atmio_attach(struct comedi_device *dev,
 	ret = ni_alloc_private(dev);
 	if (ret)
 		return ret;
-	devpriv = dev->private;
 
 	iobase = it->options[0];
 	irq = it->options[1];
-- 
1.7.10.4

