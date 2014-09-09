Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbaIIKhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:37:11 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36163 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756310AbaIIK1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:21 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 24/48] staging: comedi: dt282x: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:33 +0100
Message-Id: <1410258417-28230-25-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/dt282x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 4017fcb..e725e3b 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -681,7 +681,7 @@ static int dt282x_ai_cmdtest(struct comedi_device *dev,
 			     struct comedi_subdevice *s,
 			     struct comedi_cmd *cmd)
 {
-	const struct dt282x_board *board = comedi_board(dev);
+	const struct dt282x_board *board = dev->board_ptr;
 	struct dt282x_private *devpriv = dev->private;
 	int err = 0;
 	unsigned int arg;
@@ -1149,7 +1149,7 @@ static int dt282x_initialize(struct comedi_device *dev)
  */
 static int dt282x_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	const struct dt282x_board *board = comedi_board(dev);
+	const struct dt282x_board *board = dev->board_ptr;
 	struct dt282x_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
-- 
2.1.0

