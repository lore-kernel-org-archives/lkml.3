Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaHSPG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:06:59 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:58342 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbaHSPG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:06:56 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] staging: comedi: ni_labpc: break lines after operators
Date: Tue, 19 Aug 2014 16:06:32 +0100
Message-Id: <1408460793-29793-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1408460793-29793-1-git-send-email-abbotti@mev.co.uk>
References: <1408460793-29793-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For consistency, break lines before operators, not after.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/ni_labpc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index f551a3b..ccf5ce8 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -720,9 +720,9 @@ static int labpc_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 	struct comedi_async *async = s->async;
 	struct comedi_cmd *cmd = &async->cmd;
 	enum scan_mode mode = labpc_ai_scan_mode(cmd);
-	unsigned int chanspec = (mode == MODE_MULT_CHAN_UP)
-				? cmd->chanlist[cmd->chanlist_len - 1]
-				: cmd->chanlist[0];
+	unsigned int chanspec = (mode == MODE_MULT_CHAN_UP) ?
+				cmd->chanlist[cmd->chanlist_len - 1] :
+				cmd->chanlist[0];
 	unsigned int chan = CR_CHAN(chanspec);
 	unsigned int range = CR_RANGE(chanspec);
 	unsigned int aref = CR_AREF(chanspec);
@@ -1353,8 +1353,8 @@ int labpc_common_attach(struct comedi_device *dev,
 	s->n_chan	= 8;
 	s->len_chanlist	= 8;
 	s->maxdata	= 0x0fff;
-	s->range_table	= board->is_labpc1200
-				? &range_labpc_1200_ai : &range_labpc_plus_ai;
+	s->range_table	= board->is_labpc1200 ?
+			  &range_labpc_1200_ai : &range_labpc_plus_ai;
 	s->insn_read	= labpc_ai_insn_read;
 	if (dev->irq) {
 		dev->read_subdev = s;
-- 
2.0.4

