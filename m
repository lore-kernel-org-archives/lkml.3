Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab3IYBQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:16:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab3IYAQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        kbuild test robot <fengguang.wu@intel.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 035/110] USB: mos7720: fix big-endian control requests
Date: Tue, 24 Sep 2013 17:14:33 -0700
Message-Id: <20130925001327.207097588@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 3b716caf190ccc6f2a09387210e0e6a26c1d81a4 upstream.

Fix endianess bugs in parallel-port code which caused corrupt
control-requests to be issued on big-endian machines.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7720.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -382,8 +382,8 @@ static int write_parport_reg_nonblock(st
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


