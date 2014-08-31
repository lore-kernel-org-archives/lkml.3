Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954AbaHaToz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 15:44:55 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63349 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaHaToy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 15:44:54 -0400
From: Chase Southwood <chase.southwood@gmail.com>
To: gregkh@linuxfoundation.org
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chase Southwood <chase.southwood@gmail.com>
Subject: [PATCH] staging: comedi: usbdux: fix more sparse endianness warnings
Date: Sun, 31 Aug 2014 14:44:23 -0500
Message-Id: <1409514263-15251-1-git-send-email-chase.southwood@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse shows a couple of warnings like:

drivers/staging/comedi/drivers/usbdux.c:889:20: warning: incorrect type in assignment (different base types)
drivers/staging/comedi/drivers/usbdux.c:889:20:    expected unsigned short [unsigned] [short] [usertype] <noident>
drivers/staging/comedi/drivers/usbdux.c:889:20:    got restricted __le16 [usertype] <noident>

This is the result of a couple of calls to cpu_to_le16() being assigned to
uint16_t typed variables.  Switch the types of these variables/pointers to
__le16 accordingly.

Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
Suggested-by: Ian Abbott <abbotti@mev.co.uk>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
---

 drivers/staging/comedi/drivers/usbdux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 86c2c27..8eb2742 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -868,7 +868,7 @@ static int usbdux_ao_insn_write(struct comedi_device *dev,
 	struct usbdux_private *devpriv = dev->private;
 	unsigned int chan = CR_CHAN(insn->chanspec);
 	unsigned int val = s->readback[chan];
-	uint16_t *p = (uint16_t *)&devpriv->dux_commands[2];
+	__le16 *p = (__le16 *)&devpriv->dux_commands[2];
 	int ret = -EBUSY;
 	int i;
 
@@ -1180,7 +1180,7 @@ static int usbdux_counter_write(struct comedi_device *dev,
 {
 	struct usbdux_private *devpriv = dev->private;
 	unsigned int chan = CR_CHAN(insn->chanspec);
-	uint16_t *p = (uint16_t *)&devpriv->dux_commands[2];
+	__le16 *p = (__le16 *)&devpriv->dux_commands[2];
 	int ret = 0;
 	int i;
 
-- 
2.1.0

