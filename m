Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbbA2BwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:52:12 -0500
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:49016 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932973AbbA2BwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:52:07 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 6/6] staging: comedi: comedi_fops.c: reformat remaining block comments
Date: Wed, 28 Jan 2015 18:41:50 +0000
Message-Id: <1422470510-9309-7-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
References: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reformat remaining block comments to use the usual block comment style.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 5403af1..727640e 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -347,8 +347,7 @@ static int resize_async_buffer(struct comedi_device *dev,
 		return -EBUSY;
 	}
 
-	/* make sure buffer is an integral number of pages
-	 * (we round up) */
+	/* make sure buffer is an integral number of pages (we round up) */
 	new_size = (new_size + PAGE_SIZE - 1) & PAGE_MASK;
 
 	retval = comedi_buf_alloc(dev, s, new_size);
@@ -671,7 +670,7 @@ void *comedi_alloc_spriv(struct comedi_subdevice *s, size_t size)
 EXPORT_SYMBOL_GPL(comedi_alloc_spriv);
 
 /*
-   This function restores a subdevice to an idle state.
+ * This function restores a subdevice to an idle state.
  */
 static void do_become_nonbusy(struct comedi_device *dev,
 			      struct comedi_subdevice *s)
@@ -1162,8 +1161,10 @@ static int check_insn_config_length(struct comedi_insn *insn,
 		if (insn->n == 6)
 			return 0;
 		break;
-		/* by default we allow the insn since we don't have checks for
-		 * all possible cases yet */
+		/*
+		 * by default we allow the insn since we don't have checks for
+		 * all possible cases yet
+		 */
 	default:
 		pr_warn("No check for data length of config insn id %i is implemented\n",
 			data[0]);
@@ -1314,9 +1315,11 @@ static int parse_insn(struct comedi_device *dev, struct comedi_insn *insn,
 			if (insn->n != 2) {
 				ret = -EINVAL;
 			} else {
-				/* Most drivers ignore the base channel in
+				/*
+				 * Most drivers ignore the base channel in
 				 * insn->chanspec.  Fix this here if
-				 * the subdevice has <= 32 channels.  */
+				 * the subdevice has <= 32 channels.
+				 */
 				unsigned int orig_mask = data[0];
 				unsigned int shift = 0;
 
@@ -1977,8 +1980,10 @@ static long comedi_unlocked_ioctl(struct file *file, unsigned int cmd,
 
 	mutex_lock(&dev->mutex);
 
-	/* Device config is special, because it must work on
-	 * an unconfigured device. */
+	/*
+	 * Device config is special, because it must work on
+	 * an unconfigured device.
+	 */
 	if (cmd == COMEDI_DEVCONFIG) {
 		if (minor >= COMEDI_NUM_BOARD_MINORS) {
 			/* Device config not appropriate on non-board minors. */
@@ -1990,8 +1995,10 @@ static long comedi_unlocked_ioctl(struct file *file, unsigned int cmd,
 		if (rc == 0) {
 			if (arg == 0 &&
 			    dev->minor >= comedi_num_legacy_minors) {
-				/* Successfully unconfigured a dynamically
-				 * allocated device.  Try and remove it. */
+				/*
+				 * Successfully unconfigured a dynamically
+				 * allocated device.  Try and remove it.
+				 */
 				if (comedi_clear_board_dev(dev)) {
 					mutex_unlock(&dev->mutex);
 					comedi_free_board_dev(dev);
-- 
2.1.4

