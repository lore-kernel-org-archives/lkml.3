Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbaJGXiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 19:38:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbaJGXTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 19:19:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        kbuild test robot <fengguang.wu@intel.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3.16 20/26] uas: Add missing le16_to_cpu calls to asm1051 / asm1053 usb-id check
Date: Tue,  7 Oct 2014 16:19:36 -0700
Message-Id: <20141007231849.082944437@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141007231848.487609292@linuxfoundation.org>
References: <20141007231848.487609292@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit a79e5bc53a9519202dfad7d916761601fcbf8db1 upstream.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/uas-detect.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -73,8 +73,8 @@ static int uas_use_uas_driver(struct usb
 	 * broken on the ASM1051, use the number of streams to differentiate.
 	 * New ASM1053-s also support 32 streams, but have a different prod-id.
 	 */
-	if (udev->descriptor.idVendor == 0x174c &&
-			udev->descriptor.idProduct == 0x55aa) {
+	if (le16_to_cpu(udev->descriptor.idVendor) == 0x174c &&
+			le16_to_cpu(udev->descriptor.idProduct) == 0x55aa) {
 		if (udev->speed < USB_SPEED_SUPER) {
 			/* No streams info, assume ASM1051 */
 			flags |= US_FL_IGNORE_UAS;


