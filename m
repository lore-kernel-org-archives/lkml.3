Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692Ab3KYNQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:16:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57236 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3KYNIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Pugliese <thomas.pugliese@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 54/78] usb: wusbcore: change WA_SEGS_MAX to a legal value
Date: Mon, 25 Nov 2013 13:06:41 +0000
Message-Id: <1385384825-21681-55-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Pugliese <thomas.pugliese@gmail.com>

commit f74b75e7f920c700636cccca669c7d16d12e9202 upstream.

change WA_SEGS_MAX to a number that is legal according to the WUSB
spec.

Signed-off-by: Thomas Pugliese <thomas.pugliese@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/wusbcore/wa-xfer.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 1ebc17e..8cf9003 100644
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
@@ -444,7 +445,7 @@ static ssize_t __wa_xfer_setup_sizes(struct wa_xfer *xfer,
 	xfer->seg_size = (xfer->seg_size / maxpktsize) * maxpktsize;
 	xfer->segs = (urb->transfer_buffer_length + xfer->seg_size - 1)
 		/ xfer->seg_size;
-	if (xfer->segs >= WA_SEGS_MAX) {
+	if (xfer->segs > WA_SEGS_MAX) {
 		dev_err(dev, "BUG? ops, number of segments %d bigger than %d\n",
 			(int)(urb->transfer_buffer_length / xfer->seg_size),
 			WA_SEGS_MAX);
-- 
1.8.3.2

