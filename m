Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaIIK1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:27:35 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:36171 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470AbaIIK1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:27:21 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 25/48] staging: comedi: dt3000: replace comedi_board() calls
Date: Tue,  9 Sep 2014 11:26:34 +0100
Message-Id: <1410258417-28230-26-git-send-email-abbotti@mev.co.uk>
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
 drivers/staging/comedi/drivers/dt3000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 0abe64a..8255610 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -405,7 +405,7 @@ static int dt3k_ns_to_timer(unsigned int timer_base, unsigned int *nanosec,
 static int dt3k_ai_cmdtest(struct comedi_device *dev,
 			   struct comedi_subdevice *s, struct comedi_cmd *cmd)
 {
-	const struct dt3k_boardtype *this_board = comedi_board(dev);
+	const struct dt3k_boardtype *this_board = dev->board_ptr;
 	int err = 0;
 	unsigned int arg;
 
-- 
2.1.0

