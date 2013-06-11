Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab3FKU3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:29:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41711 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756404Ab3FKUDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 14/32] USB: serial: fix Treo/Kyocera interrrupt-in urb context
Date: Tue, 11 Jun 2013 13:03:13 -0700
Message-Id: <20130611200127.795683855@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611200126.214442788@linuxfoundation.org>
References: <20130611200126.214442788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5f8e2c07d75967ee49a5da1d21ddf5f50d48cda0 upstream.

The first and second interrupt-in urbs are swapped for some Treo/Kyocera
devices, but the urb context was never updated with the new port.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/visor.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -608,6 +608,7 @@ static int treo_attach(struct usb_serial
 		dest->bulk_in_buffer = src->bulk_in_buffer;		\
 		dest->bulk_in_size = src->bulk_in_size;			\
 		dest->interrupt_in_urb = src->interrupt_in_urb;		\
+		dest->interrupt_in_urb->context = dest;			\
 		dest->interrupt_in_endpointAddress = \
 					src->interrupt_in_endpointAddress;\
 		dest->interrupt_in_buffer = src->interrupt_in_buffer;	\


