Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbaJ1RQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:16:10 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:38899 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbaJ1RQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:16:08 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: widen subdevice number argument in ioctl handlers
Date: Tue, 28 Oct 2014 17:15:47 +0000
Message-Id: <1414516547-20661-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the `COMEDI_LOCK`, `COMEDI_UNLOCK`, `COMEDI_CANCEL`, and
`COMEDI_POLL` ioctls the third argument is a comedi subdevice number.
This is passed as an `unsigned long`, but when it is passed down to the
ioctl command-specific handler functions `do_lock_ioctl()`,
`do_unlock_ioctl()`, `do_cancel_ioctl()`, and `do_poll_ioctl()`, the
value has been narrowed to an `unsigned int`.  Pass through the argument
as an `unsigned long` to avoid truncating the value on 64-bit
architectures.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 224af2b..ab6cbc8 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1642,7 +1642,7 @@ static int do_cmdtest_ioctl(struct comedi_device *dev,
 
 */
 
-static int do_lock_ioctl(struct comedi_device *dev, unsigned int arg,
+static int do_lock_ioctl(struct comedi_device *dev, unsigned long arg,
 			 void *file)
 {
 	int ret = 0;
@@ -1679,7 +1679,7 @@ static int do_lock_ioctl(struct comedi_device *dev, unsigned int arg,
 	This function isn't protected by the semaphore, since
 	we already own the lock.
 */
-static int do_unlock_ioctl(struct comedi_device *dev, unsigned int arg,
+static int do_unlock_ioctl(struct comedi_device *dev, unsigned long arg,
 			   void *file)
 {
 	struct comedi_subdevice *s;
@@ -1714,7 +1714,7 @@ static int do_unlock_ioctl(struct comedi_device *dev, unsigned int arg,
 		nothing
 
 */
-static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
+static int do_cancel_ioctl(struct comedi_device *dev, unsigned long arg,
 			   void *file)
 {
 	struct comedi_subdevice *s;
@@ -1748,7 +1748,7 @@ static int do_cancel_ioctl(struct comedi_device *dev, unsigned int arg,
 		nothing
 
 */
-static int do_poll_ioctl(struct comedi_device *dev, unsigned int arg,
+static int do_poll_ioctl(struct comedi_device *dev, unsigned long arg,
 			 void *file)
 {
 	struct comedi_subdevice *s;
-- 
2.1.1

