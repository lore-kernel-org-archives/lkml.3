Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaIOMrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 08:47:10 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:34915 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbaIOMq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:46:29 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/11] staging: comedi: comedi_fc.h: use comedi_write_array_to_buffer()
Date: Mon, 15 Sep 2014 13:46:04 +0100
Message-Id: <1410785167-28506-9-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
References: <1410785167-28506-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since `cfc_write_array_to_buffer()` is just an inline function that
calls `comedi_write_array_to_buffer()`, replace calls to the former to
the latter in the "comedi_fc.h" header.  This is part of the migration
of functionality from the "comedi_fc" module to the core "comedi"
module.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_buf.c        | 13 ++++++++++++-
 drivers/staging/comedi/drivers/comedi_fc.h |  4 ++--
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/comedi_buf.c b/drivers/staging/comedi/comedi_buf.c
index 5aa8684..52a75d2 100644
--- a/drivers/staging/comedi/comedi_buf.c
+++ b/drivers/staging/comedi/comedi_buf.c
@@ -510,7 +510,18 @@ void comedi_buf_memcpy_from(struct comedi_subdevice *s, unsigned int offset,
 }
 EXPORT_SYMBOL_GPL(comedi_buf_memcpy_from);
 
-/* Writes an array of data points to comedi's buffer */
+/**
+ * comedi_write_array_to_buffer - write data to comedi buffer
+ * @s: comedi_subdevice struct
+ * @data: destination
+ * @num_bytes: number of bytes to write
+ *
+ * Writes up to num_bytes bytes of data to the comedi buffer associated with
+ * the subdevice, marks it as written and updates the acquisition scan
+ * progress.
+ *
+ * Returns the amount of data written in bytes.
+ */
 unsigned int comedi_write_array_to_buffer(struct comedi_subdevice *s,
 					  const void *data,
 					  unsigned int num_bytes)
diff --git a/drivers/staging/comedi/drivers/comedi_fc.h b/drivers/staging/comedi/drivers/comedi_fc.h
index 51b3157..75bbc31 100644
--- a/drivers/staging/comedi/drivers/comedi_fc.h
+++ b/drivers/staging/comedi/drivers/comedi_fc.h
@@ -44,13 +44,13 @@ static inline unsigned int cfc_write_array_to_buffer(struct comedi_subdevice *s,
 static inline unsigned int cfc_write_to_buffer(struct comedi_subdevice *s,
 					       unsigned short data)
 {
-	return cfc_write_array_to_buffer(s, &data, sizeof(data));
+	return comedi_write_array_to_buffer(s, &data, sizeof(data));
 };
 
 static inline unsigned int cfc_write_long_to_buffer(struct comedi_subdevice *s,
 						    unsigned int data)
 {
-	return cfc_write_array_to_buffer(s, &data, sizeof(data));
+	return comedi_write_array_to_buffer(s, &data, sizeof(data));
 };
 
 unsigned int cfc_read_array_from_buffer(struct comedi_subdevice *,
-- 
2.1.0

