Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448AbaJIVDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:03:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58900 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbaJIVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 016/163] USB: zte_ev: fix removed PIDs
Date: Thu,  9 Oct 2014 14:00:41 -0700
Message-Id: <1412888588-26755-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 4df0ea41af9dce89daa9f1cb968884b346d168c9 upstream.

Add back some PIDs that were mistakingly remove when reverting commit
73228a0538a7 ("USB: option,zte_ev: move most ZTE CDMA devices to
zte_ev"), which apparently did more than its commit message claimed in
that it not only moved some PIDs from option to zte_ev but also added
some new ones.

Fixes: 63a901c06e3c ("Revert "USB: option,zte_ev: move most ZTE CDMA
devices to zte_ev"")

Reported-by: Lei Liu <lei35151@163.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/zte_ev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/serial/zte_ev.c b/drivers/usb/serial/zte_ev.c
index 88dd32c..d6a3fbd 100644
--- a/drivers/usb/serial/zte_ev.c
+++ b/drivers/usb/serial/zte_ev.c
@@ -273,6 +273,14 @@ static void zte_ev_usb_serial_close(struct usb_serial_port *port)
 }
 
 static const struct usb_device_id id_table[] = {
+	{ USB_DEVICE(0x19d2, 0xffec) },
+	{ USB_DEVICE(0x19d2, 0xffee) },
+	{ USB_DEVICE(0x19d2, 0xfff6) },
+	{ USB_DEVICE(0x19d2, 0xfff7) },
+	{ USB_DEVICE(0x19d2, 0xfff8) },
+	{ USB_DEVICE(0x19d2, 0xfff9) },
+	{ USB_DEVICE(0x19d2, 0xfffb) },
+	{ USB_DEVICE(0x19d2, 0xfffc) },
 	/* MG880 */
 	{ USB_DEVICE(0x19d2, 0xfffd) },
 	{ },
-- 
1.9.1

