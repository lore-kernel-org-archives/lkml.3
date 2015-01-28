Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbbA2BTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:19:42 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43749 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbbA2BSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:18:51 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: ni_mio_cs: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:37:40 +0100
Message-Id: <1422484660-9399-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/comedi/drivers/ni_mio_cs.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_mio_cs.c b/drivers/staging/comedi/drivers/ni_mio_cs.c
index 9b201e4..b152330 100644
--- a/drivers/staging/comedi/drivers/ni_mio_cs.c
+++ b/drivers/staging/comedi/drivers/ni_mio_cs.c
@@ -163,7 +163,6 @@ static int mio_cs_auto_attach(struct comedi_device *dev,
 {
 	struct pcmcia_device *link = comedi_to_pcmcia_dev(dev);
 	static const struct ni_board_struct *board;
-	struct ni_private *devpriv;
 	int ret;
 
 	board = ni_getboardtype(dev, link);
@@ -188,8 +187,6 @@ static int mio_cs_auto_attach(struct comedi_device *dev,
 	if (ret)
 		return ret;
 
-	devpriv = dev->private;
-
 	return ni_E_init(dev, 0, 1);
 }
 
-- 
1.7.10.4

