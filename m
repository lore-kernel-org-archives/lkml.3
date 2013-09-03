Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab3ICQ2q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:28:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46617 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab3ICQ2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:28:44 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 36/58] zd1201: do not use stack as URB transfer_buffer
Date: Tue,  3 Sep 2013 09:23:40 -0700
Message-Id: <1378225442-20654-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

commit 1206ff4ff9d2ef7468a355328bc58ac6ebf5be44 upstream.

Patch fixes zd1201 not to use stack as URB transfer_buffer. URB buffers need
to be DMA-able, which stack is not.

Patch is only compile tested.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/zd1201.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index 48273dd..4312eca 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -98,10 +98,12 @@ static int zd1201_fw_upload(struct usb_device *dev, int apfw)
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
-- 
1.8.1.2

