Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbbA0Pvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 10:51:55 -0500
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:33014 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932305AbbA0Pun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 10:50:43 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] staging: comedi: comedi_compat32.c: reformat other block comments
Date: Tue, 27 Jan 2015 15:50:21 +0000
Message-Id: <1422373824-12793-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
References: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the usual block comment style.  Combine some consecutive comments
into block comments.  Also remove part of a comment referring to
`ptr_to_compat()` not being implemented until kernel version 2.6.11 as
it's irrelevant.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_compat32.c | 36 +++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/comedi_compat32.c b/drivers/staging/comedi/comedi_compat32.c
index 9364f08..c0d404c 100644
--- a/drivers/staging/comedi/comedi_compat32.c
+++ b/drivers/staging/comedi/comedi_compat32.c
@@ -27,11 +27,15 @@
 
 #define COMEDI32_CHANINFO _IOR(CIO, 3, struct comedi32_chaninfo_struct)
 #define COMEDI32_RANGEINFO _IOR(CIO, 8, struct comedi32_rangeinfo_struct)
-/* N.B. COMEDI32_CMD and COMEDI_CMD ought to use _IOWR, not _IOR.
- * It's too late to change it now, but it only affects the command number. */
+/*
+ * N.B. COMEDI32_CMD and COMEDI_CMD ought to use _IOWR, not _IOR.
+ * It's too late to change it now, but it only affects the command number.
+ */
 #define COMEDI32_CMD _IOR(CIO, 9, struct comedi32_cmd_struct)
-/* N.B. COMEDI32_CMDTEST and COMEDI_CMDTEST ought to use _IOWR, not _IOR.
- * It's too late to change it now, but it only affects the command number. */
+/*
+ * N.B. COMEDI32_CMDTEST and COMEDI_CMDTEST ought to use _IOWR, not _IOR.
+ * It's too late to change it now, but it only affects the command number.
+ */
 #define COMEDI32_CMDTEST _IOR(CIO, 10, struct comedi32_cmd_struct)
 #define COMEDI32_INSNLIST _IOR(CIO, 11, struct comedi32_insnlist_struct)
 #define COMEDI32_INSN _IOR(CIO, 12, struct comedi32_insn_struct)
@@ -215,10 +219,12 @@ static int put_compat_cmd(struct comedi32_cmd_struct __user *cmd32,
 	int err;
 	unsigned int temp;
 
-	/* Copy back most of cmd structure. */
-	/* Assume the pointer values are already valid. */
-	/* (Could use ptr_to_compat() to set them, but that wasn't implemented
-	 * until kernel version 2.6.11.) */
+	/*
+	 * Copy back most of cmd structure.
+	 *
+	 * Assume the pointer values are already valid.
+	 * (Could use ptr_to_compat() to set them.)
+	 */
 	if (!access_ok(VERIFY_READ, cmd, sizeof(*cmd)) ||
 	    !access_ok(VERIFY_WRITE, cmd32, sizeof(*cmd32)))
 		return -EFAULT;
@@ -404,8 +410,11 @@ static int compat_insn(struct file *file, unsigned long arg)
 	return translated_ioctl(file, COMEDI_INSN, (unsigned long)insn);
 }
 
-/* Process untranslated ioctl. */
-/* Returns -ENOIOCTLCMD for unrecognised ioctl codes. */
+/*
+ * Process untranslated ioctl.
+ *
+ * Returns -ENOIOCTLCMD for unrecognised ioctl codes.
+ */
 static inline int raw_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
 {
@@ -455,8 +464,11 @@ static inline int raw_ioctl(struct file *file, unsigned int cmd,
 	return rc;
 }
 
-/* compat_ioctl file operation. */
-/* Returns -ENOIOCTLCMD for unrecognised ioctl codes. */
+/*
+ * compat_ioctl file operation.
+ *
+ * Returns -ENOIOCTLCMD for unrecognised ioctl codes.
+ */
 long comedi_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	return raw_ioctl(file, cmd, arg);
-- 
2.1.4

