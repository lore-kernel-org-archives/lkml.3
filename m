Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576AbaGaNvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:51:47 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57872 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbaGaNsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:48:12 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/18] staging: comedi: amplc_pci224: no need for '&function'
Date: Thu, 31 Jul 2014 14:47:48 +0100
Message-Id: <1406814475-5923-12-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
References: <1406814475-5923-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the "address-of" operator when the operand is a function.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci224.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci224.c b/drivers/staging/comedi/drivers/amplc_pci224.c
index 68fc407..b8b86ab 100644
--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1173,15 +1173,14 @@ static int pci224_attach_common(struct comedi_device *dev,
 	s->subdev_flags = SDF_WRITABLE | SDF_GROUND | SDF_CMD_WRITE;
 	s->n_chan = thisboard->ao_chans;
 	s->maxdata = (1 << thisboard->ao_bits) - 1;
-	s->insn_write = &pci224_ao_insn_write;
-	s->insn_read = &pci224_ao_insn_read;
+	s->insn_write = pci224_ao_insn_write;
+	s->insn_read = pci224_ao_insn_read;
 	s->len_chanlist = s->n_chan;
-
 	dev->write_subdev = s;
-	s->do_cmd = &pci224_ao_cmd;
-	s->do_cmdtest = &pci224_ao_cmdtest;
-	s->cancel = &pci224_ao_cancel;
-	s->munge = &pci224_ao_munge;
+	s->do_cmd = pci224_ao_cmd;
+	s->do_cmdtest = pci224_ao_cmdtest;
+	s->cancel = pci224_ao_cancel;
+	s->munge = pci224_ao_munge;
 
 	/* Sort out channel range options. */
 	if (thisboard->model == pci234_model) {
-- 
2.0.0

