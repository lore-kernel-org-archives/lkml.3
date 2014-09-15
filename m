Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaIOMso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:48:44 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34909 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbaIOMqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:46:23 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] staging: comedi: comedi_fc: use comedi_bytes_per_scan()
Date: Mon, 15 Sep 2014 13:45:58 +0100
Message-Id: <1410785167-28506-3-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since `cfc_bytes_per_scan()` is just an inline function that calls
`comedi_bytes_per_scan()`, replace calls to the former to the latter in
the "comedi_fc" module.  This is part of the migration of functionality
from the "comedi_fc" module to the core "comedi" module.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/comedi_fc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/comedi_fc.c b/drivers/staging/comedi/drivers/comedi_fc.c
index 407ec70..72fa718 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.c
+++ b/drivers/staging/comedi/drivers/comedi_fc.c
@@ -25,7 +25,7 @@
 void cfc_inc_scan_progress(struct comedi_subdevice *s, unsigned int num_bytes)
 {
 	struct comedi_async *async = s->async;
-	unsigned int scan_length = cfc_bytes_per_scan(s);
+	unsigned int scan_length = comedi_bytes_per_scan(s);
 
 	async->scan_progress += num_bytes;
 	if (async->scan_progress >= scan_length) {
-- 
2.1.0

