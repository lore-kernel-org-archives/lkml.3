Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbaIIKlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:41:45 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36161 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756369AbaIIK1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:14 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/48] staging: comedi: aio_aio12_8: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:18 +0100
Message-Id: <1410258417-28230-10-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/aio_aio12_8.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/aio_aio12_8.c b/drivers/staging/comedi/drivers/aio_aio12_8.c
index 61cdd25..538277a 100644
--- a/drivers/staging/comedi/drivers/aio_aio12_8.c
+++ b/drivers/staging/comedi/drivers/aio_aio12_8.c
@@ -178,7 +178,7 @@ static const struct comedi_lrange range_aio_aio12_8 = {
 static int aio_aio12_8_attach(struct comedi_device *dev,
 			      struct comedi_devconfig *it)
 {
-	const struct aio12_8_boardtype *board = comedi_board(dev);
+	const struct aio12_8_boardtype *board = dev->board_ptr;
 	struct comedi_subdevice *s;
 	int ret;
 
-- 
2.1.0

