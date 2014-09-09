Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbaIIK13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:29 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36167 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbaIIK1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:17 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/48] staging: comedi: das08_isa: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:26 +0100
Message-Id: <1410258417-28230-18-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/das08_isa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/das08_isa.c b/drivers/staging/comedi/drivers/das08_isa.c
index 4fb03d3..e4ba268 100644
--- a/drivers/staging/comedi/drivers/das08_isa.c
+++ b/drivers/staging/comedi/drivers/das08_isa.c
@@ -174,7 +174,7 @@ static const struct das08_board_struct das08_isa_boards[] = {
 static int das08_isa_attach(struct comedi_device *dev,
 			    struct comedi_devconfig *it)
 {
-	const struct das08_board_struct *thisboard = comedi_board(dev);
+	const struct das08_board_struct *thisboard = dev->board_ptr;
 	struct das08_private_struct *devpriv;
 	int ret;
 
-- 
2.1.0

