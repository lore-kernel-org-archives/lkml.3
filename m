Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbaIIK1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:42 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36316 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756521AbaIIK1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:40 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 46/48] staging: comedi: rtd520: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:55 +0100
Message-Id: <1410258417-28230-47-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/rtd520.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 2ea4a5c..f0bf3ed 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -437,7 +437,7 @@ static int rtd_ns_to_timer(unsigned int *ns, unsigned int flags)
 static unsigned short rtd_convert_chan_gain(struct comedi_device *dev,
 					    unsigned int chanspec, int index)
 {
-	const struct rtd_boardinfo *board = comedi_board(dev);
+	const struct rtd_boardinfo *board = dev->board_ptr;
 	struct rtd_private *devpriv = dev->private;
 	unsigned int chan = CR_CHAN(chanspec);
 	unsigned int range = CR_RANGE(chanspec);
-- 
2.1.0

