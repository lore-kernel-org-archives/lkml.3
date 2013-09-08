Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab3IHDUN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56010 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714Ab3IHDSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:47 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jussi Kivilinna" <jussi.kivilinna@iki.fi>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.617189924@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [063/121] zd1201: do not use stack as URB transfer_buffer
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

commit 1206ff4ff9d2ef7468a355328bc58ac6ebf5be44 upstream.

Patch fixes zd1201 not to use stack as URB transfer_buffer. URB buffers need
to be DMA-able, which stack is not.

Patch is only compile tested.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/zd1201.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -98,10 +98,12 @@ static int zd1201_fw_upload(struct usb_d
 		goto exit;
 
 	err = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0), 0x4,
-	    USB_DIR_IN | 0x40, 0,0, &ret, sizeof(ret), ZD1201_FW_TIMEOUT);
+	    USB_DIR_IN | 0x40, 0, 0, buf, sizeof(ret), ZD1201_FW_TIMEOUT);
 	if (err < 0)
 		goto exit;
 
+	memcpy(&ret, buf, sizeof(ret));
+
 	if (ret & 0x80) {
 		err = -EIO;
 		goto exit;

