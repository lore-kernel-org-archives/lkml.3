Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294AbaJCW6E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:58:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932585AbaJCWYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lei Liu <lei35151@163.com>, Johan Hovold <johan@kernel.org>
Subject: [PATCH 3.10 051/143] USB: zte_ev: fix removed PIDs
Date: Fri,  3 Oct 2014 14:34:06 -0700
Message-Id: <20141003213316.015341537@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 3096691011d01cef56b243a5e65431405c07d574 upstream.

Add back some PIDs that were mistakingly remove when reverting commit
73228a0538a7 ("USB: option,zte_ev: move most ZTE CDMA devices to
zte_ev"), which apparently did more than its commit message claimed in
that it not only moved some PIDs from option to zte_ev but also added
some new ones.

Fixes: 63a901c06e3c ("Revert "USB: option,zte_ev: move most ZTE CDMA
devices to zte_ev"")

Reported-by: Lei Liu <lei35151@163.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/zte_ev.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/zte_ev.c
+++ b/drivers/usb/serial/zte_ev.c
@@ -273,6 +273,14 @@ static void zte_ev_usb_serial_close(stru
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


