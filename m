Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaIOMqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:46:25 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34915 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbaIOMqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:46:24 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] staging: comedi: comedi_fc: use comedi_inc_scan_progress()
Date: Mon, 15 Sep 2014 13:46:00 +0100
Message-Id: <1410785167-28506-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since `cfc_inc_scan_progress()` is just an inline function that calls
`comedi_inc_scan_progress()`, replace calls to the former to the latter
in the "comedi_fc" module.  This is part of the migration of
functionality from the "comedi_fc" module to the core "comedi" module.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/comedi_fc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_fc.c b/drivers/staging/comedi/drivers/comedi_fc.c
index 8a4abe8..7401e78 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.c
+++ b/drivers/staging/comedi/drivers/comedi_fc.c
@@ -41,7 +41,7 @@ unsigned int cfc_write_array_to_buffer(struct comedi_subdevice *s,
 
 	comedi_buf_memcpy_to(s, 0, data, num_bytes);
 	comedi_buf_write_free(s, num_bytes);
-	cfc_inc_scan_progress(s, num_bytes);
+	comedi_inc_scan_progress(s, num_bytes);
 	async->events |= COMEDI_CB_BLOCK;
 
 	return num_bytes;
@@ -57,7 +57,7 @@ unsigned int cfc_read_array_from_buffer(struct comedi_subdevice *s,
 	num_bytes = comedi_buf_read_alloc(s, num_bytes);
 	comedi_buf_memcpy_from(s, 0, data, num_bytes);
 	comedi_buf_read_free(s, num_bytes);
-	cfc_inc_scan_progress(s, num_bytes);
+	comedi_inc_scan_progress(s, num_bytes);
 	s->async->events |= COMEDI_CB_BLOCK;
 
 	return num_bytes;
-- 
2.1.0

