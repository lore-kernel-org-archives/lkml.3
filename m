Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab3FPWJZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:09:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46396 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755700Ab3FPWJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.873229715@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [39/83] USB: serial: fix Treo/Kyocera interrrupt-in urb context
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5f8e2c07d75967ee49a5da1d21ddf5f50d48cda0 upstream.

The first and second interrupt-in urbs are swapped for some Treo/Kyocera
devices, but the urb context was never updated with the new port.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/visor.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -600,6 +600,7 @@ static int treo_attach(struct usb_serial
 		dest->bulk_in_endpointAddress = src->bulk_in_endpointAddress;\
 		dest->bulk_in_buffer = src->bulk_in_buffer;		\
 		dest->interrupt_in_urb = src->interrupt_in_urb;		\
+		dest->interrupt_in_urb->context = dest;			\
 		dest->interrupt_in_endpointAddress = \
 					src->interrupt_in_endpointAddress;\
 		dest->interrupt_in_buffer = src->interrupt_in_buffer;	\

