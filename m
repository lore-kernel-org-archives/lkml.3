Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3L2CKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:10:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55029 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab3L2CKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:01 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Thomas Pugliese" <thomas.pugliese@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.973880629@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 016/185] usb: wusbcore: change WA_SEGS_MAX to a legal
 value
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Pugliese <thomas.pugliese@gmail.com>

commit f74b75e7f920c700636cccca669c7d16d12e9202 upstream.

change WA_SEGS_MAX to a number that is legal according to the WUSB
spec.

Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/wusbcore/wa-xfer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -90,7 +90,8 @@
 #include "wusbhc.h"
 
 enum {
-	WA_SEGS_MAX = 255,
+	/* [WUSB] section 8.3.3 allocates 7 bits for the segment index. */
+	WA_SEGS_MAX = 128,
 };
 
 enum wa_seg_status {
@@ -444,7 +445,7 @@ static ssize_t __wa_xfer_setup_sizes(str
 	xfer->seg_size = (xfer->seg_size / maxpktsize) * maxpktsize;
 	xfer->segs = (urb->transfer_buffer_length + xfer->seg_size - 1)
 		/ xfer->seg_size;
-	if (xfer->segs >= WA_SEGS_MAX) {
+	if (xfer->segs > WA_SEGS_MAX) {
 		dev_err(dev, "BUG? ops, number of segments %d bigger than %d\n",
 			(int)(urb->transfer_buffer_length / xfer->seg_size),
 			WA_SEGS_MAX);

