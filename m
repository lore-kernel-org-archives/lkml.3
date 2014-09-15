Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaIOMqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:46:30 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34915 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbaIOMqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:46:25 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] staging: comedi: comedi_fc: cfc_write_array_to_buffer() data is const
Date: Mon, 15 Sep 2014 13:46:02 +0100
Message-Id: <1410785167-28506-7-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The `data` pointer of `cfc_write_array_to_buffer()` ought to point to
`const` data.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/comedi_fc.c | 2 +-
 drivers/staging/comedi/drivers/comedi_fc.h | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/comedi_fc.c b/drivers/staging/comedi/drivers/comedi_fc.c
index ed0e79f..6f87220 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.c
+++ b/drivers/staging/comedi/drivers/comedi_fc.c
@@ -24,7 +24,7 @@
 
 /* Writes an array of data points to comedi's buffer */
 unsigned int cfc_write_array_to_buffer(struct comedi_subdevice *s,
-				       void *data, unsigned int num_bytes)
+				       const void *data, unsigned int num_bytes)
 {
 	struct comedi_async *async = s->async;
 	unsigned int retval;
diff --git a/drivers/staging/comedi/drivers/comedi_fc.h b/drivers/staging/comedi/drivers/comedi_fc.h
index c570c6eb..fa3de9e 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.h
+++ b/drivers/staging/comedi/drivers/comedi_fc.h
@@ -35,8 +35,9 @@ static inline void cfc_inc_scan_progress(struct comedi_subdevice *s,
 }
 
 /* Writes an array of data points to comedi's buffer */
-unsigned int cfc_write_array_to_buffer(struct comedi_subdevice *,
-				       void *data, unsigned int num_bytes);
+unsigned int cfc_write_array_to_buffer(struct comedi_subdevice *s,
+				       const void *data,
+				       unsigned int num_bytes);
 
 static inline unsigned int cfc_write_to_buffer(struct comedi_subdevice *s,
 					       unsigned short data)
-- 
2.1.0

