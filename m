Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbbA2CWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:22:13 -0500
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:57831 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758932AbbA2BwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:52:06 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] staging: comedi: range.c: reformat ioctl handler comment
Date: Wed, 28 Jan 2015 18:41:48 +0000
Message-Id: <1422470510-9309-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
References: <1422470510-9309-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The unlocked_ioctl handler in "comedi_fops.c" calls a different function
to handle each supported ioctl command code.  Most of these have a block
comment indicating which command code it handles, a brief description,
and an informal description of the inputs and outputs.  These block
comments were formatted in various styles, but have been reformatted to
use the usual block comment style.

The block comment for the handler function for the `COMEDI_RANGEINFO`
ioctl code is in "range.c".  Reformat it to use the usual block command
style to match the others.  Reword it a bit for consistency.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/range.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/comedi/range.c b/drivers/staging/comedi/range.c
index 9a1dc56..00e71c7 100644
--- a/drivers/staging/comedi/range.c
+++ b/drivers/staging/comedi/range.c
@@ -42,18 +42,18 @@ const struct comedi_lrange range_unknown = { 1, {{0, 1000000, UNIT_none} } };
 EXPORT_SYMBOL_GPL(range_unknown);
 
 /*
-	COMEDI_RANGEINFO
-	range information ioctl
-
-	arg:
-		pointer to rangeinfo structure
-
-	reads:
-		range info structure
-
-	writes:
-		n struct comedi_krange structures to rangeinfo->range_ptr
-*/
+ * COMEDI_RANGEINFO ioctl
+ * range information
+ *
+ * arg:
+ *	pointer to comedi_rangeinfo structure
+ *
+ * reads:
+ *	comedi_rangeinfo structure
+ *
+ * writes:
+ *	array of comedi_krange structures to rangeinfo->range_ptr pointer
+ */
 int do_rangeinfo_ioctl(struct comedi_device *dev,
 		       struct comedi_rangeinfo __user *arg)
 {
-- 
2.1.4

