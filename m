Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbbA0Puv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:50:51 -0500
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:53526 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932371AbbA0Pup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:50:45 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/7] staging: comedi: comedi_compat32.c: absorb raw_ioctl()
Date: Tue, 27 Jan 2015 15:50:23 +0000
Message-Id: <1422373824-12793-7-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
References: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`comedi_compat_ioctl()` just calls static inline function `raw_ioctl()`
with the same parameters (although the former returns a `long` and the
latter returns an `int`).  Since `raw_ioctl()` is not called from
anywhere else, just absorb its body into `comedi_compat_ioctl()`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_compat32.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/comedi_compat32.c b/drivers/staging/comedi/comedi_compat32.c
index 88a784f..24078b9 100644
--- a/drivers/staging/comedi/comedi_compat32.c
+++ b/drivers/staging/comedi/comedi_compat32.c
@@ -411,12 +411,11 @@ static int compat_insn(struct file *file, unsigned long arg)
 }
 
 /*
- * Process untranslated ioctl.
+ * compat_ioctl file operation.
  *
  * Returns -ENOIOCTLCMD for unrecognised ioctl codes.
  */
-static inline int raw_ioctl(struct file *file, unsigned int cmd,
-			    unsigned long arg)
+long comedi_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int rc;
 
@@ -463,13 +462,3 @@ static inline int raw_ioctl(struct file *file, unsigned int cmd,
 	}
 	return rc;
 }
-
-/*
- * compat_ioctl file operation.
- *
- * Returns -ENOIOCTLCMD for unrecognised ioctl codes.
- */
-long comedi_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-{
-	return raw_ioctl(file, cmd, arg);
-}
-- 
2.1.4

