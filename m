Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934328AbaFIW4j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:56:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934249AbaFIWqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:46:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>, Fred Brooks <nsaspook@nsaspook.com>
Subject: [PATCH 3.10 25/40] staging: comedi: ni_daq_700: add mux settling delay
Date: Mon,  9 Jun 2014 15:48:56 -0700
Message-Id: <20140609224839.996295741@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
References: <20140609224839.127615063@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit ffed54dced86723f352323f15789d9ad6bee25e1 upstream.

I got a patch from the original author, Fred Brooks, to add a small
settling delay after setting the AI channel multiplexor.  The lack of
delay resulted in unstable or scrambled data on faster processors.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Reported-by: Fred Brooks <nsaspook@nsaspook.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/ni_daq_700.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -127,6 +127,8 @@ static int daq700_ai_rinsn(struct comedi
 	/* write channel to multiplexer */
 	/* set mask scan bit high to disable scanning */
 	outb(chan | 0x80, dev->iobase + CMD_R1);
+	/* mux needs 2us to really settle [Fred Brooks]. */
+	udelay(2);
 
 	/* convert n samples */
 	for (n = 0; n < insn->n; n++) {


