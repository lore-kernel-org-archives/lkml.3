Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3ITUV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:21:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41669 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755061Ab3ITUOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 25/93] USB: mos7720: fix big-endian control requests
Date: Fri, 20 Sep 2013 13:08:20 -0700
Message-Id: <1379707768-1804-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 3b716caf190ccc6f2a09387210e0e6a26c1d81a4 upstream.

Fix endianess bugs in parallel-port code which caused corrupt
control-requests to be issued on big-endian machines.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/mos7720.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index cdb3823..c5afc94 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -383,8 +383,8 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
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
1.8.1.2

