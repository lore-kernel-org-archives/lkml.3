Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbaIIKdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:33:49 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36161 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526AbaIIK10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:26 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 34/48] staging: comedi: ni_labpc_isadma: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:43 +0100
Message-Id: <1410258417-28230-35-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_labpc_isadma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_labpc_isadma.c b/drivers/staging/comedi/drivers/ni_labpc_isadma.c
index cb7d1c9..967202e 100644
--- a/drivers/staging/comedi/drivers/ni_labpc_isadma.c
+++ b/drivers/staging/comedi/drivers/ni_labpc_isadma.c
@@ -152,7 +152,7 @@ static void handle_isa_dma(struct comedi_device *dev)
 
 void labpc_handle_dma_status(struct comedi_device *dev)
 {
-	const struct labpc_boardinfo *board = comedi_board(dev);
+	const struct labpc_boardinfo *board = dev->board_ptr;
 	struct labpc_private *devpriv = dev->private;
 
 	/*
-- 
2.1.0

