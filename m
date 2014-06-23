Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaFWIz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:55:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55501 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 043/111] staging: comedi: ni_daq_700: add mux settling delay
Date: Mon, 23 Jun 2014 10:31:18 +0200
Message-Id: <089768acf22bb5a9d5a255413e5fdac0ad15c6ea.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ffed54dced86723f352323f15789d9ad6bee25e1 upstream.

I got a patch from the original author, Fred Brooks, to add a small
settling delay after setting the AI channel multiplexor.  The lack of
delay resulted in unstable or scrambled data on faster processors.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Reported-by: Fred Brooks <nsaspook@nsaspook.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 404f83de276d..40ca2be1d9d2 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -118,6 +118,8 @@ static int daq700_ai_rinsn(struct comedi_device *dev,
 	/* write channel to multiplexer */
 	/* set mask scan bit high to disable scanning */
 	outb(chan | 0x80, dev->iobase + CMD_R1);
+	/* mux needs 2us to really settle [Fred Brooks]. */
+	udelay(2);
 
 	/* convert n samples */
 	for (n = 0; n < insn->n; n++) {
-- 
2.0.0

