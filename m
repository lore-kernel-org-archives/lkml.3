Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3FPWJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:09:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46399 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755749Ab3FPWJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:04 -0400
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
Message-ID: <lsq.1371420098.274521478@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [40/83] USB: visor: fix initialisation of Treo/Kyocera devices
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

commit 420021a395ce38b7ab2cceb52dee4038be7d8fa3 upstream.

Fix regression introduced by commit 214916f2e ("USB: visor: reimplement
using generic framework") which broke initialisation of Treo/Kyocera
devices that re-mapped bulk-in endpoints.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2: only copy bulk_in_size as the other new fields
 don't exist here]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/visor.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/visor.c
+++ b/drivers/usb/serial/visor.c
@@ -599,6 +599,7 @@ static int treo_attach(struct usb_serial
 		dest->read_urb = src->read_urb;				\
 		dest->bulk_in_endpointAddress = src->bulk_in_endpointAddress;\
 		dest->bulk_in_buffer = src->bulk_in_buffer;		\
+		dest->bulk_in_size = src->bulk_in_size;			\
 		dest->interrupt_in_urb = src->interrupt_in_urb;		\
 		dest->interrupt_in_urb->context = dest;			\
 		dest->interrupt_in_endpointAddress = \

