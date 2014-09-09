Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbaIIKgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:36:36 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36217 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756485AbaIIK1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:22 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 26/48] staging: comedi: me4000: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:35 +0100
Message-Id: <1410258417-28230-27-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
References: <1410258417-28230-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `comedi_board(dev)` inline function calls just return
`dev->board_ptr`.  Expand the inline function calls.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/me4000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 3b0df6b..e600ce8 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -471,7 +471,7 @@ static int me4000_ai_insn_read(struct comedi_device *dev,
 			       struct comedi_subdevice *subdevice,
 			       struct comedi_insn *insn, unsigned int *data)
 {
-	const struct me4000_board *thisboard = comedi_board(dev);
+	const struct me4000_board *thisboard = dev->board_ptr;
 	int chan = CR_CHAN(insn->chanspec);
 	int rang = CR_RANGE(insn->chanspec);
 	int aref = CR_AREF(insn->chanspec);
@@ -599,7 +599,7 @@ static int me4000_ai_check_chanlist(struct comedi_device *dev,
 				    struct comedi_subdevice *s,
 				    struct comedi_cmd *cmd)
 {
-	const struct me4000_board *board = comedi_board(dev);
+	const struct me4000_board *board = dev->board_ptr;
 	unsigned int max_diff_chan = board->ai_diff_nchan;
 	unsigned int aref0 = CR_AREF(cmd->chanlist[0]);
 	int i;
-- 
2.1.0

