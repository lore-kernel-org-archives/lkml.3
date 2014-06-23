Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbaFWNNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:13:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37169 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798AbaFWNFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:05:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 75/93] staging: comedi: ni_daq_700: add mux settling delay
Date: Mon, 23 Jun 2014 14:02:54 +0100
Message-Id: <1403528592-2163-76-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
References: <1403528592-2163-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit ffed54dced86723f352323f15789d9ad6bee25e1 upstream.

I got a patch from the original author, Fred Brooks, to add a small
settling delay after setting the AI channel multiplexor.  The lack of
delay resulted in unstable or scrambled data on faster processors.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Reported-by: Fred Brooks <nsaspook@nsaspook.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/comedi/drivers/ni_daq_700.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 3c50e31ecc60..55d2c86c9e15 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -122,6 +122,8 @@ static int daq700_ai_rinsn(struct comedi_device *dev,
 	/* write channel to multiplexer */
 	/* set mask scan bit high to disable scanning */
 	outb(chan | 0x80, dev->iobase + CMD_R1);
+	/* mux needs 2us to really settle [Fred Brooks]. */
+	udelay(2);
 
 	/* convert n samples */
 	for (n = 0; n < insn->n; n++) {
-- 
1.9.1

