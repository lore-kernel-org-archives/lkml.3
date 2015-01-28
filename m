Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbbA2BN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:13:28 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53264 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbA2BN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:13:26 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bernd Porr <mail@berndporr.me.uk>,
        Chase Southwood <chase.southwood@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: comedi: drivers: usbduxsigma: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:39:01 +0100
Message-Id: <1422484741-9666-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/comedi/drivers/usbduxsigma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index dc19435..7b80887 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -215,7 +215,6 @@ static void usbduxsigma_ai_handle_urb(struct comedi_device *dev,
 	struct usbduxsigma_private *devpriv = dev->private;
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
-	unsigned int dio_state;
 	uint32_t val;
 	int ret;
 	int i;
@@ -225,7 +224,7 @@ static void usbduxsigma_ai_handle_urb(struct comedi_device *dev,
 		devpriv->ai_counter = devpriv->ai_timer;
 
 		/* get the state of the dio pins to allow external trigger */
-		dio_state = be32_to_cpu(devpriv->in_buf[0]);
+		be32_to_cpu(devpriv->in_buf[0]);
 
 		/* get the data from the USB bus and hand it over to comedi */
 		for (i = 0; i < cmd->chanlist_len; i++) {
-- 
1.7.10.4

