Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaIIKb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:31:58 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36268 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991AbaIIK1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:30 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 36/48] staging: comedi: ni_pcimio: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:45 +0100
Message-Id: <1410258417-28230-37-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/ni_pcimio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index da61fa7..3b2bdeb 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1082,7 +1082,7 @@ static void m_series_init_eeprom_buffer(struct comedi_device *dev)
 
 static void init_6143(struct comedi_device *dev)
 {
-	const struct ni_board_struct *board = comedi_board(dev);
+	const struct ni_board_struct *board = dev->board_ptr;
 	struct ni_private *devpriv = dev->private;
 
 	/*  Disable interrupts */
-- 
2.1.0

