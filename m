Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbbA2BrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:47:14 -0500
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:53884 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757813AbbA2BrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:47:07 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] staging: comedi: comedi_fops.c: reformat ioctl handler comments
Date: Wed, 28 Jan 2015 18:41:47 +0000
Message-Id: <1422470510-9309-4-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
References: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unlocked_ioctl handler calls a different function to handle each
supported ioctl command code.  Most of these have a block comment
indicating which command code it handles, a brief description, and an
informal description of the inputs and outputs.  These block comments
are formatted in various styles.  Reformat them to the usual block
comment style and do a bit of rewording for consistency.  The comment
block for the `COMEDI_CMD` ioctl is missing, so add one.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 334 ++++++++++++++++++-----------------
 1 file changed, 168 insertions(+), 166 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 8f65097..5403af1 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -740,18 +740,18 @@ static int is_device_busy(struct comedi_device *dev)
 }
 
 /*
-	COMEDI_DEVCONFIG
-	device config ioctl
-
-	arg:
-		pointer to devconfig structure
-
-	reads:
-		devconfig structure at arg
-
-	writes:
-		none
-*/
+ * COMEDI_DEVCONFIG ioctl
+ * attaches (and configures) or detaches a legacy device
+ *
+ * arg:
+ *	pointer to comedi_devconfig structure (NULL if detaching)
+ *
+ * reads:
+ *	comedi_devconfig structure (if attaching)
+ *
+ * writes:
+ *	nothing
+ */
 static int do_devconfig_ioctl(struct comedi_device *dev,
 			      struct comedi_devconfig __user *arg)
 {
@@ -792,19 +792,18 @@ static int do_devconfig_ioctl(struct comedi_device *dev,
 }
 
 /*
-	COMEDI_BUFCONFIG
-	buffer configuration ioctl
-
-	arg:
-		pointer to bufconfig structure
-
-	reads:
-		bufconfig at arg
-
-	writes:
-		modified bufconfig at arg
-
-*/
+ * COMEDI_BUFCONFIG ioctl
+ * buffer configuration
+ *
+ * arg:
+ *	pointer to comedi_bufconfig structure
+ *
+ * reads:
+ *	comedi_bufconfig structure
+ *
+ * writes:
+ *	modified comedi_bufconfig structure
+ */
 static int do_bufconfig_ioctl(struct comedi_device *dev,
 			      struct comedi_bufconfig __user *arg)
 {
@@ -854,19 +853,18 @@ copyback:
 }
 
 /*
-	COMEDI_DEVINFO
-	device info ioctl
-
-	arg:
-		pointer to devinfo structure
-
-	reads:
-		none
-
-	writes:
-		devinfo structure
-
-*/
+ * COMEDI_DEVINFO ioctl
+ * device info
+ *
+ * arg:
+ *	pointer to comedi_devinfo structure
+ *
+ * reads:
+ *	nothing
+ *
+ * writes:
+ *	comedi_devinfo structure
+ */
 static int do_devinfo_ioctl(struct comedi_device *dev,
 			    struct comedi_devinfo __user *arg,
 			    struct file *file)
@@ -901,19 +899,18 @@ static int do_devinfo_ioctl(struct comedi_device *dev,
 }
 
 /*
-	COMEDI_SUBDINFO
-	subdevice info ioctl
-
-	arg:
-		pointer to array of subdevice info structures
-
-	reads:
-		none
-
-	writes:
-		array of subdevice info structures at arg
-
-*/
+ * COMEDI_SUBDINFO ioctl
+ * subdevices info
+ *
+ * arg:
+ *	pointer to array of comedi_subdinfo structures
+ *
+ * reads:
+ *	nothing
+ *
+ * writes:
+ *	array of comedi_subdinfo structures
+ */
 static int do_subdinfo_ioctl(struct comedi_device *dev,
 			     struct comedi_subdinfo __user *arg, void *file)
 {
@@ -975,19 +972,19 @@ static int do_subdinfo_ioctl(struct comedi_device *dev,
 }
 
 /*
-	COMEDI_CHANINFO
-	subdevice info ioctl
-
-	arg:
-		pointer to chaninfo structure
-
-	reads:
-		chaninfo structure at arg
-
-	writes:
-		arrays at elements of chaninfo structure
-
-*/
+ * COMEDI_CHANINFO ioctl
+ * subdevice channel info
+ *
+ * arg:
+ *	pointer to comedi_chaninfo structure
+ *
+ * reads:
+ *	comedi_chaninfo structure
+ *
+ * writes:
+ *	array of maxdata values to chaninfo->maxdata_list if requested
+ *	array of range table lengths to chaninfo->range_table_list if requested
+ */
 static int do_chaninfo_ioctl(struct comedi_device *dev,
 			     struct comedi_chaninfo __user *arg)
 {
@@ -1035,20 +1032,19 @@ static int do_chaninfo_ioctl(struct comedi_device *dev,
 	return 0;
 }
 
- /*
-    COMEDI_BUFINFO
-    buffer information ioctl
-
-    arg:
-    pointer to bufinfo structure
-
-    reads:
-    bufinfo at arg
-
-    writes:
-    modified bufinfo at arg
-
-  */
+/*
+ * COMEDI_BUFINFO ioctl
+ * buffer information
+ *
+ * arg:
+ *	pointer to comedi_bufinfo structure
+ *
+ * reads:
+ *	comedi_bufinfo structure
+ *
+ * writes:
+ *	modified comedi_bufinfo structure
+ */
 static int do_bufinfo_ioctl(struct comedi_device *dev,
 			    struct comedi_bufinfo __user *arg, void *file)
 {
@@ -1357,19 +1353,19 @@ out:
 }
 
 /*
- *	COMEDI_INSNLIST
- *	synchronous instructions
+ * COMEDI_INSNLIST ioctl
+ * synchronous instruction list
  *
- *	arg:
- *		pointer to sync cmd structure
+ * arg:
+ *	pointer to comedi_insnlist structure
  *
- *	reads:
- *		sync cmd struct at arg
- *		instruction list
- *		data (for writes)
+ * reads:
+ *	comedi_insnlist structure
+ *	array of comedi_insn structures from insnlist->insns pointer
+ *	data (for writes) from insns[].data pointers
  *
- *	writes:
- *		data (for reads)
+ * writes:
+ *	data (for reads) to insns[].data pointers
  */
 /* arbitrary limits */
 #define MAX_SAMPLES 256
@@ -1446,18 +1442,18 @@ error:
 }
 
 /*
- *	COMEDI_INSN
- *	synchronous instructions
+ * COMEDI_INSN ioctl
+ * synchronous instruction
  *
- *	arg:
- *		pointer to insn
+ * arg:
+ *	pointer to comedi_insn structure
  *
- *	reads:
- *		struct comedi_insn struct at arg
- *		data (for writes)
+ * reads:
+ *	comedi_insn structure
+ *	data (for writes) from insn->data pointer
  *
- *	writes:
- *		data (for reads)
+ * writes:
+ *	data (for reads) to insn->data pointer
  */
 static int do_insn_ioctl(struct comedi_device *dev,
 			 struct comedi_insn __user *arg, void *file)
@@ -1589,6 +1585,20 @@ static int __comedi_get_user_chanlist(struct comedi_device *dev,
 	return 0;
 }
 
+/*
+ * COMEDI_CMD ioctl
+ * asynchronous acquisition command set-up
+ *
+ * arg:
+ *	pointer to comedi_cmd structure
+ *
+ * reads:
+ *	comedi_cmd structure
+ *	channel/range list from cmd->chanlist pointer
+ *
+ * writes:
+ *	possibly modified comedi_cmd structure (when -EAGAIN returned)
+ */
 static int do_cmd_ioctl(struct comedi_device *dev,
 			struct comedi_cmd __user *arg, void *file)
 {
@@ -1684,20 +1694,19 @@ cleanup:
 }
 
 /*
-	COMEDI_CMDTEST
-	command testing ioctl
-
-	arg:
-		pointer to cmd structure
-
-	reads:
-		cmd structure at arg
-		channel/range list
-
-	writes:
-		modified cmd structure at arg
-
-*/
+ * COMEDI_CMDTEST ioctl
+ * asynchronous aquisition command testing
+ *
+ * arg:
+ *	pointer to comedi_cmd structure
+ *
+ * reads:
+ *	comedi_cmd structure
+ *	channel/range list from cmd->chanlist pointer
+ *
+ * writes:
+ *	possibly modified comedi_cmd structure
+ */
 static int do_cmdtest_ioctl(struct comedi_device *dev,
 			    struct comedi_cmd __user *arg, void *file)
 {
@@ -1740,20 +1749,18 @@ static int do_cmdtest_ioctl(struct comedi_device *dev,
 }
 
 /*
-	COMEDI_LOCK
-	lock subdevice
-
-	arg:
-		subdevice number
-
-	reads:
-		none
-
-	writes:
-		none
-
-*/
-
+ * COMEDI_LOCK ioctl
+ * lock subdevice
+ *
+ * arg:
+ *	subdevice number
+ *
+ * reads:
+ *	nothing
+ *
+ * writes:
+ *	nothing
+ */
 static int do_lock_ioctl(struct comedi_device *dev, unsigned long arg,
 			 void *file)
 {
@@ -1776,21 +1783,18 @@ static int do_lock_ioctl(struct comedi_device *dev, unsigned long arg,
 }
 
 /*
-	COMEDI_UNLOCK
-	unlock subdevice
-
-	arg:
-		subdevice number
-
-	reads:
-		none
-
-	writes:
-		none
-
-	This function isn't protected by the semaphore, since
-	we already own the lock.
-*/
+ * COMEDI_UNLOCK ioctl
+ * unlock subdevice
+ *
+ * arg:
+ *	subdevice number
+ *
+ * reads:
+ *	nothing
+ *
+ * writes:
+ *	nothing
+ */
 static int do_unlock_ioctl(struct comedi_device *dev, unsigned long arg,
 			   void *file)
 {
@@ -1813,19 +1817,18 @@ static int do_unlock_ioctl(struct comedi_device *dev, unsigned long arg,
 }
 
 /*
-	COMEDI_CANCEL
-	cancel acquisition ioctl
-
-	arg:
-		subdevice number
-
-	reads:
-		nothing
-
-	writes:
-		nothing
-
-*/
+ * COMEDI_CANCEL ioctl
+ * cancel asynchronous acquisition
+ *
+ * arg:
+ *	subdevice number
+ *
+ * reads:
+ *	nothing
+ *
+ * writes:
+ *	nothing
+ */
 static int do_cancel_ioctl(struct comedi_device *dev, unsigned long arg,
 			   void *file)
 {
@@ -1847,19 +1850,18 @@ static int do_cancel_ioctl(struct comedi_device *dev, unsigned long arg,
 }
 
 /*
-	COMEDI_POLL ioctl
-	instructs driver to synchronize buffers
-
-	arg:
-		subdevice number
-
-	reads:
-		nothing
-
-	writes:
-		nothing
-
-*/
+ * COMEDI_POLL ioctl
+ * instructs driver to synchronize buffers
+ *
+ * arg:
+ *	subdevice number
+ *
+ * reads:
+ *	nothing
+ *
+ * writes:
+ *	nothing
+ */
 static int do_poll_ioctl(struct comedi_device *dev, unsigned long arg,
 			 void *file)
 {
-- 
2.1.4

