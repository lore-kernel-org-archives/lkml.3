Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbaIIKe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:34:56 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36171 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501AbaIIK1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:24 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 30/48] staging: comedi: ni_at_ao: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:39 +0100
Message-Id: <1410258417-28230-31-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_at_ao.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index 7a60713..3e1ce58 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -319,7 +319,7 @@ static void atao_reset(struct comedi_device *dev)
 
 static int atao_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
-	const struct atao_board *board = comedi_board(dev);
+	const struct atao_board *board = dev->board_ptr;
 	struct atao_private *devpriv;
 	struct comedi_subdevice *s;
 	int ret;
-- 
2.1.0

