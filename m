Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab3I3KMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:12:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43408 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3I3KLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 018/104] USB: mos7720: fix big-endian control requests
Date: Mon, 30 Sep 2013 11:09:55 +0100
Message-Id: <1380535881-9239-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 3b716caf190ccc6f2a09387210e0e6a26c1d81a4 upstream.

Fix endianess bugs in parallel-port code which caused corrupt
control-requests to be issued on big-endian machines.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mos7720.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index feda880..e1c35fb 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -387,8 +387,8 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
 	}
 	urbtrack->setup->bRequestType = (__u8)0x40;
 	urbtrack->setup->bRequest = (__u8)0x0e;
-	urbtrack->setup->wValue = get_reg_value(reg, dummy);
-	urbtrack->setup->wIndex = get_reg_index(reg);
+	urbtrack->setup->wValue = cpu_to_le16(get_reg_value(reg, dummy));
+	urbtrack->setup->wIndex = cpu_to_le16(get_reg_index(reg));
 	urbtrack->setup->wLength = 0;
 	usb_fill_control_urb(urbtrack->urb, usbdev,
 			     usb_sndctrlpipe(usbdev, 0),
-- 
1.8.3.2

